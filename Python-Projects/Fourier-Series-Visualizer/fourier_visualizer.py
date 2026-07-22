import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button

fig, axes = plt.subplots(2, 2, figsize=(14, 9))
fig.patch.set_facecolor('#0d1117')
for ax in axes.flat:
    ax.set_facecolor('#161b22')
    ax.tick_params(colors='#8b949e')
    for spine in ax.spines.values():
        spine.set_color('#30363d')

fig.suptitle('Fourier Series Visualizer — ENGR 311', color='#e6edf3', fontsize=14, fontweight='bold')
plt.subplots_adjust(bottom=0.2, hspace=0.4, wspace=0.35)

x = np.linspace(-np.pi, np.pi, 1000)
N_terms = 5
current_wave = ['Square']

def square_wave(x):
    return np.where(np.sin(x) >= 0, 1.0, -1.0)

def sawtooth_wave(x):
    return (x % (2*np.pi)) / np.pi - 1

def triangle_wave(x):
    return 2 * np.abs(2*(x/(2*np.pi) - np.floor(x/(2*np.pi) + 0.5))) - 1

def fourier_square(x, N):
    result = np.zeros_like(x, dtype=float)
    for n in range(1, N+1, 2):
        result += (4/(np.pi*n)) * np.sin(n*x)
    return result

def fourier_sawtooth(x, N):
    result = np.zeros_like(x, dtype=float)
    for n in range(1, N+1):
        result += ((-1)**(n+1)) * (2/(np.pi*n)) * np.sin(n*x)
    return result

def fourier_triangle(x, N):
    result = np.zeros_like(x, dtype=float)
    for n in range(1, N+1, 2):
        result += ((-1)**((n-1)//2)) * (8/(np.pi**2*n**2)) * np.sin(n*x)
    return result

waves = {
    'Square':   (square_wave,   fourier_square,   '#58a6ff'),
    'Sawtooth': (sawtooth_wave, fourier_sawtooth, '#3fb950'),
    'Triangle': (triangle_wave, fourier_triangle, '#f78166'),
}

def get_coeffs(wave_name, N):
    harmonics = np.arange(1, N+1)
    if wave_name == 'Square':
        return harmonics, np.array([4/(np.pi*n) if n%2==1 else 0.0 for n in harmonics])
    elif wave_name == 'Sawtooth':
        return harmonics, np.array([((-1)**(n+1))*2/(np.pi*n) for n in harmonics])
    else:
        return harmonics, np.array([((-1)**((n-1)//2))*8/(np.pi**2*n**2) if n%2==1 else 0.0 for n in harmonics])

ax1, ax2, ax3, ax4 = axes[0,0], axes[0,1], axes[1,0], axes[1,1]

def style_ax(ax):
    ax.set_facecolor('#161b22')
    for spine in ax.spines.values():
        spine.set_color('#30363d')
    ax.tick_params(colors='#8b949e', labelsize=8)

def update_plots(val):
    N = int(slider.val)
    name = current_wave[0]
    orig_func, fourier_func, color = waves[name]
    approx = fourier_func(x, N)
    original = orig_func(x)
    error = original - approx
    harmonics, coeffs = get_coeffs(name, N)

    for ax in [ax1, ax2, ax3, ax4]:
        ax.cla()
        style_ax(ax)

    ax1.plot(x, original, color='#8b949e', linewidth=1.5, linestyle='--', label='Original', alpha=0.7)
    ax1.plot(x, approx, color=color, linewidth=2, label=f'N={N} terms')
    ax1.set_title(f'{name} Wave — Fourier Approximation', color='#e6edf3', fontsize=10)
    ax1.set_xlabel('x', color='#8b949e')
    ax1.set_ylabel('f(x)', color='#8b949e')
    ax1.legend(fontsize=8, facecolor='#21262d', labelcolor='#e6edf3', edgecolor='#30363d')
    ax1.set_xlim(-np.pi, np.pi)
    ax1.set_ylim(-1.5, 1.5)
    ax1.axhline(0, color='#30363d', linewidth=0.5)

    markerline, stemlines, baseline = ax2.stem(harmonics, np.abs(coeffs))
    plt.setp(markerline, color=color, markersize=5)
    plt.setp(stemlines, color=color, linewidth=1.5, alpha=0.7)
    plt.setp(baseline, color='#30363d')
    ax2.set_title('Frequency Spectrum', color='#e6edf3', fontsize=10)
    ax2.set_xlabel('Harmonic n', color='#8b949e')
    ax2.set_ylabel('|Bₙ|', color='#8b949e')

    ax3.plot(x, error, color='#f78166', linewidth=1.5)
    ax3.fill_between(x, error, alpha=0.2, color='#f78166')
    rms = np.sqrt(np.mean(error**2))
    ax3.set_title('Approximation Error', color='#e6edf3', fontsize=10)
    ax3.set_xlabel('x', color='#8b949e')
    ax3.set_ylabel('Error', color='#8b949e')
    ax3.axhline(0, color='#30363d', linewidth=0.5)
    ax3.set_xlim(-np.pi, np.pi)
    ax3.text(0.02, 0.95, f'RMS: {rms:.4f}', transform=ax3.transAxes,
             color='#e6edf3', fontsize=8, va='top',
             bbox=dict(boxstyle='round', facecolor='#21262d', alpha=0.8, edgecolor='#30363d'))

    n_range = np.arange(1, 50)
    rms_vals = [np.sqrt(np.mean((orig_func(x) - fourier_func(x, n))**2)) for n in n_range]
    ax4.plot(n_range, rms_vals, color=color, linewidth=2)
    ax4.axvline(N, color='#f0883e', linewidth=1.5, linestyle='--', label=f'N={N}')
    ax4.set_title('RMS Error vs N Terms', color='#e6edf3', fontsize=10)
    ax4.set_xlabel('N terms', color='#8b949e')
    ax4.set_ylabel('RMS Error', color='#8b949e')
    ax4.legend(fontsize=8, facecolor='#21262d', labelcolor='#e6edf3', edgecolor='#30363d')
    ax4.set_xlim(1, 50)

    fig.canvas.draw_idle()

ax_slider = plt.axes([0.15, 0.08, 0.5, 0.03], facecolor='#21262d')
slider = Slider(ax_slider, 'Harmonics (N)', 1, 50, valinit=N_terms, valstep=1, color='#58a6ff')
slider.label.set_color('#e6edf3')
slider.valtext.set_color('#e6edf3')
slider.on_changed(update_plots)

ax_sq = plt.axes([0.15, 0.02, 0.11, 0.04])
btn_sq = Button(ax_sq, 'Square', color='#21262d', hovercolor='#30363d')
btn_sq.label.set_color('#58a6ff')

ax_saw = plt.axes([0.28, 0.02, 0.11, 0.04])
btn_saw = Button(ax_saw, 'Sawtooth', color='#21262d', hovercolor='#30363d')
btn_saw.label.set_color('#3fb950')

ax_tri = plt.axes([0.41, 0.02, 0.11, 0.04])
btn_tri = Button(ax_tri, 'Triangle', color='#21262d', hovercolor='#30363d')
btn_tri.label.set_color('#f78166')

def cb_square(event):
    current_wave[0] = 'Square'
    update_plots(None)

def cb_sawtooth(event):
    current_wave[0] = 'Sawtooth'
    update_plots(None)

def cb_triangle(event):
    current_wave[0] = 'Triangle'
    update_plots(None)

btn_sq.on_clicked(cb_square)
btn_saw.on_clicked(cb_sawtooth)
btn_tri.on_clicked(cb_triangle)

update_plots(None)
print("done")
plt.show()