from enum import Enum
from typing import Optional
from pydantic import BaseModel, Field, HttpUrl

class IssueStatus(str, Enum):
    open = "Open"
    In_Progress = "In progress"
    done = "Done"

class IssuePriority(str, Enum):
    low = "Low"
    medium = "Medium"
    high = "High"

class IssueCreate(BaseModel):
    url : HttpUrl = Field(min_length=1, max_length=5000)
    prompt : str = Field(min_length=1, max_length=5000)
    priority: IssuePriority = IssuePriority.high

class IssueUpdate(BaseModel):
    url: Optional[HttpUrl] = Field(default=None,min_length=1, max_length=5000)
    prompt: Optional[str] = Field(default=None,min_length=1, max_length=5000)
    priority: Optional[IssuePriority] = None
    status: Optional[IssueStatus] = None

class IssueOut(BaseModel):
    id: str
    url : str
    prompt : str
    status : IssueStatus
    priority : IssuePriority