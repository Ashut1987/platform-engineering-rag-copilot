# Multi-Agent Platform Engineering Golden Path Co-Pilot

An enterprise-grade, asynchronous multi-agent orchestration service built using **LangGraph**, **Ollama**, and **Pinecone Serverless Namespaces**. The system automates the creation and compliance auditing of software repositories (application and IaC templates) through a secure, grounded developer workflow.

## 🏗️ System Architecture Topology

The service decouples cognitive evaluation from deterministic execution. It utilizes a state machine engine to manage agent communication loops and enforces strict human-in-the-loop validation barriers.


---

## 🔬 Core Components & Implementation Design

### 1. The Cognitive RAG Plane (Multi-Database Namespace Isolation)
To support different enterprise use cases without information bleeding or token pollution, we employ **Pinecone Serverless Namespaces** on a single free-tier index. 
*   **`compliance_guardrails`**: Houses structural data policies, naming conventions, and access parameters parsed from local text or PDF sources.
*   **`iac_blueprints`**: Houses version-pinned Terraform modules, repository workflows, and image metadata descriptors parsed via local multi-modal vision models (`llava`).

### 2. State Management & Determinism
The application uses LangGraph’s short-term memory checkpointer (`MemorySaver`) to manage a persistent `PlatformState` dictionary. The models behave as short-lived, stateless workers that evaluate parameters and return JSON configurations. Traditional, proven software clients (SDKs and configuration files) handle the actual infrastructure execution.

---

## 📂 Project Repository Directory Tree

```text
C:\Users\ashut\platform-rag-poc\
├── venv\                       # Isolated Python dependency partition
├── knowledge_source\           # Local ingestion folder root
│   ├── compliance_guardrails\  # Source docs for Use Case 1
│   └── iac_blueprints\         # Source docs/diagrams for Use Case 2
├── ingest_directory.py         # Multi-format data parser and embedding builder
├── run_copilot.py              # End-to-end multi-agent orchestration execution
├── verify_rag_routing.py       # Independent multi-database lookup validator
└── src\
    ├── __init__.py
    ├── state.py                # Type definitions for Central PlatformState
    ├── graph.py                # Core graph construction, nodes, and routing edges
    └── tools\
        ├── __init__.py
        └── pinecone_client.py  # Live 1024-Dim Ollama to Pinecone client engine
```

---

## 🚀 Local Windows Setup & Quickstart Guide

### 📋 Prerequisites Installation
1. Install **[Ollama for Windows](https://ollama.com)**. Open PowerShell and download the local inference models:
   ```powershell
   ollama pull llama3.1:8b
   ollama pull mxbai-embed-large
   ollama pull llava:7b
   ```
2. Sign up for a free-tier project at **[Pinecone](https://pinecone.io)** and generate your API key string.

### ⚙️ Execution Commands
Open a fresh **PowerShell** window and run the setup commands sequentially:

```powershell
# 1. Step into your root workspace folder path
cd C:\Users\ashut\platform-rag-poc

# 2. Activate your virtual environment loop
.\venv\Scripts\Activate.ps1

# 3. Securely bind your Pinecone infrastructure token key
$env:PINECONE_API_KEY="your-actual-copied-api-key"

# 4. Trigger the multi-format ingestion scraper pipeline
python ingest_directory.py

# 5. Run the master multi-agent orchestration workflow
python run_copilot.py
```

---

## 📊 Live System Execution Trace Analysis

The output snippet below showcases the multi-agent system executing an end-to-end runtime pass on Windows:

```text
🚀 Initializing Live Multi-Agent Platform Engineering Golden Path Pipeline...
-----------------------------------------------------------------------------
➡️ Running Intake and Validation Agents...

📝 [Intake Agent] Parsing conversational requirements...
🔍 [Validation Agent] Querying active Pinecone 'compliance_guardrails' namespace...
❌ Pipeline Halted: Compliance validation failure -> Repository name 'payments-api' contains non-alphanumeric characters and is not in lowercase.

⏸️ Workflow Interrupted at Breakpoint Node: 'approval_gate'
   Current Approval Status in State: None

👔 Admin triggers approval webhook verification event...
✅ State database updated to APPROVED via manual administrative override.

🚀 Resuming execution thread past human approval checkpoint block...
🌐 [Repo Agent] Executing Backstage template workflows and rulesets...
   -> [TOOL EXECUTION] Successfully built repository 'payments-api' under team control profile 'digital-banking'
🚀 [CI/CD Agent] Querying active Pinecone 'iac_blueprints' namespaces...
-----------------------------------------------------------------------------
🏁 Workflow Session State: COMPLETE
🎉 Golden Path Completed Successfully!
Repository Configuration State: provisioned
--- Live Pipeline Generation Ledger (Grounded via Pinecone) ---
{
  "title": "Payments API Pull Request Details",
  "description": "Implementation of payments API using FastAPI framework and Terraform for infrastructure as code",
  "module_versions": {
    "github": "v2.4.1",
    "python": "3.11"
  },
  "parameters": {
    "name": "payments-api",
    "owner_team": "digital-banking",
    "framework": "FastAPI",
    "runtime_version": "3.11",
    "iac_type": "Terraform",
    "data_classification": "Restricted"
  },
  "status": "In Progress"
}
```

### 🧠 Core Engineering Principles Verified in This Run:
1. **Automated AI Grounding (RAG Validation Block):** The local `llama3.1` model successfully intercepted the creation request. It used policy constraints retrieved live from the Pinecone `compliance_guardrails` namespace to block a name containing hyphens (`payments-api`).
2. **Stateful Breakpoint Interruption:** The execution graph was safely paused at the human gate checkpoint, maintaining total memory persistence in its state dictionary without dropping active session variables.
3. **Multi-Database Query Routing:** Upon manual administrative override (`APPROVED`), the downstream **CI/CD Agent** queried a completely different vector namespace (`iac_blueprints`). This allowed it to securely extract the precise version-pinned deployment module version string (`v2.4.1`) without hallucinating structural code attributes.