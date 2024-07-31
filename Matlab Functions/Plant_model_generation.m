
% Extract time, torque, and speed data
time = speed(1, :);
speed_values = speed(2, :);
torque_values = torque(2, :);

% Define start and end indices
start_index = 33;
end_index = 125;

% Extract data from the start_index to end_index
time = time(start_index:end_index);
speed_values = speed_values(start_index:end_index);
torque_values = torque_values(start_index:end_index);

% Create iddata object
data = iddata(speed_values', torque_values', 0.1); % 0.1 is the sample time

% Estimate ARX model
na = 1; % Order of the autoregressive part (previous speed values)
nb = 1; % Order of the exogenous input part (torque values)
nk = 0; % Input delay
model = arx(data, [na nb nk]);

% Predict the speed response for the same torque values
speed_estimated = predict(model, data);

% Plot original data and model response
figure;
plot(torque_values, speed_values, 'b', 'LineWidth', 1.5); % Original data in blue
hold on;
plot(torque_values, speed_estimated.OutputData, 'r--', 'LineWidth', 1.5); % Model response in red dashed line
xlabel('Torque');
ylabel('Speed');
title('Speed vs Torque');
legend('Original Data', 'Model Response');
grid on;
hold off;
tf_model = tf(model);