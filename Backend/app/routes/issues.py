import uuid
from langchain.agents import create_agent
from dotenv import load_dotenv
from ..schemas import IssueCreate, IssueOut, IssueUpdate, IssueStatus, IssuePriority
from ..storage import save_data, load_data
from fastapi import FastAPI , HTTPException, APIRouter, status
import httpx



router = APIRouter(prefix="/issues", tags=["issues"])
@router.get("/", response_model = list[IssueOut])

async def get_issues():
    issues = load_data()
    return issues

@router.post("/", response_model=IssueOut, status_code=status.HTTP_201_CREATED)
def create_issues(payload: IssueCreate):
    issues = load_data()
    new_issue = {
        "id" : str(uuid.uuid4()),
        "url" : str(payload.url),
        "prompt" : payload.prompt,
        "priority" : payload.priority.value,
        "status" : "Open"
    }

    issues.append(new_issue)
    save_data(issues)
    return new_issue

@router.get("/{issue_id}", response_model= IssueOut)
def get_issue(issue_id: str ):
    issues = load_data()
    for issue in issues:
        if issue["id"] == issue_id:
            return issue
    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Issue not found")


@router.put("/{issue_id}", response_model=IssueOut)
def update_issue(issue_id : str, payload: IssueUpdate):
    issues = load_data()

    for issue in issues:
        if issue["id"] == issue_id:
            if payload.prompt is not None:
                issue["prompt"] = payload.prompt
            if payload.priority is not None:
                issue["priority"] = payload.priority.value
            if payload.status is not None:
                issue["status"] = payload.status.value
            save_data(issues)
            return issue

    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="issue not found"
    )


@router.delete("/{issue_id}", status_code=status.HTTP_204_NO_CONTENT)
def issue_delete(issue_id: str):
    issues = load_data()
    for index, issue in enumerate(issues):
        if issue["id"] == issue_id:
            issues.pop(index)
            save_data(issues)
            return
    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Issue not found ")


