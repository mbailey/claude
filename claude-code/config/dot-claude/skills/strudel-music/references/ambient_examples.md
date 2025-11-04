# Ambient Soundscape Examples

Curated Strudel patterns for creating atmospheric, ambient music inspired by Boards of Canada, Biosphere, and Music for Programming aesthetics.

## Foundational Drone Patterns

### Deep Bass Drone
```javascript
note("<[c2,g2]@8 [f2,c3]@8>")
  .sound("sawtooth")
  .lpf(150)
  .room(0.9)
  .gain(0.3)
  .slow(4)
```

Creates a slowly evolving low-frequency foundation with heavy reverb and filtering.

### Harmonic Pad Layer
```javascript
note("<[g3,b3,d4]@4 [a3,c4,e4]@4 [f3,a3,c4]@4 [e3,g3,b3]@4>")
  .sound("triangle")
  .lpf(1200)
  .hpf(200)
  .room(0.7)
  .delay(0.3)
  .gain(0.5)
  .slow(6)
```

Mid-range harmonic texture with gentle chord changes.

## Rhythmic Textures (Non-Obvious)

### Euclidean Ambience
```javascript
s("pad(3,13)")
  .slow(4)
  .room(0.8)
  .speed(0.5)
  .lpf(600)
  .gain(0.4)
```

Sparse, algorithmically-distributed hits create organic, non-repetitive texture.

### Polyrhythmic Layers
```javascript
stack(
  s("space(5,16)").slow(3).room(0.9).gain(0.3),
  s("wind(3,11)").slow(5).room(0.8).gain(0.2),
  s("pad(2,9)").slow(7).room(0.85).gain(0.25)
)
```

Multiple euclidean patterns with different cycle lengths create evolving, phase-shifting textures.

## Melodic Fragments

### Sparse Melody
```javascript
note("~ ~ c5 ~ ~ ~ e5 ~ ~ g5 ~ ~ ~ ~ ~ ~")
  .sound("sine")
  .room(0.9)
  .delay(0.6)
  .lpf(2000)
  .gain(0.4)
  .slow(2)
```

Minimal melodic elements with maximum space - let notes breathe.

### Descending Fragments
```javascript
note("~ e5 ~ ~ d5 ~ ~ ~ c5 ~ ~ ~ ~ ~ ~ ~")
  .sound("sine")
  .room(0.8)
  .delay(0.5)
  .speed("<1 0.9 0.95 1.05>")  // subtle pitch variation
  .gain(0.35)
  .slow(4)
```

Slow descending pattern with subtle pitch drift.

## Complete Soundscape Examples

### Boards of Canada Inspired
```javascript
// Layer 1: Deep foundation
$: note("<[c2,g2]@8 [bb1,f2]@8>")
  .sound("sawtooth")
  .lpf(180)
  .room(0.95)
  .gain(0.25)
  .slow(8)

// Layer 2: Harmonic pad
$: note("<[g3,b3,d4] [a3,c4,e4] [f3,a3,c4]>")
  .sound("triangle")
  .lpf(1000)
  .room(0.75)
  .delay(0.3)
  .gain(0.45)
  .slow(4)

// Layer 3: Textural euclidean pattern
$: s("space(5,13)")
  .speed(0.7)
  .room(0.85)
  .lpf(800)
  .gain(0.3)
  .slow(3)

// Layer 4: Sparse melodic elements
$: note("~ ~ c5 ~ ~ e5 ~ ~ ~ g5 ~ ~ ~ ~ ~ ~")
  .sound("sine")
  .room(0.9)
  .delay(0.6)
  .gain(0.3)
  .slow(6)
```

