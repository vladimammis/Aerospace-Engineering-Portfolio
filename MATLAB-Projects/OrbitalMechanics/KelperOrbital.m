%% Orbital Mechanics Simulator — Kepler's Laws
% Vlad Dragomir — Aerospace Engineering Portfolio
% Simulates elliptical orbits using Kepler's laws and vis-viva equation
% Analyzes ISS, GPS, and Geostationary satellites

clc; clear; close all;

%% --- CONSTANTS ---
G  = 6.674e-11;       % Gravitational constant (m³/kg/s²)
M  = 5.972e24;        % Earth mass (kg)
GM = G * M;           % Standard gravitational parameter (m³/s²)
R_earth = 6.371e6;    % Earth radius (m)

%% --- SATELLITE DEFINITIONS ---
% [altitude_perigee(km), altitude_apogee(km), name, color]
satellites = {
    408,    408,    'ISS (LEO)',            'b';
    20180,  20180,  'GPS (MEO)',            'r';
    35786,  35786,  'Geostationary (GEO)',  'g';
};

fprintf('=== ORBITAL PARAMETERS ===\n')
fprintf('%-22s %-12s %-12s %-12s %-12s %-12s\n', ...
    'Satellite', 'a (km)', 'e', 'T (hrs)', 'v_p (km/s)', 'v_a (km/s)')
fprintf('%s\n', repmat('-', 1, 82))

%% --- COMPUTE ORBITAL PARAMETERS ---
orb = struct();
for i = 1:size(satellites,1)
    h_p = satellites{i,1} * 1e3;   % perigee altitude (m)
    h_a = satellites{i,2} * 1e3;   % apogee altitude (m)

    r_p = R_earth + h_p;            % perigee radius (m)
    r_a = R_earth + h_a;            % apogee radius (m)

    a   = (r_p + r_a) / 2;         % semi-major axis (m)
    e   = (r_a - r_p) / (r_a + r_p); % eccentricity
    b   = a * sqrt(1 - e^2);       % semi-minor axis (m)
    T   = 2*pi * sqrt(a^3 / GM);   % period (s)

    v_p = sqrt(GM * (2/r_p - 1/a)); % perigee velocity (m/s)
    v_a = sqrt(GM * (2/r_a - 1/a)); % apogee velocity (m/s)
    E   = -GM / (2*a);              % specific orbital energy (J/kg)

    orb(i).a   = a;
    orb(i).b   = b;
    orb(i).e   = e;
    orb(i).r_p = r_p;
    orb(i).r_a = r_a;
    orb(i).T   = T;
    orb(i).v_p = v_p;
    orb(i).v_a = v_a;
    orb(i).E   = E;
    orb(i).name  = satellites{i,3};
    orb(i).color = satellites{i,4};

    fprintf('%-22s %-12.0f %-12.4f %-12.2f %-12.3f %-12.3f\n', ...
        satellites{i,3}, a/1e3, e, T/3600, v_p/1e3, v_a/1e3)
end

%% --- FIGURE 1: Orbital Paths ---
figure('Color', 'white', 'Position', [50 50 900 800])
hold on
axis equal

% Draw Earth
theta_earth = linspace(0, 2*pi, 500);
x_earth = R_earth * cos(theta_earth) / 1e6;
y_earth = R_earth * sin(theta_earth) / 1e6;
fill(x_earth, y_earth, [0.2 0.5 0.8], 'EdgeColor', 'k', 'LineWidth', 1.5)
text(0, 0, 'Earth', 'HorizontalAlignment', 'center', ...
    'Color', 'white', 'FontWeight', 'bold', 'FontSize', 10)

