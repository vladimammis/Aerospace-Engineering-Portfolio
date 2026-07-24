%% Beam Deflection Calculator
% Vlad Dragomir — Aerospace Engineering Portfolio
% Calculates and plots shear, moment, and deflection for 3 beam cases

clc; clear; close all;
e
%% --- INPUTS ---
L = 5;          % Beam length (m)
P = 10000;      % Point load (N)
w = 2000;       % Distributed load (N/m)
E = 200e9;      % Young's modulus — steel (Pa)
b = 0.05;       % Cross-section width (m)
h = 0.1;        % Cross-section height (m)
I = (b * h^3) / 12;  % Second moment of area (m^4)

fprintf('=== BEAM PROPERTIES ===\n')
fprintf('Length: %.1f m\n', L)
fprintf('E: %.0f GPa\n', E/1e9)
fprintf('I: %.4e m^4\n', I)
fprintf('EI: %.4e N·m²\n', E*I)

%% --- CASE 1: Simply Supported + Point Load at Center ---
x1 = linspace(0, L, 1000);

% Deflection (valid for x <= L/2, mirror for x > L/2)
x_left = x1(x1 <= L/2);
x_right = x1(x1 > L/2);

d_left  = (P .* x_left  .* (3*L^2 - 4*x_left.^2))  / (48*E*I);
d_right = (P .* (L - x_right) .* (3*L^2 - 4*(L-x_right).^2)) / (48*E*I);
deflection1 = [d_left, d_right] * 1000; % convert to mm

% Shear force
V1 = zeros(size(x1));
V1(x1 < L/2)  =  P/2;
V1(x1 >= L/2) = -P/2;

% Bending moment
M1 = zeros(size(x1));
M1(x1 <= L/2) = (P/2) .* x1(x1 <= L/2);
M1(x1 > L/2)  = (P/2) .* (L - x1(x1 > L/2));

max_d1 = P*L^3 / (48*E*I) * 1000;
fprintf('\n=== CASE 1: Simply Supported + Point Load ===\n')
fprintf('Max deflection: %.4f mm at center\n', max_d1)
fprintf('Max moment: %.1f N·m at center\n', max(M1))

%% --- CASE 2: Simply Supported + Uniform Distributed Load ---
x2 = linspace(0, L, 1000);
deflection2 = (w .* x2 .* (L^3 - 2*L.*x2.^2 + x2.^3)) / (24*E*I) * 1000;

V2 = w*L/2 - w.*x2;
M2 = (w*L/2).*x2 - (w.*x2.^2)/2;

max_d2 = 5*w*L^4 / (384*E*I) * 1000;
fprintf('\n=== CASE 2: Simply Supported + Distributed Load ===\n')
fprintf('Max deflection: %.4f mm at center\n', max_d2)
fprintf('Max moment: %.1f N·m at center\n', max(M2))

%% --- CASE 3: Cantilever + Point Load at Free End ---
x3 = linspace(0, L, 1000);
deflection3 = (P .* x3.^2 .* (3*L - x3)) / (6*E*I) * 1000;

V3 = -P * ones(size(x3));
M3 = -P .* (L - x3);

max_d3 = P*L^3 / (3*E*I) * 1000;
fprintf('\n=== CASE 3: Cantilever + Point Load ===\n')
fprintf('Max deflection: %.4f mm at free end\n', max_d3)
fprintf('Max moment: %.1f N·m at wall\n', abs(min(M3)))

%% --- PLOTS ---
figure('Color', 'white', 'Position', [100 100 1200 800])

% Case 1
subplot(3,3,1)
plot(x1, V1/1000, 'b', 'LineWidth', 2)
title('Case 1 — Shear Force', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('V (kN)')
grid on; yline(0, 'k--')

subplot(3,3,2)
plot(x1, M1/1000, 'r', 'LineWidth', 2)
title('Case 1 — Bending Moment', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('M (kN·m)')
grid on; yline(0, 'k--')

subplot(3,3,3)
plot(x1, -deflection1, 'g', 'LineWidth', 2)
title('Case 1 — Deflection', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('δ (mm)')
grid on; yline(0, 'k--')

% Case 2
subplot(3,3,4)
plot(x2, V2/1000, 'b', 'LineWidth', 2)
title('Case 2 — Shear Force', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('V (kN)')
grid on; yline(0, 'k--')

subplot(3,3,5)
plot(x2, M2/1000, 'r', 'LineWidth', 2)
title('Case 2 — Bending Moment', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('M (kN·m)')
grid on; yline(0, 'k--')

subplot(3,3,6)
plot(x2, -deflection2, 'g', 'LineWidth', 2)
title('Case 2 — Deflection', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('δ (mm)')
grid on; yline(0, 'k--')

% Case 3
subplot(3,3,7)
plot(x3, V3/1000, 'b', 'LineWidth', 2)
title('Case 3 — Shear Force', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('V (kN)')
grid on; yline(0, 'k--')

subplot(3,3,8)
plot(x3, M3/1000, 'r', 'LineWidth', 2)
title('Case 3 — Bending Moment', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('M (kN·m)')
grid on; yline(0, 'k--')

subplot(3,3,9)
plot(x3, -deflection3, 'g', 'LineWidth', 2)
title('Case 3 — Deflection', 'FontWeight', 'bold')
xlabel('x (m)'); ylabel('δ (mm)')
grid on; yline(0, 'k--')

sgtitle('Beam Deflection Analysis — Three Load Cases', 'FontSize', 14, 'FontWeight', 'bold')