import uvicorn
from fastapi import FastAPI


OPENROUTER_KEY = ""


from app.routes.Scraper import router as Scraper_router
from app.routes.PowerPointMaker import router1 as PPTX_maker
from app.routes.ExcelSheetMaker import router2 as excel_maker

app = FastAPI()

app.include_router(PPTX_maker)
app.include_router(Scraper_router)
app.include_router(excel_maker)

if __name__ == "__main__":

    uvicorn.run(app, host="127.0.0.1", port=8000)