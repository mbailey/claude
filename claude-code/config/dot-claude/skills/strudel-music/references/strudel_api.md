# Strudel API Reference

Core functions, effects, and sound sources for creating music with Strudel.

## Pattern Creation Functions

### `note(pattern)`
Create melodic patterns using note names or MIDI numbers.

```javascript
note("c3 e3 g3")           // note names
note("60 64 67")           // MIDI numbers
note("<c3 e3 g3 b3>")      // alternating notes
note("[c3,e3,g3]")         // chord
```

### `s(pattern)` / `sound(pattern)`
Play samples from built-in or custom sample banks.

```javascript
s("bd sd cp hh")           // drum samples
s("space wind pad")        // ambient samples
s("piano:0 piano:1")       // specific sample variations
```

### `n(pattern)`
Select sample variations by number.

```javascript
s("piano").n("0 1 2 3")
s("casio").n("<0 1 2>")
```

## Sound Sources

### `.sound(waveform)`
Select synthesizer waveform.

```javascript
note("c3").sound("sawtooth")
note("e3").sound("sine")
note("g3").sound("triangle")
note("c4").sound("square")
```

### Built-in Sample Banks
Common sample categories:
- Drums: `bd`, `sd`, `cp`, `hh`, `oh`, `ch`, `cymbal`
- Percussion: `tabla`, `hand`, `clap`
- Ambient: `space`, `wind`, `pad`, `drone`
- Melodic: `piano`, `gtr`, `bass`, `casio`
- Textures: `glitch`, `noise`, `click`

## Time Manipulation

### `.slow(factor)`
Slow down the pattern by factor.

```javascript
note("c e g").slow(2)      // 2x slower (over 2 cycles)
note("c e g").slow(8)      // 8x slower (ambient pace)
```

### `.fast(factor)`
Speed up the pattern by factor.

```javascript
note("c e g").fast(2)      // 2x faster
note("c e g").fast(0.5)    // same as .slow(2)
```

### `.every(n, function)`
Apply function every nth cycle.

```javascript
note("c e g").every(4, rev)                    // reverse every 4th cycle
note("c e g").every(3, x => x.fast(2))         // double speed every 3rd cycle
note("c e g").every(2, x => x.add(7))          // transpose up every 2nd cycle
```

## Effects

### Spatial Effects

#### `.room(amount)`
Reverb amount (0-1).

```javascript
s("bd sd").room(0.8)       // heavy reverb
note("c e g").room(0.3)    // light reverb
```

#### `.delay(amount)`
Delay/echo amount (0-1).

```javascript
note("c5").delay(0.5).room(0.7)    // delay + reverb
s("cp").delay(0.3)                  // echo effect
```

#### `.pan(position)`
Stereo position (0=left, 0.5=center, 1=right).

```javascript
note("c e g").pan(0.2)              // left side
note("c e g").pan("<0 0.5 1>")      // moving pan
```

### Filter Effects

#### `.lpf(frequency)`
Low-pass filter - removes frequencies above cutoff.

```javascript
note("c e g").sound("sawtooth").lpf(800)    // warm, muffled
s("pad").lpf(400)                            // dark texture
```

#### `.hpf(frequency)`
High-pass filter - removes frequencies below cutoff.

```javascript
note("c e g").hpf(500)             // thin, airy
s("wind").hpf(1000)                // high-frequency texture
```

#### `.lpq(resonance)`
Low-pass filter resonance (0-30, default ~10).

```javascript
note("c e g").lpf(800).lpq(20)     // resonant filtering
```

### Amplitude Effects

#### `.gain(amount)`
Volume/amplitude (0-1, can go higher).

```javascript
s("bd").gain(0.8)                  // loud
note("c e g").gain(0.3)            // quiet
```

#### `.amp(amount)`
Alias for `.gain()`.

### Pitch Effects

#### `.speed(factor)`
Playback speed (affects pitch).

```javascript
s("bd").speed(0.5)                 // lower pitch, slower
s("bd").speed(2)                   // higher pitch, faster
s("pad").speed("<0.9 1 1.1>")      // subtle pitch drift
```

#### `.add(semitones)`
Transpose by semitones.

```javascript
note("c e g").add(7)               // up a perfect fifth
note("c e g").add(-12)             // down an octave
```

## Pattern Transformations

### `.rev()` / `.reverse()`
Reverse the pattern.

```javascript
note("c e g b").rev()              // plays: b g e c
```

### `.palindrome()`
Play pattern forward then backward.

```javascript
note("c e g").palindrome()         // plays: c e g e c
```

### `.iter(n)`
Rotate pattern by 1 step every cycle, n times.

```javascript
note("c e g b").iter(4)
```

### `.jux(function)`
Apply function to right channel only (stereo effect).

```javascript
note("c e g").jux(rev)             // reversed in right channel
note("c e g").jux(x => x.add(7))   // transposed in right channel
```

## Stacking and Layering

### `stack(...patterns)`
Layer multiple patterns simultaneously.

