# Projectile Motion with Aerodynamic Drag

MATLAB simulation of free-fall with aerodynamic drag for three objects. Analyzes terminal velocity, Reynolds number, and flow regime.

## Preview
![Output](preview.png)

## Objects simulated
| Object | Mass (kg) | Diameter (m) | Cd |
|--------|-----------|--------------|-----|
| Baseball | 0.145 | 0.074 | 0.47 |
| Skydiver | 80 | 0.50 | 1.00 |
| Feather | 0.003 | 0.05 | 1.50 |

## Outputs
- Velocity vs time (with terminal velocity lines)
- Distance fallen vs time
- Acceleration vs time
- Drag force vs time
- Reynolds number per object with flow regime classification

## Theory
Drag force: F = ½ρCdAv²

Terminal velocity: v_t = √(2mg/ρCdA)

Reynolds number: Re = ρvD/μ

Numerical integration using Euler method.

## How to run
```matlab
% Run projectile_drag.m
% Modify objects cell array to add your own objects
```

## Tools
MATLAB R2024a

## Skills demonstrated
Fluid mechanics • Drag analysis • Terminal velocity • Reynolds number • Euler numerical integration • MATLAB
