#!/bin/bash
# Install F5-TTS with Python 3.11

set -e  # Exit on error

echo "=========================================="
echo "Installing F5-TTS with Python 3.11"
echo "=========================================="

# Check if we're in an F5-TTS project directory
if [ ! -f "pyproject.toml" ]; then
    echo "Error: pyproject.toml not found"
    echo "This script should be run from the F5-TTS project directory"
    exit 1
fi

# Check for Python 3.11
if ! command -v python3.11 &> /dev/null; then
    echo "Error: Python 3.11 not found"
    echo "Please install Python 3.11.13 first"
    exit 1
fi

# Check for FFmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: FFmpeg not found"
    echo "Please install FFmpeg first (e.g., 'brew install ffmpeg' on macOS)"
    exit 1
fi

# Check for uv
if ! command -v uv &> /dev/null; then
    echo "Error: uv not found"
    echo "Please install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# Check if F5-TTS is already installed
if command -v f5-tts_infer-gradio &> /dev/null; then
    echo "F5-TTS is already installed. Uninstalling first..."
    uv tool uninstall f5-tts
fi

# Install F5-TTS with Python 3.11
echo "Installing F5-TTS with Python 3.11..."
uv tool install --python 3.11 .

echo ""
echo "=========================================="
echo "✓ Installation complete!"
echo "=========================================="
echo ""
echo "To run F5-TTS Gradio interface:"
echo "  f5-tts_infer-gradio"
echo ""
echo "Or use the run script with proper environment:"
echo "  scripts/run_f5tts_gradio.sh"
