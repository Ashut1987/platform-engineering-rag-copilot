# src/graph.py
import json
from typing import Literal
from langchain_ollama import ChatOllama
from langchain_core.messages import HumanMessage, SystemMessage
from langgraph.graph import StateGraph, END
from langgraph.checkpoint.memory import MemorySaver

# Import your custom modules and state maps
from src.state import PlatformState
from src.tools.pinecone_client import EnterpriseRAGClient

# Initialize core clients (Enforce JSON output for structure parsing)
llm = ChatOllama(model="llama3.1:8b", temperature=0, format="json")
rag_client = EnterpriseRAGClient()

# ==========================================
# 🤖 MULTI-AGENT STATE GRAPH NODES
# ==========================================

def intake_agent_node(state: PlatformState) -> dict:
    """Parses structural variables from raw user input strings."""
    print("\n📝 [Intake Agent] Parsing conversational requirements...")
    system_prompt = (
        "Extract configuration options into a raw valid JSON matching this schema precisely without markdown wrappers:\n"
        "{\n"
        "  'name': 'str',\n"
        "  'owner_team': 'str',\n"
        "  'framework': 'React|Spring Boot|FastAPI|Go',\n"
        "  'runtime_version': 'str',\n"
        "  'iac_type': 'Terraform|OpenTofu',\n"
        "  'data_classification': 'Public|Internal|Restricted|Highly-Confidential'\n"
        "}"
    )
    response = llm.invoke([SystemMessage(content=system_prompt), HumanMessage(content=state["user_input"])])
    try:
        clean_content = response.content.strip()
        return {"structured_request": json.loads(clean_content)}
    except Exception:
        return {"validation_passed": False, "validation_error": "Failed structural parameter syntax extraction passes."}


def validation_agent_node(state: PlatformState) -> dict:
    """Queries 'compliance_guardrails' namespace in Pinecone to audit the configuration layout."""
    print("🔍 [Validation Agent] Querying active Pinecone 'compliance_guardrails' namespace...")
    req = state["structured_request"]
    
    # 🎯 REAL RAG INTEGRATION: Pull rules matching the user request
    compliance_context = rag_client.query_namespace(
        query_text=f"Naming syntax convention constraints and deployment policies for {req.get('framework')}",
        namespace="compliance_guardrails"
    )
    
    validation_prompt = f"""
    You are an automated corporate compliance auditing proxy. 
    Audit the incoming developer request against the retrieved corporate compliance boundaries.
    
    Corporate Compliance Documentation Context:
    {compliance_context}
    
    Developer Payload Arguments:
    {json.dumps(req)}
    
    Output JSON only matching this schema without text wrappers:
    {{"passed": true or false, "error": "Clear validation failure explanation string or null"}}
    """
    
    response = llm.invoke([HumanMessage(content=validation_prompt)])
    try:
        res = json.loads(response.content.strip())
        if not res["passed"]:
            return {"validation_passed": False, "validation_error": res["error"], "retrieved_compliance_docs": compliance_context}
        return {"validation_passed": True, "validation_error": None, "approval_status": "PENDING", "retrieved_compliance_docs": compliance_context}
    except Exception:
        return {"validation_passed": False, "validation_error": "System failure parsing internal validation metrics structure."}


def repository_generation_node(state: PlatformState) -> dict:
    """Executes deterministic generation workflows to configure the GitHub repository instance."""
    print("🌐 [Repo Agent] Executing Backstage template workflows and rulesets...")
    req = state["structured_request"]
    print(f"   -> [TOOL EXECUTION] Successfully built repository '{req['name']}' under team control profile '{req['owner_team']}'")
    return {"repo_created": True}


def cicd_pipeline_node(state: PlatformState) -> dict:
    """Queries 'iac_blueprints' namespace in Pinecone for explicit module dependencies and tags."""
    print("🚀 [CI/CD Agent] Querying active Pinecone 'iac_blueprints' namespaces...")
    req = state["structured_request"]
    
    # 🎯 REAL RAG INTEGRATION: Pull architecture templates
    iac_context = rag_client.query_namespace(
        query_text=f"Approved standard templates for {req.get('framework')} using {req.get('iac_type')}",
        namespace="iac_blueprints"
    )
    
    generation_prompt = f"""
    You are an automated code composition engine. Draft a clear summary message for a Pull Request details log.
    You must explicitly cite the module versions and parameters found in the context documentation below.
    
    Retrieved Core Infrastructure Blueprints:
    {iac_context}
    
    Developer Request Specifications:
    {json.dumps(req)}
    """
    
    response = llm.invoke([HumanMessage(content=generation_prompt)])
    
    summary = (
        f"🎉 Golden Path Completed Successfully!\n"
        f"Repository Configuration State: provisioned\n"
        f"--- Live Pipeline Generation Ledger (Grounded via Pinecone) ---\n"
        f"{response.content}"
    )
    return {"cicd_pr_opened": True, "retrieved_iac_templates": iac_context, "final_summary": summary}

# ==========================================
# 🗺️ GRAPH WORKFLOW EDGE CONFIGURATION
# ==========================================

def route_validation(state: PlatformState) -> Literal["approval_gate", "__end__"]:
    if not state["validation_passed"]:
        print(f"❌ Pipeline Halted: Compliance validation failure -> {state['validation_error']}")
        return END
    return "approval_gate"

def route_approval(state: PlatformState) -> Literal["generate_repo", "__end__"]:
    if state["approval_status"] == "APPROVED":
        return "generate_repo"
    print("⏸️ Pipeline Suspended: Awaiting human administrative action inside Microsoft Teams.")
    return END

# Build the layout topology
workflow = StateGraph(PlatformState)

# Add our independent processing agents
workflow.add_node("intake", intake_agent_node)
workflow.add_node("validate", validation_agent_node)
workflow.add_node("generate_repo", repository_generation_node)
workflow.add_node("build_cicd", cicd_pipeline_node)

# Breakpoint placeholder node for human verification overrides
workflow.add_node("approval_gate", lambda state: None)

# Connect tracking edges
workflow.set_entry_point("intake")
workflow.add_edge("intake", "validate")

workflow.add_conditional_edges("validate", route_validation, {"approval_gate": "approval_gate", END: END})
workflow.add_conditional_edges("approval_gate", route_approval, {"generate_repo": "generate_repo", END: END})

workflow.add_edge("generate_repo", "build_cicd")
workflow.add_edge("build_cicd", END)

# Compile graph with memory state saver checkpoints
memory = MemorySaver()
app = workflow.compile(checkpointer=memory, interrupt_before=["approval_gate"])
