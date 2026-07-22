import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button
from matplotlib.patches import Circle
import warnings
warnings.filterwarnings('ignore')

fig, axes = plt.subplots(2, 2, figsize=(14, 9))
fig.patch.set_facecolor('#0d1117')
for ax in axes.flat:
    ax.set_facecolor('#161b22')
    ax.tick_params(colors='#8b949e')
    for spine in ax.spines.values():
        spine.set_color('#30363d')

fig.suptitle('Laplace Transform Visualizer — ENGR 311', color='#e6edf3', fontsize=14, fontweight='bold')
plt.subplots_adjust(bottom=0.22, hspace=0.45, wspace=0.35)

ax1, ax2, ax3, ax4 = axes[0,0], axes[0,1], axes[1,0], axes[1,1]

current_func = ['Step']
t = np.linspace(0, 10, 1000)
sigma = np.linspace(-3, 3, 300)
omega = np.linspace(-10, 10, 300)
S, W = np.meshgrid(sigma, omega)
s_complex = S + 1j*W

def style_ax(ax):
    ax.set_facecolor('#161b22')
    for spine in ax.spines.values():
        spine.set_color('#30363d')
    ax.tick_params(colors='#8b949e', labelsize=8)
    ax.xaxis.label.set_color('#8b949e')
    ax.yaxis.label.set_color('#8b949e')
    ax.title.set_color('#e6edf3')

functions = {
    'Step': {
        'color': '#58a6ff',
        'time': lambda t, p: np.ones_like(t),
        'laplace': lambda s, p: np.abs(1/s),
        'poles': lambda p: [0+0j],
        'zeros': lambda p: [],
        'label': 'f(t) = u(t)',
        'F_label': 'F(s) = 1/s',
        'response': lambda t, p: 1 - np.exp(-t),
    },
    'Ramp': {
        'color': '#3fb950',
        'time': lambda t, p: t,
        'laplace': lambda s, p: np.abs(1/s**2),
        'poles': lambda p: [0+0j, 0+0j],
        'zeros': lambda p: [],
        'label': 'f(t) = t',
        'F_label': 'F(s) = 1/s²',
        'response': lambda t, p: t - 1 + np.exp(-t),
    },
    'Sine': {
        'color': '#f78166',
        'time': lambda t, p: np.sin(p*t),
        'laplace': lambda s, p: np.abs(p/(s**2 + p**2)),
        'poles': lambda p: [0+p*1j, 0-p*1j],
        'zeros': lambda p: [0+0j],
        'label': 'f(t) = sin(ωt)',
        'F_label': 'F(s) = ω/(s²+ω²)',
        'response': lambda t, p: (1/p) * (1 - np.cos(p*t)),
    },
    'Exponential': {
        'color': '#f0883e',
        'time': lambda t, p: np.exp(-p*t),
        'laplace': lambda s, p: np.abs(1/(s+p)),
        'poles': lambda p: [-p+0j],
        'zeros': lambda p: [],
        'label': 'f(t) = e^(-at)',
        'F_label': 'F(s) = 1/(s+a)',
        'response': lambda t, p: (1/p)*(1 - np.exp(-p*t)) if p != 0 else t,
    },
    'Damped Sine': {
        'color': '#bc8cff',
        'time': lambda t, p: np.exp(-0.5*t)*np.sin(p*t),
        'laplace': lambda s, p: np.abs(p/((s+0.5)**2 + p**2)),
        'poles': lambda p: [-0.5+p*1j, -0.5-p*1j],
        'zeros': lambda p: [0+0j],
        'label': 'f(t) = e^(-0.5t)sin(ωt)',
        'F_label': 'F(s) = ω/((s+0.5)²+ω²)',
        'response': lambda t, p: np.exp(-0.5*t)*(np.cos(p*t) + 0.5/max(p,0.01)*np.sin(p*t)),
    },
}

