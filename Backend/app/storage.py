from pathlib import Path
import json

from sqlalchemy.testing.pickleable import Parent

DATA_DIR = Path("Data")
DATA_FILE = DATA_DIR / "issues.json"

def load_data():
    if DATA_FILE.exists():
        with open(DATA_FILE, "r") as r:
            contents = r.read()
            if contents.strip():

                return json.loads(contents)
    return []

def save_data(data):
    DATA_DIR.mkdir(parents = True, exist_ok = True)
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)