```javascript
stack(
  note("c2").sound("sawtooth").slow(4),
  note("c e g").sound("sine"),
  s("bd ~ ~ ~")
)
```

### `.layer(...functions)`
Apply multiple transformations as layers.

```javascript
note("c e g").layer(
  x => x.sound("sawtooth"),
  x => x.sound("sine").add(12),
  x => x.sound("triangle").add(19)
)
```

## Randomness and Variation

### `.degrade(probability)`
Randomly remove events.

```javascript
s("hh hh hh hh").degrade(0.3)      // remove 30% of hits
note("c e g b").degrade(0.5)       // 50% removal
```

### `.sometimes(function)`
Apply function randomly (50% chance).

```javascript
note("c e g").sometimes(rev)
note("c e g").sometimes(x => x.add(12))
```

### `.often(function)`
Apply function 75% of the time.

```javascript
s("hh hh hh hh").often(x => x.gain(0.5))
```

### `.rarely(function)`
Apply function 25% of the time.

```javascript
note("c e g").rarely(x => x.add(7))
```

## Continuous Functions

### `sine` / `saw` / `square` / `tri`
Generate continuous waveforms for parameter modulation.

```javascript
// Sine wave modulation
note("c").lpf(sine.range(200, 2000).slow(8))

// Saw wave panning
s("hh").pan(saw.slow(4))

// Range specification
note("c").gain(sine.range(0.3, 0.8).slow(16))
```

## Ambient-Specific Techniques

### Long Evolving Drones
```javascript
note("[c2,g2]")
  .sound("sawtooth")
  .lpf(sine.range(100, 400).slow(32))
  .room(0.9)
  .gain(0.3)
  .slow(16)
```

### Textural Layers
```javascript
s("space(5,13)")
  .speed("<0.5 0.6 0.7 0.5>")
  .room(0.85)
  .lpf(800)
  .gain(0.3)
  .slow(4)
```

### Sparse Melodies
```javascript
note("~ ~ c5 ~ ~ ~ e5 ~ ~ ~ ~ ~ g5 ~ ~ ~")
  .sound("sine")
  .room(0.9)
  .delay(0.6)
  .gain(0.35)
  .slow(8)
```

### Stereo Width
```javascript
note("c e g")
  .jux(x => x.add(0.01))  // slight detune in right channel
  .room(0.7)
  .slow(4)
```

## Tempo Control

### `setcps(cycles_per_second)`
Set tempo (cycles per second).

```javascript
setcps(0.5)    // 0.5 cycles/second (very slow for ambient)
setcps(1)      // default (1 cycle/second)
setcps(2)      // faster tempo
```

For ambient music, typical values are 0.25-0.5 cps.

## Custom Samples

### `samples(object)`
Load custom samples from URLs.

```javascript
samples({
  mysound: "https://example.com/sound.wav",
  drone: ["https://example.com/drone1.wav", "https://example.com/drone2.wav"]
})

s("mysound drone:0 drone:1")
```

## Pattern Variables

Use `$:` to define named patterns:

```javascript
$: note("c e g").sound("sine")      // unnamed pattern (stack layer)

// Named patterns
$: bass = note("c2").sound("sawtooth").slow(4)
$: melody = note("c5 e5 g5").sound("sine")

stack(bass, melody)
```

## Advanced Parameter Control

### `.struct(pattern)`
Use rhythm from pattern for timing:

```javascript
note("c e g").struct("t ~ t ~ t t ~ ~")
s("bd sd").struct("t(3,8)")
```

### `.off(time, function)`
Apply function with time offset (like echo):

```javascript
note("c e g").off(1/8, x => x.add(12))     // echo up an octave
note("c e g").off(1/4, x => x.gain(0.5))   // delayed quieter echo
```

### `.echo(divisions, time, feedback)`
Multi-tap echo effect:

```javascript
note("c e g").echo(4, 1/8, 0.6)    // 4 echoes, 1/8 note apart
```

## Useful Combinations for Ambient

### Infinite Reverb Pad
```javascript
note("[c2,g2,d3]")
  .sound("sine")
  .room(0.99)
  .delay(0.8)
  .lpf(300)
  .gain(0.2)
  .slow(32)
```

### Evolving Texture
```javascript
s("wind(3,11)")
  .speed(sine.range(0.4, 0.8).slow(20))
  .lpf(saw.range(400, 1200).slow(16))
  .room(0.9)
  .pan(sine.slow(24))
  .gain(0.25)
  .slow(8)
```

### Layered Soundscape
```javascript
stack(
  // Deep foundation
  note("[c2,g2]").sound("sawtooth").lpf(150).room(0.95).gain(0.25).slow(16),

  // Mid pad
  note("<[g3,b3,d4] [a3,c4,e4]>").sound("triangle").lpf(1000).room(0.7).gain(0.4).slow(8),

  // High sparkle
  note("~ ~ ~ ~ c5 ~ ~ ~ ~ ~ ~ ~ e5 ~ ~ ~").sound("sine").room(0.9).delay(0.6).gain(0.3).slow(6)
)
```
