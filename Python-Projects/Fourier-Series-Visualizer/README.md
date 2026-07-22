# Fourier Series Visualizer

Interactive visualization tool for Fourier series decomposition built in Python.

Developed alongside ENGR 311 — Transform Calculus and Partial Differential Equations at Concordia University.

## Run it

Download and run [`fourier_visualizer.py`](fourier_visualizer.py)

## Wave Functions

**Square wave**
$$f(x) = \frac{4}{\pi} \sum_{n=1,3,5,...}^{N} \frac{1}{n} \sin(nx)$$

**Sawtooth wave**
$$f(x) = \sum_{n=1}^{N} \frac{(-1)^{n+1} \cdot 2}{\pi n} \sin(nx)$$

**Triangle wave**
$$f(x) = \sum_{n=1,3,5,...}^{N} \frac{(-1)^{\frac{n-1}{2}} \cdot 8}{\pi^2 n^2} \sin(nx)$$

## Files

- `fourier_visualizer.py` — main interactive application
- `Square_wave.py` — square wave decomposition
- `Sawtooth_wave.py` — sawtooth wave decomposition
- `Triangle_wave.py` — triangle wave decomposition

## What it does

- Real-time Fourier approximation with interactive slider (1 to 50 harmonics)
- Switch between square, sawtooth, and triangle waves
- Frequency spectrum showing harmonic coefficients
- Approximation error plot with RMS value
- Convergence analysis — RMS error vs number of terms

## Controls

- **Slider** — adjust number of harmonic terms (N)
- **Square / Sawtooth / Triangle** — switch wave type

## Tools

Python • NumPy • Matplotlib

## Skills demonstrated

Fourier analysis • Frequency domain decomposition • Numerical methods • Python • Engineering visualization
