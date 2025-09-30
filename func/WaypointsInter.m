function [ref, t_inter] = WaypointsInter(DrivingScenariofunc, SamplingTime)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sampling Time should be the as used in the Driving Scenario (Check it by clicking onto the setting in the driving scenario app)
% Inputs

% DrivingScenariofunc : An Imported function from the Driving Scenario app.
% The function could be imported after creating the requiured trajectory
% then the format should be modeified as below:
% [scenario, egoVehicle, waypoints,speed] = createDrivingScenarioElliptical()
% add 2 more output waypoints and the speed to the imported function
% SamplingTime : Sampling Time (in sec) should be the as used in the Driving
% Scenario (Check it by clicking onto the setting in the driving scenario app) 

% Outputs

% ref: 3 dimension array. contains interpolated [Global X coordinates, Global Y coordinates, Yaw angle]
% t_inter: interpolated time vector.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,~,waypoints,speed] = DrivingScenariofunc();
speed = (speed * 1000)/3600;

% Find the time at each of this waypoints  

x_dis = waypoints(:,1);
y_dis = waypoints(:,2);
yaw_angle = waypoints(:,3);

t = zeros(length(x_dis)-1,1);
dt = zeros(length(x_dis)-1,1);

% Distance between each of the waypoints
for i = 1:length(x_dis) - 1
    dis = EuclidianDis(x_dis,y_dis,i);

    % Average speed between waypoints
    v_avg = (speed(i+1) + speed(i)) / 2;

    % Time difference between each of this waypoints
    if i == 1
        dt(i) = 0.0;
        t(i) = 0.0;
    else 
        dt(i) = dis / v_avg;
        t(i) = dt(i) +sum(dt(1:i-1,1));
    end  
end

% Resampling and Interplotating data according the sampling time at equi
% distance

Ts = SamplingTime;
t_inter = t(1):Ts:t(end);
t_inter = t_inter';
x_dis_inter = interp1(t,x_dis(1:end-1),t_inter,'pchip');
y_dis_inter = interp1(t,y_dis(1:end-1),t_inter,'pchip');
yaw_angle_inter = interp1(t,yaw_angle(1:end-1),t_inter,'pchip');

ref = [x_dis_inter y_dis_inter yaw_angle_inter];

% Is the interplotation and the simulation make sense? 

dis_test1 = EuclidianDis(x_dis_inter,y_dis_inter,1);
vehicle_speed1 =  dis_test1 / (t_inter(2,1) - t_inter(1,1));
vehicle_speed1 =  (vehicle_speed1 * 3600) / 1000;       % Speed in Km/hr
dis_test2 = EuclidianDis(x_dis_inter,y_dis_inter,2);
vehicle_speed2 =  dis_test2 / (t_inter(3,1) - t_inter(2,1));
vehicle_speed2 =  (vehicle_speed2 * 3600) / 1000;

fprintf("Vehicle Speed Between first and the secound waypoint is %.2d Km/hr\n", vehicle_speed1)
fprintf("Vehicle Speed Between secound and the thrid waypoint is %.2d Km/hr\n", vehicle_speed2)

if ~isequal(size(x_dis_inter), size(y_dis_inter), size(t_inter))
    error('Size mismatch. Check sampling time for imported function.\n');
end

% CALL THIS FUNCTION AS BELOW (As the function call includes another function in the argument)
% [ref, t_inter] = WaypointsInter(@DrivingScenariofunc, SamplingTime)