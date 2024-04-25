clc
clear all
close

L1=2;
L2=1;

q1=10;
q2=-25;
XY_fin=[0.5 ;0.5]
XY_akt=[0.3 ;0.3]
n=10;

m=[(L2*cos(q1+q2))/L1*L2*sin(q2) (L2*sin(q1+q2))/L1*L2*sin(q2);
    (-L2*cos(q1+q2)-L1*cos(q1))/L1*L2*sin(q2) (-L2*sin(q1+q2)-L1*sin(q1))/L1*L2*sin(q2)]

% Vytvoření vektorů pro úhly q1 a q2
q1 = linspace(0, pi/2, n); % Rozsah hodnot q1
q2 = linspace(0, pi, n); % Rozsah hodnot q2
X = linspace(-3, 3, n);
Y = linspace(-3, 3, n); 
XY=[X ;Y];
ind=0;
for i = 1:n
    for k = 1:n
        for j=1:n
            for l=1:n
                ind=ind+1;
                   Xm(ind,1)=X(:,i);
                   Ym(ind,1)=Y(:,k);
                   q1m(ind,1)=q1(:,j);
                   q2m(ind,1)=q2(:,l);
                   q_div(ind,1)=(L2*cos(q1(l)+q2(j)))/L1*L2*sin(q2(j))*X(i)+ (L2*sin(q1(l)+q2(j)))/L1*L2*sin(q2(j))*Y(k);
                   q_div2(ind,1)=(-L2*cos(q1(l)+q2(j))-L1*cos(q1(l)))/L1*L2*sin(q2(j))*X(i)+ (-L2*sin(q1(l)+q2(j))-L1*sin(q1(l)))/L1*L2*sin(q2(j))*Y(k);
            
            end
        end
    end
end

data1 = [Xm(:) Ym(:) q1m(:) q2m(:) q_div(:)]; % create x-y-theta1 dataset
data2 = [Xm(:) Ym(:) q1m(:) q2m(:) q_div2(:)]; % create x-y-theta2 dataset

opt = anfisOptions;
opt.InitialFIS = 48;
opt.EpochNumber = 250;
opt.DisplayANFISInformation = 1;
opt.DisplayErrorValues = 0;
opt.DisplayStepSize = 0;
opt.DisplayFinalResults = 1;

disp('--> Training first ANFIS network.')

anfis1 = anfis(data1,opt);

disp('--> Training secund ANFIS network.')

anfis2 = anfis(data2,opt);

x = -2.5:0.1:2.5; % x coordinates for validation
y = -2.5:0.1:2.5; % y coordinates for validation

[X,Y] = meshgrid(x,y);

XY = [X(:) Y(:)];
q1eval = evalfis(anfis1,XY); % theta1 predicted by anfis1
q2eval = evalfis(anfis2,XY); % theta2 predicted by anfis2
Xeval = L1 * cos(q1eval) + L2 * cos(q1eval + q2eval); % compute x coordinates
Yeval = L1 * sin(q1eval) + L2 * sin(q1eval + q2eval); % compute y coordinates
XYeval = [Xeval(:) Yeval(:)];

figure(3)
plot(X,Y)
hold on
scatter(Xeval,Yeval) 
ylabel('THETA1D - THETA1P')
title('Deduced theta1 - Predicted theta1')

