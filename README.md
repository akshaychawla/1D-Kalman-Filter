# 1D-Kalman-Filter

- [ + ] Add the basics of Kalman Filter
- [   ] Simplify it!

## 1. Introduction

This is a simple 1 dimensional Kalman Filter. The Aim of this project was to understand the basics of the Kalman Filter so I could move on to the Extended Kalman Filter. 
In the case of a well-defined model, one-dimensional linear system with measurements errors drawn from a zero-mean gaussian distribution the Kalman Filter has been shown to be the best estimator. A detailed explanation of the same is given in the rest of the readme. 

## 2. Problem Statement
To understand the working of the Kalman Filter, an example of a linear system was taken; A vehicle is moving on a stright road with a constant velocity (2m/s). It also has a GPS on board that gives it noisy readings. We are given an estimate of its initial position (we assume one, if it isnt given) and at EVERY time step (epoch) we try to obtain the best estimate of its position by fusing together GPS readings and costant velocity model. 

![screenshot from 2015-08-14 13 59 53](https://cloud.githubusercontent.com/assets/8658591/9272991/78b33700-42a5-11e5-8885-5daa540431f7.png)
Fig1. The truck moves on a straight path, measuring its location with respect to a pole on the left side. It moves with a constant velocity.

## 3. System Model
For a Kalman filter based state estimator, the system must conform to a certain model. So if your system model conforms to model mentioned herein, then we can use a Kalman Filter to estimate the state of the system. 

3.1 Motion Model

      x_new = A*x_old + B*u + w
      x_new : current state
      x_old : previous state
      A     : state transition matrix
      B     : control input matrix
      w     : process noise (from a 0 mean normal distribution with covariance Q)
      
3.2 Sensor Model

      z = H*x + v
      z     : sensor measurement
      H     : sensor transformation matrix
      x     : current state 
      v     : measurement noise (from a 0 mean normal distribution with covariance R)

3.3 Understanding the models
      
- The state vector 'x' contains the state of the system i.e the parameters that uniquely describe the current position of the system. In this case, the state vector is a single dimentional vector containing the location of the vehicle. It can also be a N dimensional vector containg position in different axes, velocity in different axes, temperature, state of sensors etc.
- A is the state transition matrix, it applies the effect of each parameter of the previous state on the next state. 
- B is the control input matrix that applies the effect of the control signal given to the system onto the next state. So in this system, the current position is based on the previous position added to the velocity*time. Mathematically, 

            x_new = 1*x_old + timedifference*velocity 

- In the equation given above, A = 1 and B = time difference. 
- No system is perfect, given the previous position and the velocty, the new location will not correspond to the equation given above. There will be noise in the system, this noise is modelled as a Gaussian distribution having mean = 0 and a certain standard deviation given by covariance matrix Q (explained later). In simple words, it is the difference between the the ideal new location and the actual new location. 

            x_new - (A*x_old + B*u) = noise = w

- The 'z' vector contains the sensor measurements given by the sensors. The Kalman filter is based on a Hidden Markov Model, meaning that the current 'z' depends ONLY on current state, and not any of the previous states as is evident in the sensor model equation. 
- The 'H' matrix maps the state vector parameters 'x' to the sensor measurements. In simple words, it tells us the sensor measurement that we _should_ get given the current state 'x'. 
- Similiar to 'w', 'v' is also a parameter representing the noise in sensor measurements. It is also taken from a 0 mean Gaussian distribution whose variance is taken from covariance matrix R.  

## 4. Kalman Filter Equations 

4.1 Initializaton

We assume that we have a good knowledge of the vehicle's initial position. We can represent this by a gaussian whose mean is the inital known position and a covariance matrix having small values. This is shown in the image below.

![screenshot from 2015-08-14 13 59 58](https://cloud.githubusercontent.com/assets/8658591/9273000/844816b2-42a5-11e5-8593-88defd73e9db.png)
Fig2. The state is represented by a gaussian as shown. 

4.2 Prediction Step

The truck moves forward with a constant velocity 'u'. We can now have a prediction of the next state from the prediction equations. This prediction is represented by a gaussian having a mean and a variance. As we can see this variance is more than the previous variance, thus showing that we are more uncertain about its position. 

![screenshot from 2015-08-14 14 00 04](https://cloud.githubusercontent.com/assets/8658591/9273007/9d6f2e82-42a5-11e5-972c-0efd90e7e8cf.png)
Fig3. When the vehicle moves, it becomes more uncertain about its position due to the control being noisy. Hence, the gaussian expands. 

      x = F*x + B*u
      P = F*P*F' + Q
      P     : state covariance matrix
      Q     : process noise covariance matrix (explained previously)
      
- Apart from P and Q the other variables have been explained previously. 
- The 'Q' is the process noise covariance matrix. The diagonal elements contain the variance(std_dev*std_dev) of each respective variable in the state vector 'x'. So if the state vector has 2 columns containin the x and y co-ordinates, then Q is a 2x2 matrix whose diagonals contain the variance of each of those variables. The non-diagonal variables are usually set to 0 except in the case of special circumstances. The variances are calculated from the noise variable 'w', the variance of these values is noted while observing the system. 
- 'P' is the state covariance matrix, like 'Q', it models uncertainity in the system. It models uncertainity of the state vector 'x'. Each of the diagonal elements containg the variance (uncertainity in position) of each of those respective state variables in the state vector. For initialization for this matrix, if the state variable's initial location is known to a high degree, the corresponding diagonal element in P is a small. Vice-versa in case the state variable's initial location is not known well. 
- In the prediction step, if we look at the second equation we see that the value of P is increasing (due to the addition), this goes to show that in the prediction step, when we do not have any measurement and we only have control command 'u', the next state will be known with lesser certainity. The opposite happens in the Correction step. 

4.3 Correction Step 

In this step, the vehicle makes a measurement of its position using its onboard location sensor i.e it finds its distance from the pole using a sensor. This measurement is noisy and not exact. This measurement itself is represented by a gaussina having a mean and covariance. The value of the covariance depends on the accuracy of the sensor: If the sensor is more accurate the covariance value will be small, else it will be large. 

![screenshot from 2015-08-14 14 00 11](https://cloud.githubusercontent.com/assets/8658591/9273027/bd99629a-42a5-11e5-8bc4-8147d6ceffff.png)
Fig4. The measurement is represented by a blue gaussian having a covariance smaller than the predicted state.    
      
      x = x_old + K*( z = H*x_old )
      P = P_old - K*H*P_old
      K = P*H' * (H*P*H' + R)^-1
      K     : Kalman Gain
      R     : Measurement noise covariance matrix

- 'K' is called the Kalman Gain. It is calculated from state covariance matrix and the measurement covariance matrix. If the measurement noise is more then the value of K will be less, if the measurement noise is more then its value will be less. 
- In the first equation for 'x', we are approximately taking a weighted average of the predicted state vector and the state vector generated from the measurement. This weighting is decided by the Kalman gain. 
- In the second equation for 'P', we see that the value of P is decreasing (subtraction), this is because we believe that the the sensor is more accurate and our uncertainity about the vehicle's position decreases. 
- If we look at it from an analytical perspective, we have two gaussians. They represent state vector and measured state. If we multiply these 2 gaussians we get another gaussian which is actually the best estimate of the position of the vehicle. 

![7](https://cloud.githubusercontent.com/assets/8658591/9272985/61a8c016-42a5-11e5-80d9-aca6b31f0de0.png)
Fig5. We multiply the two gaussians to have the best estimate (green) of the vehicle's position. 

## 5. Output

![output](https://cloud.githubusercontent.com/assets/8658591/9150817/5aba58dc-3e09-11e5-8afc-53cb8093559a.jpg)

      
