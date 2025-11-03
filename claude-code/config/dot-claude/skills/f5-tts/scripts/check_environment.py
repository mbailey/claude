#!/usr/bin/env python3
"""Check if the environment is ready for F5-TTS installation."""

import subprocess
import sys
import shutil
from pathlib import Path


def check_python_version():
    """Check if Python 3.11 is available."""
    print("Checking Python 3.11...")

    python311_path = shutil.which("python3.11")
    if not python311_path:
        print("❌ Python 3.11 not found")
        return False

    # Check exact version
    result = subprocess.run(
        ["python3.11", "--version"],
        capture_output=True,
        text=True
    )
    version = result.stdout.strip()
    print(f"✓ Found {version} at {python311_path}")
    return True


def check_ffmpeg():
    """Check if FFmpeg is installed."""
    print("\nChecking FFmpeg...")

    ffmpeg_path = shutil.which("ffmpeg")
    if not ffmpeg_path:
        print("❌ FFmpeg not found")
        return False

    # Check version
    result = subprocess.run(
        ["ffmpeg", "-version"],
        capture_output=True,
        text=True
    )
    version_line = result.stdout.split('\n')[0]
    print(f"✓ Found {version_line}")
    return True


def check_uv():
    """Check if uv is installed."""
    print("\nChecking uv...")

    uv_path = shutil.which("uv")
    if not uv_path:
        print("❌ uv not found")
        return False

    print(f"✓ Found uv at {uv_path}")
    return True


def check_f5tts_installation():
    """Check if F5-TTS is already installed."""
    print("\nChecking F5-TTS installation...")

    f5tts_path = shutil.which("f5-tts_infer-gradio")
    if not f5tts_path:
        print("⚠ F5-TTS not installed")
        return False

    print(f"✓ F5-TTS installed at {f5tts_path}")

    # Check if it's using Python 3.11
    try:
        with open(f5tts_path, 'r') as f:
            first_line = f.readline()
            if 'python3.11' in first_line:
                print("✓ Using Python 3.11")
            else:
                print(f"⚠ Shebang: {first_line.strip()}")
                # Check the actual installation
                result = subprocess.run(
                    ["head", "-1", f5tts_path],
                    capture_output=True,
                    text=True
                )
                print(f"  Installation may need to be updated")
    except Exception as e:
        print(f"⚠ Could not verify Python version: {e}")

    return True


def main():
    """Run all environment checks."""
    print("=" * 50)
    print("F5-TTS Environment Check")
    print("=" * 50)

    checks = {
        "Python 3.11": check_python_version(),
        "FFmpeg": check_ffmpeg(),
        "uv": check_uv(),
        "F5-TTS": check_f5tts_installation(),
    }

    print("\n" + "=" * 50)
    print("Summary")
    print("=" * 50)

    all_required_passed = all([checks["Python 3.11"], checks["FFmpeg"], checks["uv"]])

    if all_required_passed and checks["F5-TTS"]:
        print("✓ All checks passed! F5-TTS is ready to use.")
        return 0
    elif all_required_passed:
        print("✓ Environment is ready for F5-TTS installation")
        print("⚠ Run the installation script to install F5-TTS")
        return 0
    else:
        print("❌ Some required dependencies are missing:")
        if not checks["Python 3.11"]:
            print("   - Install Python 3.11.13")
        if not checks["FFmpeg"]:
            print("   - Install FFmpeg (brew install ffmpeg on macOS)")
        if not checks["uv"]:
            print("   - Install uv (curl -LsSf https://astral.sh/uv/install.sh | sh)")
        return 1


if __name__ == "__main__":
    sys.exit(main())
