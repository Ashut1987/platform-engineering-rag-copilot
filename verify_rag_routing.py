# verify_rag_routing.py
import os
import json
from pinecone import Pinecone
from langchain_ollama import OllamaEmbeddings, ChatOllama
from langchain_core.messages import HumanMessage, SystemMessage

# Connect to infrastructure layers
pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])
index = pc.Index("local-ollama-rag-index")
embeddings_engine = OllamaEmbeddings(model="mxbai-embed-large")
llm = ChatOllama(model="llama3.1:8b", temperature=0)

def query_agent_knowledge_base(query_text: str, database_usecase: str) -> str:
    """Simulates an agent dynamically pulling facts from a targeted database use case."""
    # Compute vector locally via Ollama
    query_vector = embeddings_engine.embed_query(query_text)
    
    # Query only the requested isolated database namespace in Pinecone
    search_response = index.query(
        namespace=database_usecase,
        vector=query_vector,
        top_k=1,
        include_metadata=True
    )
    
    matches = search_response.get("matches", [])
    if matches:
        return matches[0]["metadata"]["text"]
    return "No explicit enterprise documentation located for this specific configuration."

# ========================================================
# 🤖 SIMULATING A GROUNDED MULTI-USE-CASE PIPELINE RUN
# ========================================================
if __name__ == "__main__":
    print("🤖 Simulating Agentic Workflow Context Ingress...")
    
    # Test Use Case 1: The Validation Agent inspecting repository naming conventions
    print("\n--- 🏁 USE CASE 1: VALIDATION AGENT ---")
    question_1 = "Are uppercase letters allowed in our repository name profiles?"
    print(f"Agent Action: Pulling context from database namespace 'compliance_guardrails'...")
    
    context_1 = query_agent_knowledge_base(question_1, "compliance_guardrails")
    print(f"Retrieved Fact: {context_1}")
    
    # Test Use Case 2: The CI/CD Agent fetching code layout blueprints
    print("\n--- 🏁 USE CASE 2: CI/CD TEMPLATE AGENT ---")
    question_2 = "What version of the FastAPI Terraform module should we pin in our workflow layout?"
    print(f"Agent Action: Pulling context from database namespace 'iac_blueprints'...")
    
    context_2 = query_agent_knowledge_base(question_2, "iac_blueprints")
    print(f"Retrieved Fact: {context_2}")
