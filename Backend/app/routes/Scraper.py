import json
import uuid
from typing import Optional
from uuid import UUID
from bs4 import BeautifulSoup
import cloudscraper
from pathlib import Path
from fastapi import APIRouter, status, HTTPException
from pydantic import BaseModel, AnyHttpUrl

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "Data"
DATA_DIR.mkdir(exist_ok=True)
DATA_FILE =  DATA_DIR/"storage.json"
router = APIRouter(prefix="/data", tags=["data"])

class DataInput(BaseModel):
    target_url:AnyHttpUrl
    rawData: list[Optional[str]] = None
    organizedData: Optional[str] = None

class DataOut(BaseModel):
    id: UUID
    target_url: str
    rawData: list[Optional[str]]
    organizedData: str

def saveData(data):
    existing_data = []
    if DATA_FILE.exists() and DATA_FILE.stat().st_size > 0:
        try:
            with open(DATA_FILE, "r", encoding="utf-8") as f:
                existing_data = json.load(f)
        except json.JSONDecodeError:
            existing_data = []

    existing_data.append(data)

    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(existing_data, f, indent=2)

@router.post("/scraper", response_model=DataOut, status_code=status.HTTP_201_CREATED)
def storeTempData(payload: DataInput):
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Referer': 'https://google.com',
            'DNT': '1'
        }

        scraper = cloudscraper.create_scraper(
            browser={
                'browser': 'chrome',
                'platform': 'windows',
                'desktop': True
            }
        )

        target_url = str(payload.target_url)

        html_text = scraper.get(target_url, headers=headers, timeout=10)
        html_text.raise_for_status()

        soup = BeautifulSoup(html_text.text, 'lxml')
        scraped_text = soup.get_text(separator="\n", strip=True)

        target_url = str(payload.target_url)

        formatted_text = f"Organized content extracted from: {target_url}"
        raw_lines = [line.strip() for line in scraped_text.splitlines() if line and line.strip()]
        result = {
            "id" : str(uuid.uuid4()),
            "target_url": target_url,
            "rawData": raw_lines,
            "organizedData": formatted_text
        }

        saveData(result)

        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Failed to scrape URL: {str(e)}"
        )
