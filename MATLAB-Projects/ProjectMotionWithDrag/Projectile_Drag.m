%% Projectile Motion with Aerodynamic Drag
% Vlad Dragomir — Aerospace Engineering Portfolio
% Simulates projectile motion including drag, terminal velocity,
% and Reynolds number analysis for multiple objects

clc; clear; close all;

%% --- FLUID PROPERTIES (air at sea level, 20°C) ---
rho = 1.225;    % air density (kg/m³)
mu  = 1.81e-5;  % dynamic viscosity (Pa·s)
g   = 9.81;     % gravity (m/s²)

%% --- OBJECT DEFINITIONS ---
% Each object: [mass(kg), diameter(m), Cd, name]
objects = {
    0.145,  0.074,  0.47,  'Baseball';
    80,     0.50,   1.00,  'Skydiver';
    0.003,  0.05,   1.50,  'Feather';
};

colors = {'b', 'r', 'g'};

%% --- SIMULATION SETTINGS ---
dt    = 0.01;
t_max = 60;
v0    = 0;

%% --- ANALYTICAL TERMINAL VELOCITY ---
fprintf('=== TERMINAL VELOCITY ANALYSIS ===\n')
fprintf('%-12s %-15s %-15s %-15s\n', 'Object', 'Mass (kg)', 'Cd', 'v_terminal (m/s)')
fprintf('%s\n', repmat('-', 1, 60))

for i = 1:size(objects, 1)
    m  = objects{i,1};
    D  = objects{i,2};
    Cd = objects{i,3};
    A  = pi * (D/2)^2;
    v_term = sqrt(2*m*g / (rho*Cd*A));
    fprintf('%-12s %-15.3f %-15.2f %-15.2f\n', objects{i,4}, m, Cd, v_term)
end

%% --- NUMERICAL SIMULATION (Euler Method) ---
results = cell(size(objects,1), 1);

for i = 1:size(objects, 1)
    m  = objects{i,1};
    D  = objects{i,2};
    Cd = objects{i,3};
    A  = pi*(D/2)^2;

    t = 0:dt:t_max;
    v = zeros(size(t));
    a = zeros(size(t));
    y = zeros(size(t));
    Re = zeros(size(t));

    v(1) = v0;

    for j = 1:length(t)-1
        F_drag   = 0.5 * rho * Cd * A * v(j)^2;
        F_net    = m*g - F_drag;
        a(j)     = F_net / m;
        v(j+1)   = v(j) + a(j)*dt;
        y(j+1)   = y(j) + v(j)*dt;
        Re(j)    = rho * v(j) * D / mu;
    end
    Re(end) = rho * v(end) * D / mu;
    a(end)  = a(end-1);

    results{i} = struct('t', t, 'v', v, 'a', a, 'y', y, 'Re', Re);
end

%% --- FIGURE 1: Main Results ---
figure('Color', 'white', 'Position', [100 100 1200 800])

% Velocity vs Time
subplot(2,2,1)
hold on
for i = 1:size(objects,1)
    m  = objects{i,1};
    D  = objects{i,2};
    Cd = objects{i,3};
    A  = pi*(D/2)^2;
    v_term = sqrt(2*m*g / (rho*Cd*A));
    plot(results{i}.t, results{i}.v, colors{i}, 'LineWidth', 2)
    yline(v_term, '--', 'Color', colors{i}, 'LineWidth', 1, ...
          'Label', sprintf('v_t = %.1f m/s', v_term))
end
hold off
xlabel('Time (s)'); ylabel('Velocity (m/s)')
title('Velocity vs Time', 'FontWeight', 'bold')
legend(objects{:,4}, 'Location', 'southeast')
grid on

% Distance vs Time
subplot(2,2,2)
hold on
for i = 1:size(objects,1)
    plot(results{i}.t, results{i}.y, colors{i}, 'LineWidth', 2)
end
hold off
xlabel('Time (s)'); ylabel('Distance Fallen (m)')
title('Distance vs Time', 'FontWeight', 'bold')
legend(objects{:,4}, 'Location', 'northwest')
grid on

% Acceleration vs Time
subplot(2,2,3)
hold on
for i = 1:size(objects,1)
    plot(results{i}.t, results{i}.a, colors{i}, 'LineWidth', 2)
end
yline(0, 'k--', 'LineWidth', 1)
hold off
xlabel('Time (s)'); ylabel('Acceleration (m/s²)')
title('Acceleration vs Time', 'FontWeight', 'bold')
legend(objects{:,4}, 'Location', 'northeast')
grid on

% Drag Force vs Time
subplot(2,2,4)
hold on
for i = 1:size(objects,1)
    m  = objects{i,1};
    D  = objects{i,2};
    Cd = objects{i,3};
    A  = pi*(D/2)^2;
    F_drag = 0.5 * rho * Cd * A * results{i}.v.^2;
    plot(results{i}.t, F_drag, colors{i}, 'LineWidth', 2)
    yline(m*g, '--', 'Color', colors{i}, 'LineWidth', 1, ...
          'Label', sprintf('W = %.1f N', m*g))
end
hold off
xlabel('Time (s)'); ylabel('Drag Force (N)')
title('Drag Force vs Time', 'FontWeight', 'bold')
legend(objects{:,4}, 'Location', 'southeast')
grid on

sgtitle('Projectile Motion with Aerodynamic Drag', 'FontSize', 14, 'FontWeight', 'bold')

%% --- FIGURE 2: Reynolds Number (separate per object) ---
figure('Color', 'white', 'Position', [100 100 1200 400])

for i = 1:size(objects,1)
    subplot(1,3,i)
    plot(results{i}.t, results{i}.Re, colors{i}, 'LineWidth', 2)
    yline(2300, 'k--', 'LineWidth', 1.5, 'Label', 'Laminar/Trans')
    yline(4000, 'k-',  'LineWidth', 1.5, 'Label', 'Trans/Turbulent')
    xlabel('Time (s)')
    ylabel('Reynolds Number')
    title(objects{i,4}, 'FontWeight', 'bold')
    grid on

    Re_term = results{i}.Re(end);
    if Re_term < 2300
        regime = 'Laminar';
    elseif Re_term < 4000
        regime = 'Transitional';
    else
        regime = 'Turbulent';
    end
    text(0.55, 0.25, sprintf('Re_{term} = %.0f\n%s', Re_term, regime), ...
         'Units', 'normalized', 'FontSize', 9, ...
         'BackgroundColor', 'white', 'EdgeColor', 'black')
end

sgtitle('Reynolds Number vs Time — By Object', 'FontSize', 13, 'FontWeight', 'bold')

%% --- PRINT REYNOLDS REGIME ---
fprintf('\n=== REYNOLDS NUMBER AT TERMINAL VELOCITY ===\n')
fprintf('%-12s %-20s %-15s\n', 'Object', 'Re (terminal)', 'Flow Regime')
fprintf('%s\n', repmat('-', 1, 50))
for i = 1:size(objects,1)
    Re_term = results{i}.Re(end);
    if Re_term < 2300
        regime = 'Laminar';
    elseif Re_term < 4000
        regime = 'Transitional';
    else
        regime = 'Turbulent';
    end
    fprintf('%-12s %-20.0f %-15s\n', objects{i,4}, Re_term, regime)
end