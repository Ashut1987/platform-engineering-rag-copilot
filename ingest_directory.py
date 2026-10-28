import os
import glob
import pypdf
from pinecone import Pinecone, ServerlessSpec
from langchain_ollama import OllamaEmbeddings, ChatOllama
from langchain_core.messages import HumanMessage
from langchain_text_splitters import RecursiveCharacterTextSplitter

# ==========================================
# 1. INITIALIZE INFRASTRUCTURE CLIENTS
# ==========================================
PINECONE_INDEX_NAME = "local-ollama-rag-index"
KNOWLEDGE_ROOT = r"C:\Users\ashut\platform-rag-poc\knowledge_source"

# Connect to Pinecone Cloud Service
pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])

# Verify index initialization with 1024 dimensions matching mxbai-embed-large
if PINECONE_INDEX_NAME not in pc.list_indexes().names():
    print(f"🚀 Index missing. Provisioning serverless Pinecone index targeting 1024 dimensions...")
    pc.create_index(
        name=PINECONE_INDEX_NAME,
        dimension=1024,
        metric="cosine",
        spec=ServerlessSpec(cloud="aws", region="us-east-1")
    )
index = pc.Index(PINECONE_INDEX_NAME)

# Connect to Local Ollama Engines
embeddings_engine = OllamaEmbeddings(model="mxbai-embed-large")
vision_llm = ChatOllama(model="llava:7b", temperature=0)

# Configure the modern text splitter abstraction layout
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)

# ==========================================
# 📐 MULTI-FORMAT PARSING PIPELINE
# ==========================================
def extract_text_from_image(image_path: str) -> str:
    """Uses local multi-modal vision model (Llava) to describe diagrams or images."""
    print(f"   🖼️ [Vision Processing] Analyzing image via Llava: {os.path.basename(image_path)}")
    try:
        response = vision_llm.invoke([
            HumanMessage(content=[
                {"type": "text", "text": "Extract all readable alphanumeric text from this image. If it is an architectural diagram, network layout, or flowchart, thoroughly describe its components, labels, lines, and structural connections."},
                {"type": "image_url", "image_url": image_path}
            ])
        ])
        return f"[Extracted Image Blueprint Context]:\n{response.content}"
    except Exception as e:
        print(f"   ❌ Vision exception triggered: {e}")
        return ""

def process_and_upload_directory():
    """Traverses use case directories, parses files cleanly, and routes to custom namespaces."""
    if not os.path.exists(KNOWLEDGE_ROOT):
        print(f"⚠️ Knowledge root folder not found at: {KNOWLEDGE_ROOT}. Run script to initialize folders.")
        return

    # Scan for use-case subdirectories (each folder = a separate DB namespace)
    subdirs = [f.path for f in os.scandir(KNOWLEDGE_ROOT) if f.is_dir()]
    
    if not subdirs:
        print("ℹ️ No folders found. Drop files into the generated subfolders and rerun.")
        return

    for subdir in subdirs:
        namespace_name = os.path.basename(subdir)
        print(f"\n📂 Activating Database Use Case Location -> Namespace: '{namespace_name}'")
        
        # Scan all target files inside the namespace folder
        files = glob.glob(os.path.join(subdir, "*"))
        
        for file_path in files:
            if isinstance(file_path, tuple):
                file_path = file_path[0]
            
            file_path = str(file_path) # Cast directly to plain string wrapper
            ext = os.path.splitext(file_path)[1].lower() # Extracted extension cleanly
            extracted_text_chunks = []
            
            print(f"📄 Scraping Source File: {os.path.basename(file_path)}")
            
            try:
                # --- 1. HANDLE STRUCTURED TEXT / CODE / MARKDOWN ---
                if ext in [".txt", ".md", ".json", ".yaml", ".yml", ".py"]:
                    with open(file_path, "r", encoding="utf-8") as f:
                        file_content = f.read()
                    if file_content.strip():
                        extracted_text_chunks = text_splitter.split_text(file_content)
                        
                # --- 2. HANDLE PDF FILES VIA STANDALONE PYPDF ---
                elif ext == ".pdf":
                    pdf_text = ""
                    with open(file_path, "rb") as f:
                        reader = pypdf.PdfReader(f)
                        for page in reader.pages:
                            text = page.extract_text()
                            if text:
                                pdf_text += text + "\n"
                    if pdf_text.strip():
                        extracted_text_chunks = text_splitter.split_text(pdf_text)
                        
                # --- 3. HANDLE IMAGES VIA OLLAMA VISION INTERFACES ---
                elif ext in [".png", ".jpg", ".jpeg", ".bmp"]:
                    img_desc = extract_text_from_image(file_path)
                    if img_desc.strip():
                        # Image descriptions are small enough to be single chunks
                        extracted_text_chunks = [img_desc]
                
                else:
                    print(f"   ⚠️ Extension '{ext}' is unsupported. Skipping.")
                    continue

            except Exception as file_err:
                print(f"   ❌ Critical error parsing file {os.path.basename(file_path)}: {file_err}")
                continue

            # --- 4. SECURE VECTOR GENERATION AND UPSERT ---
            for chunk_id, chunk_text in enumerate(extracted_text_chunks):
                if not chunk_text.strip():
                    continue
                    
                # Compute vector arrays locally via Ollama (1024 dims)
                vector = embeddings_engine.embed_query(chunk_text)
                
                # Format an isolated, clean identifier matching the chunk hash string
                clean_filename = os.path.basename(file_path).replace(" ", "_")
                unique_vector_id = f"{clean_filename}_chunk_{chunk_id}"
                
                # Push the chunk securely into the target custom namespace
                index.upsert(
                    vectors=[{
                        "id": unique_vector_id,
                        "values": vector,
                        "metadata": {
                            "text": chunk_text,
                            "source_file": os.path.basename(file_path)
                        }
                    }],
                    namespace=namespace_name # Dynamic database separation gate
                )
                print(f"   ✅ Embedded chunk {chunk_id} uploaded to space namespace '{namespace_name}'")

if __name__ == "__main__":
    # Scaffold directories dynamically on initialization
    os.makedirs(os.path.join(KNOWLEDGE_ROOT, "compliance_guardrails"), exist_ok=True)
    os.makedirs(os.path.join(KNOWLEDGE_ROOT, "iac_blueprints"), exist_ok=True)
    
    print("🚀 Multi-Database Ingestion Scraper Online.")
    print(f"📂 Drop files into target subfolders here: {KNOWLEDGE_ROOT}")
    print("   -> Put PDFs/txt guidelines inside 'compliance_guardrails'")
    print("   -> Put architecture pictures/blueprints inside 'iac_blueprints'\n")
    
    # Run the ingestion engine
    process_and_upload_directory()
