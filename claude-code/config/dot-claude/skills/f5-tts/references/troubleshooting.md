# F5-TTS Troubleshooting Guide

## Common Issues and Solutions

### TorchCodec/FFmpeg Library Loading Errors

**Symptom:**
```
RuntimeError: Could not load libtorchcodec. Likely causes:
  1. FFmpeg is not properly installed in your environment...
```

**Cause:** TorchCodec cannot find FFmpeg dynamic libraries at runtime, even when FFmpeg is installed via Homebrew.

**Solution (macOS):**
Set the library fallback path before running F5-TTS:
```bash
export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"
f5-tts_infer-gradio
```

Or use the provided run script which sets this automatically:
```bash
scripts/run_f5tts_gradio.sh
```

**Why this happens:**
- FFmpeg is installed at `/opt/homebrew/Cellar/ffmpeg/X.X_X/lib/`
- TorchCodec's bundled `.dylib` files look for FFmpeg libraries using `@rpath`
- The library path needs to be explicitly set for macOS dynamic linker

### Wrong Python Version

**Symptom:**
F5-TTS installed with Python 3.12 or other version instead of required 3.11.13

**Solution:**
1. Uninstall the current installation:
   ```bash
   uv tool uninstall f5-tts
   ```

2. Reinstall with Python 3.11:
   ```bash
   uv tool install --python 3.11 .
   ```

**Verification:**
Check the installation:
```bash
ls -la ~/.local/share/uv/tools/f5-tts/bin/python
# Should show python3.11
```

### FFmpeg Not Found

**Symptom:**
```
Error: FFmpeg not found
```

**Solution (macOS):**
```bash
brew install ffmpeg
```

**Solution (Linux):**
```bash
# Ubuntu/Debian
sudo apt-get install ffmpeg

# Fedora
sudo dnf install ffmpeg

# Arch
sudo pacman -S ffmpeg
```

**Verification:**
```bash
ffmpeg -version
```

### Python 3.11 Not Available

**Symptom:**
```
Error: Python 3.11 not found
```

**Solution (macOS):**
```bash
brew install python@3.11
```

**Solution (Linux):**
```bash
# Ubuntu/Debian
sudo apt-get install python3.11

# Or use pyenv
pyenv install 3.11.13
```

**Verification:**
```bash
python3.11 --version
# Should show: Python 3.11.13
```

### uv Not Installed

**Symptom:**
```
Error: uv not found
```

**Solution:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, restart your terminal or source your shell profile.

## Gradio Interface Issues

### Port Already in Use

**Symptom:**
```
OSError: [Errno 48] Address already in use
```

**Solution:**
Specify a different port:
```bash
f5-tts_infer-gradio --port 7862
```

Or kill the process using the port:
```bash
lsof -i :7861
kill <PID>
```

### Browser Not Opening Automatically

**Solution:**
Use the `--inbrowser` flag:
```bash
f5-tts_infer-gradio --inbrowser
```

Or manually open the URL shown in the terminal (typically http://127.0.0.1:7861)

## Model Download Issues

### Slow Download or Timeout

**Solution:**
Models are downloaded from HuggingFace Hub. If downloads are slow:

1. Check your internet connection
2. Models are cached at `~/.cache/huggingface/hub/`
3. You can manually download models and place them in the cache directory

### Cache Location

Models and data are cached at:
- macOS/Linux: `~/.cache/huggingface/hub/`
- The main F5-TTS model is: `models--SWivid--F5-TTS`

## Development and Project-Specific Installation

### Installing from Project Directory

To install F5-TTS from a cloned repository:

```bash
cd /path/to/F5-TTS
uv tool install --python 3.11 .
```

### Installing in Editable Mode

For development where you want changes to be reflected immediately:

```bash
cd /path/to/F5-TTS
uv tool install --python 3.11 --editable .
```

## Checking Installation Status

Use the provided environment check script:

```bash
python3 scripts/check_environment.py
```

This will verify:
- Python 3.11 installation
- FFmpeg installation
- uv installation
- F5-TTS installation status

## Platform-Specific Notes

### macOS Apple Silicon (M1/M2/M3)

- F5-TTS uses MPS (Metal Performance Shaders) for GPU acceleration
- You'll see: `Device set to use mps` in the logs
- FFmpeg from Homebrew is at `/opt/homebrew/`

### macOS Intel

- FFmpeg might be at `/usr/local/` instead of `/opt/homebrew/`
- Adjust `DYLD_FALLBACK_LIBRARY_PATH` accordingly:
  ```bash
  export DYLD_FALLBACK_LIBRARY_PATH="/usr/local/lib:$DYLD_FALLBACK_LIBRARY_PATH"
  ```

### Linux

- Library path issues are less common on Linux
- If needed, use `LD_LIBRARY_PATH` instead of `DYLD_FALLBACK_LIBRARY_PATH`
