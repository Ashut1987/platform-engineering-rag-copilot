# src/state.py
from typing import TypedDict, Literal, Optional

class RepositoryRequest(TypedDict):
    name: str
    owner_team: str
    framework: str
    runtime_version: str
    iac_type: str
    data_classification: str

class PlatformState(TypedDict):
    session_id: str
    user_input: str
    structured_request: Optional[RepositoryRequest]
    retrieved_compliance_docs: Optional[str]
    retrieved_iac_templates: Optional[str]
    validation_passed: bool
    validation_error: Optional[str]
    approval_status: Literal["PENDING", "APPROVED", "REJECTED"]
    repo_created: bool
    cicd_pr_opened: bool
    final_summary: Optional[str]
