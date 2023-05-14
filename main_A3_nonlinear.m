% Assessment Task 5 
% Assignment 3: Nonlinear Control
% 
%
% 48580 Control Studio B
% University of Technology Sydney, Australia
% Autumn 2023
%
% A/Prof Ricardo P. Aguilera
%
% Enjoy it!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear;

%% Simulation Settings
Tf = 10;            %Simulation length
Ts = 1/1000;         %Controller sampling time
controller = 1;     %Type of Controller
ro=1.3;             %Initial Radius
N=12;               %Number of starting points

%% Linearized System
A=[0 , 6;
   -2, 0];
B=diag([1 2]);

%% Design your SFC
poles_cont = [-2,-2];

K1 = place(A,B,poles_cont);

%% Design an SFC with guaranteed region of attraction ||x||<2
alpha=1;
K2=[alpha 0;
      2         alpha/2];

%% Design nonlinear controller
 K3=K1;
% K3=K2;
% K3: LQR


%% Design SMC
% Desing surface Cs and switching gain gamma
Cs=eye(2);
gamma=1;


%% Plot Region of Attraction
fig=figure(1);
                     %[xpos, ypos, xsize, ysize]
set(gcf, 'Position',  [0,     100,   500,   500]) %Set plot position and size 
clf(fig)
grid on
axis(3*[-1 1 -1 1])
pbaspect([1 1 1])       % To keep the both axis lengths with the same ratio
hold on


%% Run Simulation for 12 different initial conditions
disp('Simulating and Plotting...')
theta = 0;
for k =1:N
    if (k>1)
        fprintf(repmat('\b',1,numel(msg)+1));
        msg=['k=',num2str(k)];
    else
        msg=['k=',num2str(k)];
    end
    disp(msg)

    
    % Initial Condition
    % Change this to obtain N different starting points
    x1_o=ro * cos(k * pi/6);
    x2_o=ro * sin(k * pi/6);
    

    %% Simulation Linear Model
    sim('sim_A3_nonlinear.slx')
 
    %states
    x1=x(:,1);
    x2=x(:,2);
    %%inputs
    u1=u(:,1);
    u2=u(:,2);
    
    % Modify this plot as per your needs
    scatter(x1_o,x2_o,100,'ok','filled')    %Plot a circle for the initial condition
    plot(x1,x2) %Plot the resulting closed-loop behaviour for each initial condition
    pause(1);   %give time to get data
    drawnow;    
    
end
th = linspace(0,2*pi,50);

[x_circle, y_circle] = pol2cart(th, ro);
plot(x_circle, y_circle);
hold off 
%% Plots: variable vs time
figure(2)
plot(time,u1)
disp('Done!!!')