% Draw each orbit
nu = linspace(0, 2*pi, 1000); % true anomaly
for i = 1:length(orb)
    a = orb(i).a;
    e = orb(i).e;
    b = orb(i).b;

    % Parametric ellipse (focus at origin)
    c = a * e; % focal distance
    x_orbit = (a * cos(nu) - c) / 1e6;
    y_orbit = b * sin(nu) / 1e6;

    plot(x_orbit, y_orbit, orb(i).color, 'LineWidth', 2, ...
         'DisplayName', orb(i).name)

    % Mark perigee and apogee
    plot(-c/1e6 - a/1e6, 0, 'o', 'Color', orb(i).color, ...
         'MarkerSize', 8, 'MarkerFaceColor', orb(i).color)
    plot(-c/1e6 + a/1e6, 0, 's', 'Color', orb(i).color, ...
         'MarkerSize', 8, 'MarkerFaceColor', orb(i).color)
end

xlabel('x (×10⁶ m)'); ylabel('y (×10⁶ m)')
title('Orbital Paths — ISS, GPS, GEO', 'FontWeight', 'bold', 'FontSize', 13)
legend('Earth', satellites{:,3}, 'Location', 'northwest')
grid on
hold off

%% --- FIGURE 2: Velocity vs True Anomaly ---
figure('Color', 'white', 'Position', [100 100 1200 400])

for i = 1:length(orb)
    subplot(1,3,i)
    a = orb(i).a;
    e = orb(i).e;

    nu_deg = linspace(0, 360, 1000);
    nu_rad = deg2rad(nu_deg);

    % Radius at each true anomaly
    r = a*(1-e^2) ./ (1 + e*cos(nu_rad));

    % Vis-viva velocity at each point
    v = sqrt(GM * (2./r - 1/a)) / 1e3; % km/s

    plot(nu_deg, v, orb(i).color, 'LineWidth', 2)
    xlabel('True Anomaly (degrees)')
    ylabel('Velocity (km/s)')
    title(orb(i).name, 'FontWeight', 'bold')
    grid on
    xticks(0:90:360)

    % Mark perigee and apogee
    xline(0,   '--k', 'Perigee', 'LineWidth', 1)
    xline(180, '--k', 'Apogee',  'LineWidth', 1)

    text(0.05, 0.15, sprintf('v_p = %.2f km/s\nv_a = %.2f km/s\nT = %.1f hrs', ...
        orb(i).v_p/1e3, orb(i).v_a/1e3, orb(i).T/3600), ...
        'Units', 'normalized', 'FontSize', 8, ...
        'BackgroundColor', 'white', 'EdgeColor', 'black')
end
sgtitle('Orbital Velocity vs True Anomaly', 'FontSize', 13, 'FontWeight', 'bold')

%% --- FIGURE 3: Comparative Bar Charts ---
figure('Color', 'white', 'Position', [100 100 1000 400])
names = {orb.name};

subplot(1,3,1)
periods = [orb.T] / 3600;
bar(periods, 'FaceColor', [0.2 0.5 0.8])
set(gca, 'XTickLabel', names, 'XTick', 1:length(orb))
ylabel('Period (hours)')
title('Orbital Period', 'FontWeight', 'bold')
grid on

subplot(1,3,2)
vp = [orb.v_p] / 1e3;
bar(vp, 'FaceColor', [0.8 0.3 0.2])
set(gca, 'XTickLabel', names, 'XTick', 1:length(orb))
ylabel('Velocity (km/s)')
title('Perigee Velocity', 'FontWeight', 'bold')
grid on

subplot(1,3,3)
altitudes = ([orb.r_p] - R_earth) / 1e3;
bar(altitudes, 'FaceColor', [0.2 0.7 0.3])
set(gca, 'XTickLabel', names, 'XTick', 1:length(orb))
ylabel('Altitude (km)')
title('Orbital Altitude', 'FontWeight', 'bold')
grid on

sgtitle('Satellite Comparison', 'FontSize', 13, 'FontWeight', 'bold')

%% --- PRINT ORBITAL ENERGY ---
fprintf('\n=== SPECIFIC ORBITAL ENERGY ===\n')
for i = 1:length(orb)
    fprintf('%-22s %.4e J/kg\n', orb(i).name, orb(i).E)
end
fprintf('\nNote: More negative energy = more tightly bound orbit\n')