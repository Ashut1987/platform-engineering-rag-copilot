import os
from pinecone import Pinecone
from langchain_ollama import OllamaEmbeddings

class EnterpriseRAGClient:
    def __init__(self):
        # Bind our active local embedding model and remote cloud index connections
        self.embeddings = OllamaEmbeddings(model="mxbai-embed-large")
        self.pc = Pinecone(api_key=os.environ["PINECONE_API_KEY"])
        self.index = self.pc.Index("local-ollama-rag-index")

    def query_namespace(self, query_text: str, namespace: str, top_k: int = 2) -> str:
        """Embeds incoming agent queries locally and pulls references from Pinecone."""
        # Compute local embedding vector array
        query_vector = self.embeddings.embed_query(query_text)
        
        # Query remote cloud index space
        results = self.index.query(
            namespace=namespace,
            vector=query_vector,
            top_k=top_k,
            include_metadata=True
        )
        
        # Concatenate text payloads
        chunks = []
        for match in results.get("matches", []):
            if "text" in match.get("metadata", {}):
                chunks.append(match["metadata"]["text"])
                
        return "\n\n".join(chunks) if chunks else "No explicit governance context records found."
