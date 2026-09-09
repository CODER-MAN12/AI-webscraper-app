import json
import os
from pathlib import Path
from uuid import UUID
from fastapi import APIRouter, status, HTTPException
from pydantic import BaseModel
import pandas as pd
from langchain.chat_models import init_chat_model
from langchain.agents import create_agent

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "Data"
DATA_DIR.mkdir(exist_ok=True)
DATA_FILE = DATA_DIR / "storage.json"

DOWNLOADS_DIR = Path.home() / "Downloads"
DOWNLOADS_DIR.mkdir(exist_ok=True)

router1 = APIRouter(prefix="/data/excel", tags=["Excel"])

defaultPrompt = """
You are a senior business intelligence analyst and presentation designer. Your task is to analyze preloaded Excel dataset/tabular data and translate it into a high-impact, data-driven pitch deck or executive reporting deck.

INPUT:
- Structured data from an Excel workbook (tables, metrics, financial reports, or transactional records).

RULES & GOALS:
1. Data-to-Insight: Do not just list raw numbers. Identify key trends, outliers, quarter-over-quarter growth, or notable benchmarks. Translate numbers into clear narrative conclusions.
2. Slide Structure: For each slide, provide:
   - Slide Title (Highlighting the primary insight, e.g., "Q3 Revenue Increased by 18% Driven by Enterprise Sales")
   - Recommended Chart/Visual Type (e.g., Bar Chart, Line Graph, KPI Dashboard Card, Waterfall Chart)
   - Key Metrics & Callouts (3-4 concise data points with Context/Why it matters)
   - Executive Takeaway (1 summary sentence at the bottom)
3. Formatting Standards: Express numbers cleanly ($M/$K, percentages rounded to 1 decimal place). Ensure clear metric labels and baseline comparisons.
"""


class DataInput(BaseModel):
    id: UUID
    prompt: str = ""


model = init_chat_model(
    model="openai/gpt-4o-mini",
    model_provider="openai",
    base_url="https://openrouter.ai/api/v1",
    temperature=0.3,
)

agent = create_agent(
    model=model,
    tools=[]
)


def process_and_export(scraped_info: dict, user_prompt: str) -> str:
    response = agent.invoke({
        "messages": [
            {"role": "system", "content": defaultPrompt},
            {"role": "user",
             "content": f"User Instructions:\n{user_prompt}\n\nDataset Info:\n{json.dumps(scraped_info)}"}
        ]
    })

    ai_output = response["messages"][-1].content

    output_data = {
        "AI Analysis & Pitch Deck Specs": [ai_output],
        "Source Data ID": [str(scraped_info.get("id", ""))]
    }

    df_analysis = pd.DataFrame(output_data)

    if isinstance(scraped_info, list):
        df_raw = pd.DataFrame(scraped_info)
    elif isinstance(scraped_info, dict):
        df_raw = pd.DataFrame([scraped_info])
    else:
        df_raw = pd.DataFrame({"raw_data": [str(scraped_info)]})

    export_path = DOWNLOADS_DIR / f"analysis_output_{scraped_info.get('id', 'export')}.xlsx"

    with pd.ExcelWriter(export_path, engine="openpyxl") as writer:
        df_analysis.to_excel(writer, sheet_name="AI Deck Insights", index=False)
        df_raw.to_excel(writer, sheet_name="Raw Scraped Data", index=False)

    return str(export_path)


@router1.post("/excel", status_code=status.HTTP_200_OK)
def process_excel_endpoint(payload: DataInput):
    target_id = str(payload.id)
    user_prompt = payload.prompt.strip()

    if not DATA_FILE.exists():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="storage.json file not found",
        )

    with open(DATA_FILE, "r", encoding="utf-8") as r:
        try:
            items = json.load(r)
        except json.JSONDecodeError:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="storage.json contains invalid JSON",
            )

    scraped_info = next(
        (item for item in items if str(item.get("id")) == target_id), None
    )

    if not scraped_info:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No scraped info found for ID: {target_id}",
        )

    if not user_prompt:
        user_prompt = defaultPrompt

    exported_file_path = process_and_export(scraped_info, user_prompt)

    return {
        "status": "success",
        "exported_file": exported_file_path,
        "scraped_info": scraped_info,
        "applied_prompt": user_prompt
    }