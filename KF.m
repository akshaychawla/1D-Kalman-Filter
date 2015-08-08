%Simulating a Kalman Filter 

%Define System
X = 0;
dt = 1;
u = 2; %speed/control = 2m/s
n = randn();
v = randn();
%Kalman Filter variables

x = 50;      %state vector
A = 1;    %state transition matrix
B = 1;    %control input matrix 
P = 100;    %std_dev*std_dev = 10*10 
Q = 100;      %process noise covariance matrix 
R = 9;       %measurement noise covariance matrix
H = 1;

% Storing calculated values in these vectors for plotting
XX = zeros(1,100);
tt = zeros(1,100);
xx_predicted = zeros(1,100);
xx = zeros(1,100);
PP = zeros(1,100);
yy = zeros(1,100);
for t=1:1:100
   %simulating the System
    n = sqrt(Q) * randn(); %random noise
    X = X + u*dt + n; % New Current State
    v = sqrt(R) * randn() ;
    y = H*X + v; % Measurements 
    
   %Prediction Step
    x_predicted = A*x + B*u;         %predicting the new state (mean)
    P = A * P * A' + Q;    %predicting the new uncertainity (covariance)
    
   %Correction Step
    e = H*x_predicted;        %expectation: predicted measurement from the o/p
    E = H*P*H';     %Covariance of ^ expectation
    z = y - e;      %innovation: diff between the expectation and real sensor measurement
    Z = R + E;      %Covariance of ^ - sum of uncertainities of expectation and real measurement
    K = P*H' * Z^-1;
    
    x = x_predicted + K*z; %final corrected state
    P = P - K * H* P;       %uncertainity in corrected state
    
   %Saving the outputs
    xx_predicted(t) = x_predicted;
    xx(t) = x;
    PP(t) = P;
    XX(t) = X;
    tt(t) = t;
    yy(t) = y;
end

plot(tt,XX,tt,xx,tt,xx_predicted,tt,yy)
title(' 1D Kalman Filter')
legend('Ground Truth','Corrected State','Predicted State','Sensor Measurements')
xlabel('Time')
ylabel('Position')

