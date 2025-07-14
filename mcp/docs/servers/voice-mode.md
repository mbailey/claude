# voice-mode

Voice conversation capabilities with text-to-speech and speech-to-text integration.

**Project URL:** [https://github.com/mbailey/voice-mcp](https://github.com/mbailey/voice-mcp)

## CLI Command
```bash
claude mcp add voice-mode -- uvx voice-mcp
```

## JSON Configuration
```json
{
  "voice-mode": {
    "command": "uvx",
    "args": [
      "voice-mcp"
    ]
  }
}
```

## Requirements
- uvx (uv tool runner)
- Audio input/output devices
- Optional: OpenAI API key for OpenAI TTS/STT
- Optional: Kokoro TTS server for local TTS

## Features
- Two-way voice conversations
- Multiple TTS providers (OpenAI, Kokoro)
- Real-time speech-to-text transcription
- Voice selection and customization
- Performance statistics tracking
- LiveKit room support for remote audio

## Available Tools
- `converse` - Have a voice conversation with optional response listening
- `ask_voice_question` - Ask a question and listen for voice response
- `voice_statistics` - Display live statistics dashboard
- `voice_statistics_summary` - Get concise performance summary
- `voice_statistics_reset` - Reset statistics
- `voice_statistics_export` - Export statistics as JSON
- `voice_statistics_recent` - Show recent interactions
- `voice_registry` - View available TTS/STT providers
- `check_audio_devices` - List audio input/output devices
- `voice_status` - Check all voice services status
- `list_tts_voices` - List available TTS voices
- `check_room_status` - Check LiveKit room status
- `refresh_provider_registry` - Refresh provider health checks
- `get_provider_details` - Get provider details
- `kokoro_start` - Start Kokoro TTS service
- `kokoro_stop` - Stop Kokoro TTS service
- `kokoro_status` - Check Kokoro service status

## Available Prompts
Voice-mode provides prompts that add slash commands for use in Claude Code. To view available prompts, check the server details in your Claude interface.

## Available Resources
None currently provided.

## Tool Approval
To approve specific tools for this server, add to your Claude settings:

```json
{
  "toolApprovals": {
    "voice-mode": {
      "converse": true,
      "ask_voice_question": true,
      "voice_statistics": true,
      "check_audio_devices": true,
      "voice_status": true
    }
  }
}
```

## Example Usage
```
# Basic conversation
converse("Hello, how are you today?")

# Ask without waiting for response
converse("Goodbye!", wait_for_response=False)

# Use specific voice
converse("Hello", voice="nova", tts_provider="openai")

# Emotional speech with OpenAI
converse("We did it!", tts_model="gpt-4o-mini-tts", tts_instructions="Sound extremely excited")

# Check voice service status
voice_status()

# List available devices
check_audio_devices()
```

## Configuration Options
Environment variables:
- `OPENAI_API_KEY` - For OpenAI TTS/STT services
- `VOICE_MCP_AUDIO_FEEDBACK` - Enable/disable audio feedback
- `VOICE_MCP_FEEDBACK_STYLE` - Audio feedback style (whisper/shout)
- `VOICEMODE_TTS_AUDIO_FORMAT` - Default audio format
- `NVIM_SOCKET_PATH` - Neovim socket path for integration

## See Also
- [← Back to MCP Servers Index](./README.md)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [voice-mcp GitHub Repository](https://github.com/mbailey/voice-mcp)
- [Kokoro TTS](https://github.com/remixer-dec/kokoro-onnx)