# 1D-Kalman-Filter

- [ + ] Add the basics of Kalman Filter
- [   ] Simplify it!

## 1. Introduction

This is a simple 1 dimensional Kalman Filter. The Aim of this project was to understand the basics of the Kalman Filter so I could move on to the Extended Kalman Filter. 
In the case of a well-defined model, one-dimensional linear system with measurements errors drawn from a zero-mean gaussian distribution the Kalman Filter has been shown to be the best estimator. A detailed explanation of the same is given in the rest of the readme. 

## 2. Problem Statement
To understand the working of the Kalman Filter, an example of a linear system was taken; A vehicle is moving on a stright road with a constant velocity (2m/s). It also has a GPS on board that gives it noisy readings. We are given an estimate of its initial position (we assume one, if it isnt given) and at EVERY time step (epoch) we try to obtain the best estimate of its position by fusing together GPS readings and costant velocity model. 

## 3. System Model
For a Kalman filter based state estimator, the system must conform to a certain model. So if your system model conforms to model mentiones herein, then we can use a Kalman Filter to estimate the state of the system. 

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

## 4. Kalman Filter Equations 
      
4.1 Prediction Step
      
4.2 Correction Step 

## 5. Output

![output](https://cloud.githubusercontent.com/assets/8658591/9150817/5aba58dc-3e09-11e5-8afc-53cb8093559a.jpg)

      