### Biosphere / Polar Ambience
```javascript
// Layer 1: Icy drone
$: note("[c2,g2,d3]")
  .sound("sine")
  .lpf(200)
  .room(0.98)
  .gain(0.2)
  .slow(16)

// Layer 2: Wind-like texture
$: s("wind(3,17)")
  .speed("<0.5 0.6 0.4>")
  .room(0.9)
  .hpf(400)
  .gain(0.25)
  .slow(5)

// Layer 3: Crystalline high notes
$: note("~ ~ ~ ~ e5 ~ ~ ~ ~ ~ ~ ~ c5 ~ ~ ~")
  .sound("sine")
  .room(0.95)
  .delay(0.7)
  .hpf(1000)
  .gain(0.2)
  .slow(8)

// Layer 4: Sub-bass pulse (very slow)
$: note("c1")
  .sound("sine")
  .gain(0.15)
  .slow(32)
```

### Music for Programming Aesthetic
```javascript
// Layer 1: Minimal bass
$: note("<c2 f2 g2 bb2>")
  .sound("sawtooth")
  .lpf(150)
  .room(0.8)
  .gain(0.3)
  .slow(8)

// Layer 2: Atmospheric pad
$: note("<[g3,b3,d4]@3 ~ [a3,c4,e4]@3 ~>")
  .sound("triangle")
  .lpf(900)
  .room(0.7)
  .delay(0.4)
  .gain(0.4)
  .slow(4)

// Layer 3: Subtle rhythm (very sparse)
$: s("~ ~ ~ ~ bd ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~")
  .room(0.6)
  .lpf(200)
  .gain(0.2)
  .slow(2)

// Layer 4: Occasional bell-like tones
$: note("~ ~ ~ c5 ~ ~ ~ ~ ~ ~ e5 ~ ~ ~ ~ ~")
  .sound("sine")
  .room(0.9)
  .delay(0.5)
  .gain(0.25)
  .slow(6)
```

## Technique: Evolving Parameters

### Slow Filter Sweeps
```javascript
note("[c3,g3]")
  .sound("sawtooth")
  .lpf(sine.range(200, 1200).slow(32))  // very slow filter movement
  .room(0.8)
  .gain(0.4)
```

### Drifting Reverb
```javascript
note("<[e3,g3,b3] [f3,a3,c4]>")
  .sound("triangle")
  .room(sine.range(0.5, 0.95).slow(16))  // reverb amount slowly changes
  .gain(0.5)
  .slow(4)
```

### Wandering Pan
```javascript
note("~ c5 ~ ~ ~ e5 ~ ~")
  .sound("sine")
  .pan(sine.slow(20))  // slowly moves across stereo field
  .room(0.8)
  .gain(0.35)
  .slow(4)
```

## Tips for Ambient Soundscapes

1. **Use `.slow()` generously** - Ambient music breathes at 4x, 8x, or even 16x slower than default
2. **Layer density levels** - Combine dense drones with sparse melodic elements
3. **Heavy reverb** - `.room(0.7-0.95)` creates space and depth
4. **Filter aggressively** - `.lpf()` to remove harshness, creates warmth
5. **Embrace rests** - Silence is as important as sound
6. **Euclidean patterns** - Use low hit counts (2-5) over large segments (11-17) for organic spacing
7. **Subtle pitch drift** - Use `<>` with slight variations in `.speed()` for analog character
8. **Long delay times** - `.delay(0.4-0.7)` with reverb creates expansive space
9. **Stack thoughtfully** - 3-5 layers work well; more can become muddy
10. **Low volumes** - Keep `.gain()` low (0.2-0.5) for individual layers to prevent distortion

## Chord Progressions for Ambient

### Warm and Consonant
```javascript
note("<[c3,e3,g3] [f3,a3,c4] [g3,b3,d4] [c3,e3,g3]>").slow(8)
```

### Modal and Open
```javascript
note("<[d3,a3] [e3,b3] [c3,g3]>").slow(12)
```

### Dark and Mysterious
```javascript
note("<[c3,g3,bb3] [ab3,eb4] [f3,c4]>").slow(10)
```

### Minimal (Perfect Fifths)
```javascript
note("<[c2,g2] [f2,c3] [bb2,f3]>").slow(16)
```
