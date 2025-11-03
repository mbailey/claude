---
name: f5-tts
description: Toolkit for installing and using F5-TTS, a neural text-to-speech system. Use this skill when users request TTS (text-to-speech) functionality, want to install or troubleshoot F5-TTS, or need to run the F5-TTS Gradio interface. This skill handles Python 3.11 requirement, FFmpeg dependencies, and library path configuration on macOS.
---

# F5-TTS

## Overview

This skill provides tools and guidance for installing and using F5-TTS (A Fairytaler that Fakes Fluent and Faithful Speech with Flow Matching), a state-of-the-art neural text-to-speech system. F5-TTS requires specific environment setup including Python 3.11.13, FFmpeg, and proper library path configuration.

## When to Use This Skill

Use this skill when:
- Users want to install F5-TTS
- Users want to run the F5-TTS Gradio web interface
- Users encounter TorchCodec/FFmpeg library loading errors
- Users need to troubleshoot F5-TTS installation issues
- Users request text-to-speech functionality using F5-TTS

## Installation Workflow

### Prerequisites Check

Before installing F5-TTS, verify the environment has required dependencies:

```bash
python3 scripts/check_environment.py
```

This script checks for:
- Python 3.11 (specifically 3.11.13)
- FFmpeg (versions 4-8 supported)
- uv package installer
- Current F5-TTS installation status

### Installing Missing Dependencies

**Python 3.11:**
```bash
# macOS
brew install python@3.11

# Linux (Ubuntu/Debian)
sudo apt-get install python3.11
```

**FFmpeg:**
```bash
# macOS
brew install ffmpeg

# Linux (Ubuntu/Debian)
sudo apt-get install ffmpeg
```

**uv:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Installing F5-TTS

Once prerequisites are met, install F5-TTS from the project directory:

```bash
cd /path/to/F5-TTS
scripts/install_f5tts.sh
```

This script:
1. Validates the environment (Python 3.11, FFmpeg, uv)
2. Uninstalls any existing F5-TTS installation
3. Installs F5-TTS with `uv tool install --python 3.11 .`
4. Installs all dependencies including torchcodec, transformers, gradio

**Manual installation alternative:**
```bash
cd /path/to/F5-TTS
uv tool uninstall f5-tts  # If already installed
uv tool install --python 3.11 .
```

## Running F5-TTS

### Using the Gradio Web Interface

The recommended way to run F5-TTS is through the Gradio web interface, which provides an easy-to-use GUI for text-to-speech generation.

**Using the run script (recommended):**
```bash
scripts/run_f5tts_gradio.sh
```

This script automatically:
- Sets the required `DYLD_FALLBACK_LIBRARY_PATH` on macOS
- Runs `f5-tts_infer-gradio` with proper environment
- Starts the web interface at http://127.0.0.1:7861

**Manual execution:**
```bash
# macOS
export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"
f5-tts_infer-gradio

# Linux (usually doesn't require library path setup)
f5-tts_infer-gradio
```

### Command Line Options

The Gradio interface supports several options:

```bash
# Custom port
f5-tts_infer-gradio --port 7862

# Custom host (for network access)
f5-tts_infer-gradio --host 0.0.0.0

# Auto-open in browser
f5-tts_infer-gradio --inbrowser

# Create public share link
f5-tts_infer-gradio --share

# Enable API access
f5-tts_infer-gradio --api
```

**Using with the run script:**
```bash
scripts/run_f5tts_gradio.sh --port 7862 --inbrowser
```

### Using the CLI Interface

F5-TTS also provides a command-line interface:

```bash
f5-tts_infer-cli --help
```

## Common Issues and Solutions

### TorchCodec FFmpeg Library Error

**Most common issue:** TorchCodec cannot load FFmpeg libraries even when FFmpeg is installed.

**Error message:**
```
RuntimeError: Could not load libtorchcodec. Likely causes:
  1. FFmpeg is not properly installed in your environment...
```

**Solution (macOS):**
Always set the library path before running:
```bash
export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"
```

Or use the provided `scripts/run_f5tts_gradio.sh` which handles this automatically.

**Why this happens:**
- TorchCodec's bundled `.dylib` files look for FFmpeg libraries using `@rpath`
- macOS dynamic linker needs explicit library path configuration
- FFmpeg installed via Homebrew is at `/opt/homebrew/lib/` (Apple Silicon) or `/usr/local/lib/` (Intel)

### Wrong Python Version

If F5-TTS was installed with Python 3.12 or another version:

```bash
uv tool uninstall f5-tts
uv tool install --python 3.11 .
```

The `pyproject.toml` specifies `requires-python = "===3.11.13"` - this exact version is required.

### Additional Troubleshooting

For comprehensive troubleshooting information, consult the reference document:
```bash
cat references/troubleshooting.md
```

Or load it into context for detailed solutions to:
- FFmpeg installation issues
- Python version conflicts
- Port conflicts
- Model download problems
- Platform-specific issues (macOS Intel vs Apple Silicon, Linux)

## Architecture and Technical Details

### Project Structure

F5-TTS provides four main command-line tools:
- `f5-tts_infer-gradio` - Web interface for inference
- `f5-tts_infer-cli` - Command-line interface for inference
- `f5-tts_finetune-gradio` - Web interface for fine-tuning
- `f5-tts_finetune-cli` - Command-line interface for fine-tuning

### Key Dependencies

- **torch/torchaudio** - PyTorch for neural network inference
- **torchcodec** - Video/audio codec support (requires FFmpeg)
- **transformers** - HuggingFace transformers for ASR
- **gradio** - Web interface framework
- **vocos** - Vocoder model
- **librosa/soundfile** - Audio processing

### Installation Location

When installed via `uv tool install`:
- Executables: `~/.local/bin/`
- Python environment: `~/.local/share/uv/tools/f5-tts/`
- Python version: `lib/python3.11/site-packages/`

### Model Cache

Models are automatically downloaded from HuggingFace Hub and cached:
- Cache location: `~/.cache/huggingface/hub/`
- Main model: `models--SWivid--F5-TTS/snapshots/.../F5TTS_v1_Base/model_1250000.safetensors`

## Development Workflow

### Installing in Editable Mode

For development where code changes should be immediately reflected:

```bash
cd /path/to/F5-TTS
uv tool install --python 3.11 --editable .
```

### Running Tests

Check if the installation is working:
```bash
python3 scripts/check_environment.py
```

### Project Requirements

From `pyproject.toml`:
- Python: `===3.11.13` (exact version required)
- Key packages: accelerate, torchcodec, gradio>=5.0.0, transformers, vocos

## Resources

### scripts/

- **check_environment.py** - Validates that Python 3.11, FFmpeg, and uv are installed and checks F5-TTS installation status
- **install_f5tts.sh** - Automates F5-TTS installation with proper Python version
- **run_f5tts_gradio.sh** - Runs the Gradio interface with correct environment variables (especially library paths on macOS)

### references/

- **troubleshooting.md** - Comprehensive troubleshooting guide covering TorchCodec/FFmpeg errors, Python version issues, platform-specific problems, and common Gradio interface issues. Load this into context when debugging installation or runtime problems.
