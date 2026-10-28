import os
import time
from pinecone import Pinecone, ServerlessSpec
from langchain_ollama import OllamaEmbeddings
from langchain_ollama import ChatOllama
from langchain_core.messages import HumanMessage, SystemMessage

# ==========================================
# 1. INITIALIZE INFRASTRUCTURE CLIENTS
# ==========================================
PINECONE_INDEX_NAME = "local-ollama-rag-index"

# Connect to the local Ollama daemon
# Using mxbai-embed-large which outputs a 768-dimension vector
embeddings_engine = OllamaEmbeddings(model="mxbai-embed-large")
llm = ChatOllama(model="llama3.1:8b", temperature=0)

# Connect to the Pinecone cloud service
pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])

# Create the index if it doesn't exist yet
if PINECONE_INDEX_NAME not in pc.list_indexes().names():
    print(f"🚀 Creating serverless Pinecone index targeting 1024 dimensions...")
    pc.create_index(
        name=PINECONE_INDEX_NAME,
        dimension=1024, # Must match the exact dimension size of mxbai-embed-large
        metric="cosine",
        spec=ServerlessSpec(cloud="aws", region="us-east-1") # Free-tier requirement
    )
    while not pc.describe_index(PINECONE_INDEX_NAME).status['ready']:
        time.sleep(1)

index = pc.Index(PINECONE_INDEX_NAME)

# ==========================================
# 2. INGESTION PHASE (Populate Guardrails)
# ==========================================
print("\n📥 Embedding and uploading platform policies to Pinecone...")

compliance_data = [
    {"id": "rule_1", "text": "All 'Restricted' data repositories MUST utilize Terraform. OpenTofu is completely banned for this classification tier."},
    {"id": "rule_2", "text": "Repository names must be strictly alphanumeric and lowercase to maintain compatibility with company DNS routing tables."}
]

for item in compliance_data:
    # Generate the vector embedding array locally on your CPU/GPU via Ollama
    vector = embeddings_engine.embed_query(item["text"])
    
    # Upsert the local vector array into your remote cloud Pinecone index namespace
    index.upsert(
        vectors=[{
            "id": item["id"],
            "values": vector,
            "metadata": {"text": item["text"]} # Crucial for retrieval grounding
        }],
        namespace="compliance_guardrails"
    )

print("✅ Data successfully indexed.")

# ==========================================
# 3. COGNITIVE RETRIEVAL & GROUNDING PHASE
# ==========================================
user_query = "Can I use OpenTofu to provision a Restricted classification API service?"
print(f"\n🙋 User Query: '{user_query}'")

# Embed the raw user query locally
query_vector = embeddings_engine.embed_query(user_query)

# Search Pinecone for the single closest matching policy chunk
search_response = index.query(
    namespace="compliance_guardrails",
    vector=query_vector,
    top_k=1,
    include_metadata=True
)

# Extract matching facts
retrieved_context = ""
matches = search_response.get("matches", [])
if matches:
    retrieved_context = matches[0]["metadata"]["text"]
    print(f"🔍 Grounding Context Located:\n   -> \"{retrieved_context}\"")
else:
    retrieved_context = "No relevant policies located."

# ==========================================
# 4. GENERATION PHASE
# ==========================================
system_instruction = (
    "You are an enterprise compliance auditor agent. Answer the user's query "
    "based strictly and explicitly on the facts wrapped in the <context> block. "
    "If the request violates a rule, reject it clearly with a direct citation."
)

prompt_payload = f"""
<context>
{retrieved_context}
</context>

<user_query>
{user_query}
</user_query>
"""

print("\n🤖 Running local LLM generation pass via Ollama...")
response = llm.invoke([
    SystemMessage(content=system_instruction),
    HumanMessage(content=prompt_payload)
])

print(f"\n🎯 Grounded Agent Response:\n{response.content}")
