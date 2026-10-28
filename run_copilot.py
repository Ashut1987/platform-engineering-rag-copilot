# run_copilot.py
import os
import sys
import json

# 🛠️ FORCED WINDOWS PATH BINDING: 
# This forcefully registers the root, src, and all nested modules with Python
current_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(current_dir, "src")

for path in [current_dir, src_dir]:
    if path not in sys.path:
        sys.path.insert(0, path)

# Now we can safely import our internal LangGraph orchestrator components
from src.graph import app as platform_copilot

if __name__ == "__main__":
    # Create a unique tracking session ID for this specific workflow run
    import uuid
    thread_config = {"configurable": {"thread_id": str(uuid.uuid4())}}
    
    dev_prompt = (
        "Create a web backend service microservice named 'payments-api' for the digital-banking team. "
        "Use FastAPI, Python 3.11, and configure it with Terraform for our Restricted data classification workspace."
    )
    
    print("🚀 Initializing Live Multi-Agent Platform Engineering Golden Path Pipeline...")
    print("-----------------------------------------------------------------------------")
    
    print("➡️ Running Intake and Validation Agents...")
    for event in platform_copilot.stream({"user_input": dev_prompt}, thread_config):
        pass
        
    current_state = platform_copilot.get_state(thread_config)
    print(f"\n⏸️ Workflow Interrupted at Breakpoint Node: '{current_state.next}'")
    print(f"   Current Approval Status in State: {current_state.values.get('approval_status')}")
    
    print("\n👔 Admin triggers approval webhook verification event...")
    platform_copilot.update_state(
        thread_config, 
        {"approval_status": "APPROVED"}, 
        as_node="approval_gate"
    )
    print("✅ State database updated to APPROVED via manual administrative override.")
    
    print("\n🚀 Resuming execution thread past human approval checkpoint block...")
    for event in platform_copilot.stream(None, thread_config):
        pass
        
    final_state = platform_copilot.get_state(thread_config)
    print("-----------------------------------------------------------------------------")
    print(f"🏁 Workflow Session State: COMPLETE")
    print(final_state.values.get("final_summary"))
