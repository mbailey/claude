---
name: strudel-music
description: Creating live-coded algorithmic music and ambient soundscapes using Strudel pattern language. Use this skill when the user asks to create music, generate soundscapes, build ambient tracks, or work with live coding music patterns. This skill helps with setting up Strudel with Neovim integration and composing music using pattern-based programming.
---

# Strudel Music

## Overview

This skill enables creating algorithmic music and ambient soundscapes using Strudel, a browser-based live coding environment. Strudel is a JavaScript port of Tidal Cycles that runs entirely in the browser with no complex installation required. Create layered ambient music, rhythmic patterns, and evolving soundscapes through code.

## Core Capabilities

### 1. Setup and Configuration

Configure Neovim with strudel.nvim plugin for integrated live coding workflow:

- Install the strudel.nvim plugin via the user's Neovim package manager
- Configure keybindings for launching Strudel, toggling playback, and syncing buffers
- Set up file type detection for `.str` files
- Ensure dependencies are met (Neovim 0.9.0+, Node.js 16+, npm)

When user requests setup, update their Neovim configuration directly.

### 2. Creating Ambient Soundscapes

Generate atmospheric, evolving ambient music inspired by artists like Boards of Canada, Biosphere, and Music for Programming aesthetics:

**Layering approach:**
- Start with sustained bass/drone layers using elongation (`@`)
- Add textural mid-range elements with gentle rhythmic variation
- Include sparse high-frequency elements for movement
- Use effects (reverb, delay, filters) to create space and depth

**Pattern techniques for ambient music:**
- Elongation: `note("<[g2,b2,d3]@4 [a2,c3,e3]@4>")` - sustained chords
- Slow evolution: `.slow(4)` or `.slow(8)` - stretch patterns across multiple cycles
- Euclidean rhythms: `s("pad(3,8)")` - organic, non-repetitive textures
- Rests and space: `~` - create breathing room in patterns
- Stacking: `.stack()` - combine multiple pattern layers

### 3. Pattern Syntax

Strudel uses mini-notation for concise pattern creation:

**Basic sequencing:**
```javascript
s("bd sd cp hh")  // bass drum, snare, clap, hi-hat
```

**Subdivision with brackets:**
```javascript
s("bd [sd sd] cp hh")  // subdivide one step into two
```

**Polyphony with commas:**
```javascript
note("[g3,b3,e4]")  // play notes simultaneously
```

**Time manipulation:**
- `*2` - play pattern twice per cycle
- `/2` - play pattern over two cycles
- `<>` - alternate between options each cycle

**Elongation:**
```javascript
s("bd@3 sd")  // bass drum 3x longer than snare
```

**Rests:**
```javascript
s("bd ~ sd ~")  // silence on beats 2 and 4
```

### 4. Sound Sources

**Samples:**
```javascript
s("bd sd")  // built-in drum samples
```

**Notes with synths:**
```javascript
note("c3 e3 g3").sound("sawtooth")
```

**Custom samples:**
```javascript
samples({ mysound: "https://example.com/sound.wav" })
s("mysound")
```

### 5. Effects and Transformation

Apply effects to shape the sound:

```javascript
s("pad").room(0.8).delay(0.3).lpf(800)
```

**Common effects:**
- `.room(0-1)` - reverb amount
- `.delay(0-1)` - delay/echo amount
- `.lpf(frequency)` - low-pass filter
- `.hpf(frequency)` - high-pass filter
- `.gain(0-1)` - volume
- `.pan(0-1)` - stereo position
- `.speed(n)` - playback speed/pitch

### 6. Workflow with Neovim

Once strudel.nvim is configured:

1. Create or open a `.str` file in Neovim
2. Launch Strudel: `:StrudelLaunch` (or configured keybinding)
3. Write patterns in the buffer - they sync to browser in real-time
4. Control playback from Neovim with configured commands
5. Iterate on patterns with immediate audio feedback

The plugin provides two-way sync between Neovim buffer and Strudel browser instance.

## Creating Ambient Music Templates

When user requests ambient music creation, start with a layered template approach:

**Example ambient template:**
```javascript
// Deep drone layer
$: note("<[c2,g2]@8 [f2,c3]@8>")
  .sound("sawtooth")
  .lpf(200)
  .room(0.9)
  .gain(0.3)

// Textural pad layer
$: note("<[g3,b3,d4] [a3,c4,e4] [f3,a3,c4]>")
  .sound("triangle")
  .slow(2)
  .room(0.7)
  .delay(0.4)
  .lpf(1200)
  .gain(0.5)

// Sparse melodic elements
$: note("c5 ~ e5 ~ g5 ~ ~ ~")
  .sound("sine")
  .slow(4)
  .room(0.8)
  .delay(0.5)
  .gain(0.4)
```

Adjust note choices, rhythms, effects, and layering based on user's aesthetic preferences.

## Resources

### references/

- `pattern_syntax.md` - Complete mini-notation reference and advanced pattern techniques
- `ambient_examples.md` - Curated examples of ambient soundscape patterns
- `strudel_api.md` - Core Strudel functions, effects, and sound sources

These references provide deeper technical details. Load them when working on complex patterns or when user asks for advanced techniques.

### assets/

- `neovim_config_snippet.lua` - Example strudel.nvim configuration for lazy.nvim
- `ambient_template.str` - Starting template for ambient soundscape
- `boards_of_canada_inspired.str` - Pattern example inspired by BoC aesthetic

Use these templates as starting points and customize based on user requests.

## Future Integration: Claude Code Hooks

The user has expressed interest in integrating soundscapes with Claude Code hooks, where tool usage triggers sounds to create an ambient backdrop that reflects the session's activity. When this is requested:

- Design sound events that map to tool categories (file operations, git commands, etc.)
- Create non-intrusive ambient triggers using sparse patterns
- Balance between feedback and distraction
- Use the Strudel pattern language to generate contextual audio

This integration is planned for future development once core music creation is working well.
