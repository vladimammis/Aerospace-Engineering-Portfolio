# Laplace Transform Visualizer

Interactive visualization of Laplace transforms built in Python.
Developed alongside ENGR 311 — Transform Calculus and Partial Differential Equations at Concordia University.

## Run it

Download and run [`laplace_visualizer.py`](laplace_visualizer.py)

## Files

- `laplace_visualizer.py` — main interactive application
- `Step_laplace.py` — unit step transform: f(t) = u(t), F(s) = 1/s
- `Ramp_laplace.py` — ramp transform: f(t) = t, F(s) = 1/s²
- `Sine_laplace.py` — sine transform: f(t) = sin(ωt), F(s) = ω/(s²+ω²)
- `Exponential_laplace.py` — exponential transform: f(t) = e^(-at), F(s) = 1/(s+a)
- `Damped_Sine_laplace.py` — damped sine: f(t) = e^(-0.5t)sin(ωt), F(s) = ω/((s+0.5)²+ω²)

## What it shows

- Time domain signal f(t)
- |F(s)| magnitude in the complex s-plane
- Pole-zero diagram with poles (×) and zeros (○)
- System step response

## Tools

Python • NumPy • Matplotlib

## Skills demonstrated

Laplace transforms • Frequency domain analysis • Pole-zero analysis • Control systems • Python
