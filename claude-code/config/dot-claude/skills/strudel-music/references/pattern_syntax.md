# Strudel Pattern Syntax Reference

## Mini-Notation Basics

### Sequences

Space-separated events fit into one cycle:
```javascript
note("c e g b")  // 4 notes, each 1/4 cycle long
```

### Subdivision with Brackets `[]`

Nest sequences to subdivide time - bracketed events fit within one outer event's duration:
```javascript
note("e5 [b4 c5] d5 [c5 b4]")  // beat 2 and 4 subdivided into two events
```

### Angle Brackets `<>`

Alternate between options - define length by event count:
```javascript
note("<e5 b4 d5 c5>")  // cycles through one note per cycle
```

Equivalent to `[e5 b4 d5 c5]/4`

## Time Manipulation

| Operator | Function | Example | Result |
|----------|----------|---------|--------|
| `*N` | Speed up N times | `[e5 b4]*2` | Play pattern twice per cycle |
| `/N` | Slow down N times | `[e5 b4]/2` | Play pattern over 2 cycles |
| `@N` | Weight/elongation | `[g3,b3]@2` | Event lasts 2x longer |
| `!N` | Repeat without speed | `[g3,b3]!2` | Repeat pattern without speeding up |

### Chaining Time Modifiers

```javascript
note("c e g")*2/4  // double speed, then slow down to 1/2 speed
```

## Polyphony and Chords

Comma-separated notes play simultaneously:
```javascript
note("[g3,b3,e4]")  // G major chord
note("[g3,b3,e4] [a3,c3,e4]")  // two chords in sequence
```

## Rests and Silence

`~` creates silence:
```javascript
note("[b4 [~ c5] d5 e5]")  // silence on 2nd subdivision of beat 2
s("bd ~ sd ~")  // kick and snare on beats 1 and 3
```

## Randomness

### Removal Probability

`?` removes event with specified probability:
```javascript
note("[g3,b3,e4]*8?0.1")  // 10% chance each chord is removed
note("c?")  // 50% chance (default)
```

### Random Selection

`|` selects randomly between options:
```javascript
note("[g3,b3,e4] | [a3,c3,e4]")  // randomly pick one chord each cycle
s("bd | cp | sd")  // random drum sound each cycle
```

## Euclidean Rhythms

Distribute beats evenly across segments using algorithmic pattern generation:

```
event(beats, segments, offset)
```

Examples:
```javascript
s("bd(3,8)")  // 3 bass drums across 8 steps
s("bd(3,8,2)")  // same, but rotated 2 steps
s("cp(5,12)")  // 5 claps across 12 steps
```

Creates non-repetitive, organic rhythmic patterns perfect for ambient textures.

## Advanced Pattern Combinations

### Layered Ambient Example

```javascript
// Slow evolving chord progression
note("<[c3,g3]@4 [f3,c4]@4 [g3,d4]@4 [a3,e4]@4>")
  .slow(8)  // 8x slower
  .sound("triangle")

// Sparse melodic fragments with rests
note("c5 ~ ~ e5 ~ g5 ~ ~")
  .slow(4)
  .sound("sine")

// Euclidean textural layer
s("pad(5,13)")
  .slow(2)
  .room(0.9)
```

## Stacking Patterns

Combine multiple patterns into a single voice:

```javascript
stack(
  note("c2").sound("sawtooth"),
  note("c3 e3 g3").sound("sine"),
  s("bd ~ ~ ~").slow(2)
)
```

## Function Syntax

Most Strudel transformations use method chaining:

```javascript
note("c e g")
  .slow(2)         // make it slower
  .every(4, rev)   // reverse every 4th cycle
  .room(0.7)       // add reverb
  .lpf(800)        // low-pass filter
```

## Format Rules

- **Backticks** `` ` ``: Parse as mini-notation, supports multiline
- **Double quotes** `"`: Single-line mini-notation parsing
- **Single quotes** `'`: Regular strings (no mini-notation parsing)

Examples:
```javascript
note("c e g")           // parsed as mini-notation
note('c')               // literal string 'c'
note(`c e g             // multiline mini-notation
      b d f`)
```

## Ambient Music Pattern Techniques

### Sustained Drones

Use elongation and slow cycles:
```javascript
note("<[c2,g2]@8 [f2,c3]@8>").slow(4)
```

### Gentle Evolution

Combine slow patterns with subtle variations:
```javascript
note("<c3 d3 e3 f3>")
  .slow(8)
  .every(4, add(7))  // transpose every 4th cycle
```

### Sparse Textures

Use rests generously:
```javascript
note("~ c5 ~ ~ e5 ~ ~ ~ g5 ~ ~ ~ ~ ~ ~ ~").slow(2)
```

### Euclidean Ambience

Low-density euclidean patterns for organic spacing:
```javascript
s("pad(3,16)").slow(4)  // very sparse, non-repetitive
s("bell(2,11)").slow(8)  // even more sparse
```

### Layering Strategy

Combine multiple density layers:
```javascript
// Dense low drone
note("[c2,g2]").sound("sawtooth").slow(8)

// Medium-sparse mid-range
note("~ e3 ~ g3 ~ ~ ~ ~").sound("triangle").slow(4)

// Very sparse high notes
note("~ ~ ~ ~ ~ c5 ~ ~ ~ ~ ~ ~ ~ ~ ~ ~").sound("sine").slow(2)
```
