#!/usr/bin/env python3
"""Generate a wooden-fish (木鱼) percussive sound (WAV).

Characteristics of a real wooden fish:
  - Sharp transient "knock" from mallet hitting wood (broadband noise burst)
  - Hollow body resonance at ~420 Hz with inharmonic overtones
  - Higher partials decay much faster than the fundamental
  - Overall duration ~300ms, most energy in the first 50ms
"""

import math
import random
import struct
import wave
import sys
import os

SAMPLE_RATE = 44100
DURATION = 0.35

random.seed(42)


def generate():
    n_samples = int(SAMPLE_RATE * DURATION)
    samples = []

    for i in range(n_samples):
        t = i / SAMPLE_RATE
        sample = 0.0

        # --- Layer 1: Attack transient (wood knock) ---
        # Short noise burst filtered by a fast envelope, gives the "tok" character.
        attack_env = math.exp(-t * 120) * min(1.0, t * 8000)
        noise = random.gauss(0, 1)
        # Band-limit the noise feel by mixing with a high-freq sine
        knock = noise * 0.6 + math.sin(2 * math.pi * 2800 * t) * 0.4
        sample += knock * attack_env * 0.45

        # --- Layer 2: Body resonance (hollow wood tone) ---
        # Fundamental ~420 Hz with inharmonic partials typical of wooden objects.
        body_env = math.exp(-t * 14)
        body = (
            0.55 * math.sin(2 * math.pi * 420 * t) +
            0.20 * math.sin(2 * math.pi * 420 * 2.37 * t) * math.exp(-t * 8) +
            0.12 * math.sin(2 * math.pi * 420 * 3.15 * t) * math.exp(-t * 18) +
            0.08 * math.sin(2 * math.pi * 420 * 4.72 * t) * math.exp(-t * 30)
        )
        sample += body * body_env * 0.50

        # --- Layer 3: Low thump (mallet impact) ---
        thump_env = math.exp(-t * 45)
        thump = math.sin(2 * math.pi * 140 * t)
        sample += thump * thump_env * 0.18

        # --- Layer 4: Subtle high ring (wood brightness) ---
        ring_env = math.exp(-t * 55)
        ring = math.sin(2 * math.pi * 1650 * t + 0.3)
        sample += ring * ring_env * 0.10

        value = int(sample * 32767 * 0.85)
        value = max(-32767, min(32767, value))
        samples.append(value)

    out_path = sys.argv[1] if len(sys.argv) > 1 else "woodenfish.wav"
    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)

    with wave.open(out_path, "w") as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(SAMPLE_RATE)
        wf.writeframes(struct.pack(f"<{len(samples)}h", *samples))

    print(f"Generated: {out_path} ({os.path.getsize(out_path)} bytes)")


if __name__ == "__main__":
    generate()
