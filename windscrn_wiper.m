clc
clear variables
close all

%---------------------------------------------------
%---------------------------------------------------
%-----------WINDSCREEN WIPER MECHANISM--------------
%-------   with no quick return effect   -----------
%---------------------------------------------------
%---------------------------------------------------

%--------------Aditya---Anurag---Sambhaw------------

scale = 2;
%-------  GrashOf Equation criteria established ----
l1 = scale*360;
l2 = scale*90;
l4 = scale*180; 
%l3 obtained from synthesis under the condition: NO QUICK RETURN
l3 = sqrt(l1^2 + l2^2 - l4^2);
l5 = 450/(cos(pi/3));
rotations = 10;

%Angle at which L4 locks
th4star = 2*asin(l2/l4);
th4star_degree = th4star*180/pi;

th2 = 0 : 5*pi/180 : 2*pi*rotations;

th4p = nan(size(th2)); % theta4 for plus
th4m = nan(size(th2)); % theta4 for minus

for j=1:length(th2)
    %Find Theta4 when Theta2 is given
    a = sin(th2(j));
    b = l1/l2 + cos(th2(j));
    c = (l1^2+l2^2-l3^2+l4^2)/(2*l2*l4)+l1/l4*cos(th2(j));
    th4m(j)=2*atan((a-(a^2+b^2-c^2)^0.5)/(b+c)); 
end


th5p=nan(size(th2)); % theta5 for plus
th5m=nan(size(th2)); % theta5 for minus

for j=1:length(th2)
    %Find Theta5 when Theta2 is given
    a=sin(th2(j));
    b=l1/l2+cos(th2(j));
    c=(l1^2+l2^2-l3^2+l4^2)/(2*l2*l4)+l1/l4*cos(th2(j));
    th5m(j)=pi+2*atan((a-(a^2+b^2-c^2)^0.5)/(b+c));
end


th3p=nan(size(th2)); % theta4 for plus
th3m=nan(size(th2)); % theta4 for minus

for j=1:length(th2)
    %Find Theta5 when Theta2 is given
    a=sin(th2(j));
    b=l1/l2+cos(th2(j));
    c=-( (l1^2+l2^2+l3^2-l4^2)/(2*l2*l3)+l1/l3*cos(th2(j)) );
    th3m(j)=2*atan((a-(a^2+b^2-c^2)^0.5)/(b+c));  
end


%%----------Plot configurations for plus sign--------------------------


% 1. Output current wiping range
startwipe_degree= (min(th5m))*180/pi; %Start wiping ==> 85.6617
endwipe_degree= (max(th5m))*180/pi; %Wiping end ==> 145.6573

% An angle difference between L4 and L5 should be given 
% so that the wiping range (based on the wiper center point) is 450 mm left and right.
% 60 degrees should be wiped from the center, so the start should be 60 degrees and the end 120 degrees.
% Subtract 60-startwipe_degree from th5 to give the angle difference between L4 and L5.

startwipe_radian = min(th5m);
delth5 = (pi/3)-startwipe_radian;

for j=1:length(th2)
    % Finding Theta 5, Given Theta 2
    a=sin(th2(j));
    b=l1/l2+cos(th2(j));
    c=(l1^2+l2^2-l3^2+l4^2)/(2*l2*l4)+l1/l4*cos(th2(j));
    % Positive value in the formula for the root of   
    th5m(j)=pi+2*atan((a-(a^2+b^2-c^2)^0.5)/(b+c))+delth5 ; 
end

for j=1:length(th2)
    % Finding Theta 5, Given Theta 2
    a=sin(th2(j));
    b=l1/l2+cos(th2(j));
    c=(l1^2+l2^2-l3^2+l4^2)/(2*l2*l4)+l1/l4*cos(th2(j));
    % Positive value in the formula for the root of   
    th5m(j)=pi+2*atan((a-(a^2+b^2-c^2)^0.5)/(b+c))+delth5 ; 
end

%Plotting the area bounds
curve1x = nan(size(th5m));
curve1y = nan(size(th5m));
curve2x = nan(size(th5m));
curve2y = nan(size(th5m));

for j=1:length(th5m)
    curve1x(j)= -l1 + l5*cos(th5m(j));
    curve1y(j)= 400 + l5*sin(th5m(j));
    curve2x(j)= -l1 + l5*cos(th5m(j));
    curve2y(j)= -400 + l5*sin(th5m(j));
end

[min_x, min_index] = min(curve1x);
[max_x, max_index] = max(curve1x);

fprintf('L1 length: %1.f mm\n',l1)
fprintf('L2 length: %1.f mm\n',l2)
fprintf('L3 length: %f mm\n',l3)
fprintf('L4 length: %1.f mm\n',l4)
fprintf('Each difference between L4 and L5: %f(degree)\n',-delth5*180/pi) 
% However, although L4 and L5 are one rigid body, 
% they are separated for explanation of each difference.

khatam = length(th5m)+1;

for j= 1: length(th2)
    %%---------LOCUS EQUATIONS-------------
    O2x = 0;
    O2y = 0;
    Ax = O2x + l2*cos(th2(j));
    Ay = O2y + l2*sin(th2(j));
    Bx = Ax + l3*cos(th3m(j));
    By = Ay + l3*sin(th3m(j));
    %  Bx2=-l1+l4*cos(th4p(j));
    %  By2=l4*sin(th4p(j));
    O4x = -l1;
    O4y = 0;
    Cx = O4x + l5*cos(th5m(j));
    Cy = O4y + l5*sin(th5m(j));
    Dx = -300 + O4x + l5*cos(th5m(j));
    Dy = O4y + l5*sin(th5m(j));
    O5x = -300 + O4x;
    O5y = 0;
    W1x = Cx;
    W1y = Cy+400;
    W2x = Cx;
    W2y = Cy-400;
    
    xtemp = [O2x Ax Bx  O4x Cx Dx O5x];
    ytemp = [O2y Ay By  O4y Cy Dy O5y];
    wx = [W1x W2x];
    wy = [W1y W2y];
    plot(curve1x(min_index:max_index), curve1y(min_index:max_index),'r.-','linewidth',1);
    hold on;
    plot(curve2x(min_index:max_index), curve2y(min_index:max_index),'r.-','linewidth',1);
    plot([curve1x(min_index) curve2x(min_index)],[curve1y(min_index) curve2y(min_index)],'r--','linewidth',1);
    plot([curve1x(max_index) curve2x(max_index)],[curve1y(max_index) curve2y(max_index)],'r--','linewidth',1);
    plot(xtemp,ytemp,'b.-','linewidth',2,'MarkerSize', 20);
    plot(wx,wy,'r-','linewidth',6,'MarkerSize', 40);
    hold off;
    %labelpoints(O2x,O2y,labels,'SE',0.2,0)
    title('--- Windscreen Wiper Mechanism ---')
    grid on
    xlabel('X [cm]')
    ylabel('Y [cm]')

    ylim([-500,1600])
    xlim([-2000,1000])
    %axis equal;
    pause(0.0000001)
end