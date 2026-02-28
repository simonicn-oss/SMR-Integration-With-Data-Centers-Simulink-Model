% 1. Read the new CSV file
T = readtable('16hourrun.csv');
% 2. Pre-process the data to match the expected format
% Convert time from milliseconds to seconds
T.time_s = T.time_ms / 1000;
% Normalize the raw power (Watts) to a 0-1 range (power_norm)
% This ensures the profile scales correctly between Pmin and Pmax
raw_power = T.power_draw_w;
min_p = min(raw_power);
max_p = max(raw_power);
T.power_norm = (raw_power - min_p) / (max_p - min_p);
% 3. System Parameters
Pmin_MW = 0;
Pmax_MW = 500;
% 4. Calculate Load Profile
% This maps the normalized GPU power shape to your 1MW - 50MW range
Pload_MW = Pmin_MW + (Pmax_MW - Pmin_MW) .* T.power_norm;
% 5. Create Simulink Timeseries
load_ts = timeseries(Pload_MW, T.time_s);
load_ts.Name = "Pload_MW";
% 6. Other Constants
D = 1;
H = 5;
f0 = 60;
sbase = 300;


%Load Data
% Run simulation and capture outputs
simOut = sim('UpdatedModel16.slx');

% Extract signals
f_Hz       = simOut.Frequency_Hz;
SOC_batt   = simOut.Battery_State_of_Charge;
SOC_sc     = simOut.Supercapacitor_State_of_Charge;
P_batt_MW  = simOut.Battery_Power;
P_sc_MW    = simOut.Supercapcitor_Power;
P_hess_MW  = simOut.Hybrid_Energy_Storage_System_Power;
P_dump_MW  = simOut.Dump_Load;
P_sc_cmd   = simOut.Supercapacitor_Demand;
P_batt_cmd = simOut.Battery_Demand;
P_load     = simOut.Facility_Load;

%% NuScale SMR + HESS Simulation Plots

%% 1 - GPU Load
figure('Color', 'white');
plot(P_load.Time, P_load.Data, 'Color', [0.3 0.3 0.3], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('GPU Datacenter Load');
grid on; box on;

%% 2 - System Frequency
figure('Color', 'white');
t = f_Hz.Time; f = f_Hz.Data;
patch([t(1) t(end) t(end) t(1)], [59.5 59.5 60.5 60.5], ...
    [0.6 1 0.6], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
hold on;
plot(t, f, 'Color', [0.8 0.1 0.1], 'LineWidth', 1);
yline(60.5, 'g--', '+0.5 Hz', 'LineWidth', 1.2);
yline(59.5, 'g--', '-0.5 Hz', 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title('System Frequency');
ylim([59 61]); grid on; box on;

%% 3 - HESS Total Output
figure('Color', 'white');
plot(P_hess_MW.Time, P_hess_MW.Data, 'Color', [0.5 0.1 0.7], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('Total HESS Output');
grid on; box on;

%% 4 - Battery Command
figure('Color', 'white');
plot(P_batt_cmd.Time, P_batt_cmd.Data, 'Color', [0.1 0.4 0.7], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('Battery Command');
grid on; box on;

%% 5 - Battery Power
figure('Color', 'white');
plot(P_batt_MW.Time, P_batt_MW.Data, 'Color', [0.1 0.4 0.7], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('Battery Power Output');
grid on; box on;

%% 6 - Battery SOC
figure('Color', 'white');
plot(SOC_batt.Time, SOC_batt.Data, 'Color', [0.1 0.4 0.7], 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('SOC (0-1)');
title('Battery State of Charge');
ylim([0 1]); grid on; box on;

%% 7 - Supercap Command
figure('Color', 'white');
plot(P_sc_cmd.Time, P_sc_cmd.Data, 'Color', [0.0 0.6 0.4], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('Supercapacitor Command');
grid on; box on;

%% 8 - Supercap Power
figure('Color', 'white');
plot(P_sc_MW.Time, P_sc_MW.Data, 'Color', [0.0 0.6 0.4], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('Supercapacitor Power Output');
grid on; box on;

%% 9 - Supercap SOC
figure('Color', 'white');
plot(SOC_sc.Time, SOC_sc.Data, 'Color', [0.0 0.6 0.4], 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('SOC (0-1)');
title('Supercapacitor State of Charge');
ylim([0 1]); grid on; box on;

%% 10 - Dump Load
figure('Color', 'white');
plot(P_dump_MW.Time, P_dump_MW.Data, 'Color', [0.9 0.5 0.0], 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Power (MW)');
title('Dump Load');
grid on; box on;

%% Summary
freq_vals = f_Hz.Data;
fprintf('\n========================================\n');
fprintf('        SIMULATION SUMMARY\n');
fprintf('========================================\n');
fprintf('Frequency Min:       %.4f Hz\n', min(freq_vals));
fprintf('Frequency Max:       %.4f Hz\n', max(freq_vals));
fprintf('Max Deviation:       %.4f Hz\n', max(abs(freq_vals - 60)));
if max(abs(freq_vals - 60)) <= 0.5
    fprintf('Within +-0.5 Hz:     YES\n');
else
    fprintf('Within +-0.5 Hz:     NO\n');
end
fprintf('Battery SOC Final:   %.3f\n', SOC_batt.Data(end));
fprintf('Supercap SOC Final:  %.3f\n', SOC_sc.Data(end));
fprintf('========================================\n');