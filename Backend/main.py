from fastapi import FastAPI
from app.routes.Scraper import router as Scraper_router
from app.routes.PowerPointMaker import router1 as PPTX_maker


app = FastAPI()
app.include_router(PPTX_maker)
app.include_router(Scraper_router)

