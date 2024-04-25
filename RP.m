clc
clear all
close all

q1 = 0:0.1:pi*2; % all possible theta1 values
q2 = 0:0.1:3; % all possible theta2 values

[Q1,Q2] = meshgrid(q1,q2); % generate grid of angle values

X = Q2.*cos(Q1); % compute x coordinates
Y = Q2.*sin(Q1); % compute y coordinates

data1 = [X(:) Y(:) Q1(:)]; % create x-y-theta1 dataset
data2 = [X(:) Y(:) Q2(:)]; % create x-y-theta2 dataset

%% Vytvoření grafu
figure(5);
plot(X(:),Y(:),'r.'); 
axis equal;
xlabel('X','fontsize',10)
ylabel('Y','fontsize',10)
title('X-Y souradnice pro učeni všech q1 a q2','fontsize',10)


figure(1);
surf(X,Y, Q1);
hold on
xlabel('X');
ylabel('Y');
zlabel('q');
title('zmena Q1');

figure(2);
surf(X,Y, Q2);
hold on
xlabel('X');
ylabel('Y');
zlabel('q');
title('zmena Q2');
%% učeni
% opt = anfisOptions;
% opt.InitialFIS = 12;
% opt.EpochNumber = 200;
% opt.DisplayANFISInformation = 0;
% opt.DisplayErrorValues = 0;
% opt.DisplayStepSize = 0;
% opt.DisplayFinalResults = 0;
% 
% disp('--> Training first ANFIS network.')
% 
% anfis1 = anfis(data1,opt);
% 
% disp('--> Training second ANFIS network.')
% 
% opt.InitialFIS = 12;
% anfis2 = anfis(data2,opt);


anfis1 = readfis('RPanfis1.fis');
anfis2 = readfis('RPanfis2.fis');
%% testovani 
x = -2:0.1:2; % x coordinates for validation
y = -2:0.1:2; % y coordinates for validation

[X,Y] = meshgrid(x,y);

XY = [X(:) Y(:)];
q1eval = evalfis(anfis1,XY); % theta1 predicted by anfis1
q2eval = evalfis(anfis2,XY); % theta2 predicted by anfis2

Xeval = q2eval.* cos(q1eval) ; % compute x coordinates
Yeval = q2eval.* sin(q1eval); % compute y coordinates
XYeval = [Xeval(:) Yeval(:)];

figure(3)
plot(X,Y)
hold on
scatter(Xeval,Yeval) 
ylabel('THETA1D - THETA1P')
title('Deduced - Predicted')