
load Simulation_Result\PI_Result_FTP75.mat;
load Simulation_Result\RL_Result_FTP75.mat;

PI_Time = PI_Result.time;

Reference_Speed = PI_Result.signals(1).values(:,1);

PI_Actual_Speed = PI_Result.signals(1).values(:,2);
PI_Torque_Command = PI_Result.signals(2).values;
PI_Motor_Efficiency = PI_Result.signals(3).values;
PI_Electrical_Efficiency = PI_Result.signals(4).values;

RL_Time = RL_Result.time;

RL_Actual_Speed = RL_Result.signals(1).values(:,2);
RL_Torque_Command = RL_Result.signals(2).values(1,1,:);
RL_Motor_Efficiency = RL_Result.signals(3).values;
RL_Electrical_Efficiency = RL_Result.signals(4).values;


% Speed
subplot(4, 1, 1);
hold on
plot(PI_Time, Reference_Speed, 'Color', 'g');
plot(PI_Time, PI_Actual_Speed, 'Color', 'r');
plot(RL_Time, RL_Actual_Speed, 'Color', 'b');
title('Speed')
xlabel('time');
ylabel('Motor RPM');
legend('Reference Speed', 'PI Controller', 'RL Agent');

% Torque Command
subplot(4, 1, 2);
hold on
plot(PI_Time, PI_Torque_Command, 'Color', 'r');
plot(RL_Time, RL_Torque_Command(:,:), 'Color', 'b');
title('Torque Command')
xlabel('time');
ylabel('N*M');
legend('PI Controller', 'RL Agent');

% Motor Efficiency
subplot(4, 1, 3);
hold on
plot(PI_Time, PI_Motor_Efficiency, 'Color', 'r');
plot(RL_Time, RL_Motor_Efficiency, 'Color', 'b');
title('Motor Efficiency')
xlabel('time');
ylabel('Percent (%)');
ylim([-10, 120]);
legend('PI Controller', 'RL Agent');

% Electrical Efficiency
subplot(4, 1, 4);
hold on
plot(PI_Time, PI_Electrical_Efficiency, 'Color', 'r');
plot(RL_Time, RL_Electrical_Efficiency, 'Color', 'b');
title('Electrical Efficiency')
xlabel('time');
ylabel('kW*hr/100km');
legend('PI Controller', 'RL Agent');





