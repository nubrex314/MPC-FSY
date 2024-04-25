clc
clear all
close all

l1 = 2; % length of first arm
l2 = 1; % length of second arm

q1 = 0:0.1:pi/2; % all possible theta1 values
q2 = 0:0.1:pi; % all possible theta2 values

[Q1,Q2] = meshgrid(q1,q2); % generate grid of angle values

X = l1 * cos(Q1) + l2 * cos(Q1 + Q2); % compute x coordinates
Y = l1 * sin(Q1) + l2 * sin(Q1 + Q2); % compute y coordinates

data1 = [X(:) Y(:) Q1(:)]; % create x-y-theta1 dataset
data2 = [X(:) Y(:) Q2(:)]; % create x-y-theta2 dataset

    figure(1);
  plot(X(:),Y(:),'r.'); 
  axis equal;
  xlabel('X','fontsize',10)
  ylabel('Y','fontsize',10)
  title('X-Y souradnice pro učeni všech q1 a q2','fontsize',10)
% Vytvoření grafu
figure(7);
surf(X,Y, Q1);
hold on
xlabel('X');
ylabel('Y');
zlabel('q');
title('zmena Q1');
% 

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
% opt.EpochNumber = 150;
% opt.DisplayANFISInformation = 0;
% opt.DisplayErrorValues = 0;
% opt.DisplayStepSize = 0;
% opt.DisplayFinalResults = 0;

% disp('--> Training first ANFIS network.')
% 
% anfis1 = anfis(data1,opt);
% 
% disp('--> Training second ANFIS network.')
% 
% opt.InitialFIS = 12;
% anfis2 = anfis(data2,opt);
%% kontrola naučeni
anfis1 = readfis('anfis1.fis');
anfis2 = readfis('anfis2.fis');

x = 0:0.1:1.5; % x coordinates for validation
y = 1.5:0.1:2.5; % y coordinates for validation

[X,Y] = meshgrid(x,y);

XY = [X(:) Y(:)];
q1eval = evalfis(anfis1,XY); % theta1 predicted by anfis1
q2eval = evalfis(anfis2,XY); % theta2 predicted by anfis2
Xeval = l1 * cos(q1eval) + l2 * cos(q1eval + q2eval); % compute x coordinates
Yeval = l1 * sin(q1eval) + l2 * sin(q1eval + q2eval); % compute y coordinates
XYeval = [Xeval(:) Yeval(:)];
figure(3)
plot(X,Y)
hold on
scatter(Xeval,Yeval) 
ylabel('THETA1D - THETA1P')
title('Deduced XY - Predicted XY')

Xs=reshape(X, [], 1);
Ys=reshape(Y, [], 1);

divX=Xs-Xeval;
divY=Ys-Yeval;

% určeni chyby daneho systemu
figure(4)
subplot(1,2,1)
plot(divX)

subplot(1,2,2)
plot(divY)
ylabel('THETA1D - THETA1P')
title('Deduced theta1 - Predicted theta1')


%% Prepočet na 360
x = -1.5:0.1:1.5; % x coordinates for validation
y = -2.5:0.1:2.5; % y coordinates for validation

[X,Y] = meshgrid(x,y);
%XYabs = [abs(X(:)) abs(Y(:))];
XY = [X(:) Y(:)];
for i=1:1581
if(XY(i,1)>0 && XY(i,2)>0)
    XYabs(i,:) = XY(i,:);
end
if(XY(i,1)<=0 && XY(i,2)>0)
    XYabs(i,:) =[XY(i,2) abs(XY(i,1))] ;
end
if(XY(i,1)>0 && XY(i,2)<=0)
    XYabs(i,:) =[abs(XY(i,2)) XY(i,1)] ;
end
if(XY(i,1)<=0 && XY(i,2)<=0)
    XYabs(i,:) =[abs(XY(i,1)) abs(XY(i,2))] ;
end
end

q1eval = evalfis(anfis1,XYabs); % theta1 predicted by anfis1
q2eval = evalfis(anfis2,XYabs); % theta2 predicted by anfis2
kvad = readfis('kvadranty.fis');
q1eval =evalfis(kvad,XY)+q1eval;

Xeval = l1 * cos(q1eval) + l2 * cos(q1eval + q2eval); % compute x coordinates
Yeval = l1 * sin(q1eval) + l2 * sin(q1eval + q2eval); % compute y coordinates
XYeval = [Xeval(:) Yeval(:)];

figure(5)
plot(X,Y)
hold on
scatter(Xeval,Yeval) 
title('Deduced-Predicted')
