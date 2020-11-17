%---------------------Theta Values ---------------------------
theta1 = -82;
theta2 = -67;
theta3 = -31;
theta4 = -42;
theta5 = -50;
delta = 90;
%--------------------Calculate Q-------------------------------
a = theta3+theta4+delta; %arbritrary constant for simplicity
b = theta1+theta2;
c = theta5;
Q = [cosd(c)*cosd(b)*cosd(a)+sind(c)*sind(b) -sind(c)*cosd(b)*cosd(a)+cosd(c)*sind(b)...
    cosd(b)*sind(a) cosd(b)*(110*sind(a)+60*cosd(theta3)+96)+98*cosd(theta1);
    cosd(c)*sind(b)*cosd(a)-sind(c)*cosd(b) -sind(c)*sind(b)*cosd(a)-cosd(c)*cosd(b)...
    sind(b)*sind(a) sind(b)*(110*sind(a)+60*cosd(theta3)+96)+98*sind(theta1);
    cosd(theta5)*sind(a) -sind(theta5)*sind(a) -cosd(a) -110*cosd(a)+60*sind(theta3)+157;
    0 0 0 1];

%----------Final end effector location and angles--------------
%
thetaf = (atan2d(Q(2,1), Q(1,1)));
phif = (atan2d((-Q(3,1)),(Q(1,1)*cosd(thetaf)+Q(2,1)*sind(thetaf))));
psif = (atan2d(Q(3,2),Q(3,3)));
%}
%--------------------Display Q----------------------------------
%display(Q);
endeffec=[0.0393701*Q(1,4) 0.0393701*Q(2,4) 0.0393701*Q(3,4) thetaf phif psif];