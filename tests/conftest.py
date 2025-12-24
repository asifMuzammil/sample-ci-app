import sys
from pathlib import Path

# project root ko python path mein add karo
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