def update_plots(val):
    name = current_func[0]
    param = slider.val
    f = functions[name]
    color = f['color']

    for ax in [ax1, ax2, ax3, ax4]:
        ax.cla()
        style_ax(ax)

    # Panel 1 — Time domain
    ft = f['time'](t, param)
    ft_clipped = np.clip(ft, -5, 5)
    ax1.plot(t, ft_clipped, color=color, linewidth=2)
    ax1.set_title(f'Time Domain: {f["label"]}', color='#e6edf3', fontsize=10)
    ax1.set_xlabel('t', color='#8b949e')
    ax1.set_ylabel('f(t)', color='#8b949e')
    ax1.axhline(0, color='#30363d', linewidth=0.8)
    ax1.axvline(0, color='#30363d', linewidth=0.8)
    ax1.set_xlim(0, 10)

    # Panel 2 — S-domain magnitude
    with np.errstate(divide='ignore', invalid='ignore'):
        Fs = f['laplace'](s_complex, param)
        Fs = np.clip(Fs, 0, 10)
    im = ax2.contourf(S, W, Fs, levels=20, cmap='Blues')
    ax2.set_title(f'|F(s)| Magnitude: {f["F_label"]}', color='#e6edf3', fontsize=9)
    ax2.set_xlabel('Re(s) — σ', color='#8b949e')
    ax2.set_ylabel('Im(s) — jω', color='#8b949e')
    ax2.axhline(0, color='#8b949e', linewidth=0.5, alpha=0.5)
    ax2.axvline(0, color='#8b949e', linewidth=0.5, alpha=0.5)
    ax2.set_facecolor('#161b22')

    # Panel 3 — Pole-zero plot
    poles = f['poles'](param)
    zeros = f['zeros'](param)
    ax3.axhline(0, color='#30363d', linewidth=0.8)
    ax3.axvline(0, color='#30363d', linewidth=0.8)
    ax3.set_title('Pole-Zero Diagram', color='#e6edf3', fontsize=10)
    ax3.set_xlabel('Re(s)', color='#8b949e')
    ax3.set_ylabel('Im(s)', color='#8b949e')
    for p in poles:
        ax3.plot(p.real, p.imag, 'x', color='#f78166', markersize=12, markeredgewidth=2.5, label='Pole')
    for z in zeros:
        ax3.plot(z.real, z.imag, 'o', color='#3fb950', markersize=10, markerfacecolor='none',
                markeredgewidth=2, label='Zero')
    handles = []
    if poles:
        handles.append(plt.Line2D([0],[0], marker='x', color='#f78166', linewidth=0, markersize=10, markeredgewidth=2, label='Pole'))
    if zeros:
        handles.append(plt.Line2D([0],[0], marker='o', color='#3fb950', linewidth=0, markersize=10, markerfacecolor='none', markeredgewidth=2, label='Zero'))
    if handles:
        ax3.legend(handles=handles, fontsize=8, facecolor='#21262d', labelcolor='#e6edf3', edgecolor='#30363d')
    ax3.set_xlim(-4, 4)
    ax3.set_ylim(-max(6, param*1.5), max(6, param*1.5))
    ax3.grid(True, color='#21262d', linewidth=0.5)

    # Panel 4 — Step response
    try:
        resp = f['response'](t, param)
        resp_clipped = np.clip(resp, -5, 5)
        ax4.plot(t, resp_clipped, color=color, linewidth=2)
    except:
        ax4.text(0.5, 0.5, 'N/A', transform=ax4.transAxes, color='#8b949e', ha='center')
    ax4.set_title('System Step Response', color='#e6edf3', fontsize=10)
    ax4.set_xlabel('t', color='#8b949e')
    ax4.set_ylabel('y(t)', color='#8b949e')
    ax4.axhline(0, color='#30363d', linewidth=0.8)
    ax4.set_xlim(0, 10)

    param_name = 'ω' if name in ['Sine', 'Damped Sine'] else 'a'
    slider_ax.set_xlabel(f'{param_name} = {param:.1f}', color='#e6edf3', fontsize=9)
    fig.canvas.draw_idle()

# Slider
slider_ax = plt.axes([0.15, 0.10, 0.5, 0.03], facecolor='#21262d')
slider = Slider(slider_ax, 'Parameter', 0.1, 5.0, valinit=1.0, valstep=0.1, color='#58a6ff')
slider.label.set_color('#e6edf3')
slider.valtext.set_color('#e6edf3')
slider.on_changed(update_plots)

# Buttons
btn_defs = [
    ('Step',        '#58a6ff', 0.10),
    ('Ramp',        '#3fb950', 0.21),
    ('Sine',        '#f78166', 0.32),
    ('Exponential', '#f0883e', 0.43),
    ('Damped Sine', '#bc8cff', 0.57),
]

btn_objects = []
for label, color, xpos in btn_defs:
    bax = plt.axes([xpos, 0.03, 0.10, 0.04])
    btn = Button(bax, label, color='#21262d', hovercolor='#30363d')
    btn.label.set_color(color)
    btn.label.set_fontsize(8)
    btn_objects.append(btn)

def make_cb(name):
    def cb(event):
        current_func[0] = name
        update_plots(None)
    return cb

for btn, (label, _, _) in zip(btn_objects, btn_defs):
    btn.on_clicked(make_cb(label))

update_plots(None)
plt.show()
