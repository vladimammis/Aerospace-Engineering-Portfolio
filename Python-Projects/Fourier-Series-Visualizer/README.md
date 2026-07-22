
# Fourier Series Visualizer

Interactive visualization tool for Fourier series decomposition built in Python.

Developed alongside ENGR 311 — Transform Calculus and Partial Differential Equations at Concordia University.

![fourier_visualizer](preview.png)

## Files

- `fourier_visualizer.py` — main interactive application
- `Square_wave.py` — square wave Fourier decomposition
- `Sawtooth_wave.py` — sawtooth wave Fourier decomposition
- `Triangle_wave.py` — triangle wave Fourier decomposition

## What it does

- Real-time Fourier series approximation with interactive slider (1 to 50 harmonics)
- Switch between square, sawtooth, and triangle waves
- Frequency spectrum showing harmonic coefficients
- Approximation error plot with RMS value
- Convergence analysis — RMS error vs number of terms

## How to run

```bash
pip install matplotlib numpy
python fourier_visualizer.py
```

## Controls

- **Slider** — adjust number of harmonic terms (N)
- **Square / Sawtooth / Triangle** — switch wave type

## Tools

Python • NumPy • Matplotlib

## Skills demonstrated

Fourier analysis • Frequency domain decomposition • Numerical methods • Python • Engineering visualization
