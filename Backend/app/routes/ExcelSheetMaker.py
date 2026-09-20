import json
from pathlib import Path
from uuid import UUID
from fastapi import APIRouter, status, HTTPException
from pydantic import BaseModel
import pandas as pd
import openpyxl

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "Data"
DATA_DIR.mkdir(exist_ok=True)
DATA_FILE = DATA_DIR / "storage.json"

DOWNLOADS_DIR = Path.home() / "Downloads"
DOWNLOADS_DIR.mkdir(exist_ok=True)

router2 = APIRouter(prefix="/data/excel", tags=["Excel"])

class DataInput(BaseModel):
    id: UUID

def get_block_by_id(json_file_path: Path, target_id: str) -> dict | None:
    if not json_file_path.exists():
        return None

    try:
        with open(json_file_path, "r", encoding="utf-8") as f:
            items = json.load(f)
    except json.JSONDecodeError:
        return None

    for item in items:
        if str(item.get("id")) == str(target_id):
            return item

    return None

def parse_and_export_to_excel(scraped_info: dict, downloads_dir: Path) -> str:
    raw_data = scraped_info.get("rawData", [])

    parsed_rows = []
    i = 0

    while i < len(raw_data):
        item = raw_data[i]

        if "logged" in item.lower():
            time_logged = item
            devlog_text = raw_data[i + 1] if i + 1 < len(raw_data) else "N/A"

            parsed_rows.append({
                "Time Logged": time_logged,
                "Devlog Details": devlog_text
            })
        i += 1

    if not parsed_rows:
        df = pd.DataFrame({"Raw Content": raw_data})
    else:
        df = pd.DataFrame(parsed_rows)

    file_id = scraped_info.get("id", "output")
    file_path = str(downloads_dir / f"{file_id}_organized.xlsx")

    df.to_excel(file_path, index=False)
    return file_path

@router2.post("", status_code=status.HTTP_200_OK)
def connect_to_flutter(payload: DataInput):
    target_id = str(payload.id)

    # Use your helper function to fetch the block
    scraped_info = get_block_by_id(DATA_FILE, target_id)

    if not scraped_info:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No scraped info found for ID: {target_id}",
        )

    # Generate the organized Excel file
    exported_file_path = parse_and_export_to_excel(scraped_info, DOWNLOADS_DIR)

    return {
        "status": "success",
        "exported_file": exported_file_path,
        "scraped_info": scraped_info,
    }