#!/bin/bash
# Run F5-TTS Gradio interface with proper environment setup

# Set FFmpeg library path for macOS
# This is required for torchcodec to find FFmpeg libraries
if [[ "$OSTYPE" == "darwin"* ]]; then
    export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"
fi

# Parse command line arguments
PORT=7861
HOST="127.0.0.1"
SHARE=""
API=""
INBROWSER=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -H|--host)
            HOST="$2"
            shift 2
            ;;
        -s|--share)
            SHARE="--share"
            shift
            ;;
        -a|--api)
            API="--api"
            shift
            ;;
        -i|--inbrowser)
            INBROWSER="--inbrowser"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-p PORT] [-H HOST] [-s] [-a] [-i]"
            exit 1
            ;;
    esac
done

# Check if f5-tts_infer-gradio is installed
if ! command -v f5-tts_infer-gradio &> /dev/null; then
    echo "Error: f5-tts_infer-gradio not found"
    echo "Please install F5-TTS first using scripts/install_f5tts.sh"
    exit 1
fi

echo "Starting F5-TTS Gradio interface..."
echo "URL: http://$HOST:$PORT"
echo ""

# Run the application
f5-tts_infer-gradio --port "$PORT" --host "$HOST" $SHARE $API $INBROWSER
