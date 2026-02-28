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