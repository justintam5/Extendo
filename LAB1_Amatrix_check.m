%---------------------Theta Values ---------------------------
theta1 = 0;
theta2 = 0;
theta3 = 0;
theta4 = 0;
theta5 = 90;
delta = 0;

%--------------------Calculate Q-------------------------------
%Q = zeros(4, 4);
a = theta3+theta4+delta; %arbritrary constant for simplicity
b = theta1+theta2;
c = theta5;
Q = [cosd(c)*cosd(b)*cosd(a)+sind(c)*sind(b) -sind(c)*cosd(b)*cosd(a)+cosd(c)*sind(b)...
    cosd(b)*sind(a) cosd(b)*(110*sind(a)+60*cosd(theta3)+96)+98*cosd(theta1);
    cosd(c)*sind(b)*cosd(a)-sind(c)*cosd(b) -sind(c)*sind(b)*cosd(a)-cosd(c)*cosd(b)...
    sin(b)*sind(a) sind(b)*(110*sind(a)+60*cosd(theta3)+96)+98*sind(theta1);
    cosd(c)*sind(a) -sind(c)*sind(a) -cosd(a) -110*cosd(a)+60*sind(theta3)+157;
    0 0 0 1];

%----------Final end effector location and angles--------------
thetaf = (atan2(Q(2,1), Q(1,1)))*180/pi;
phif = (atan2((-Q(3,1)),(Q(1,1)*cosd(thetaf)+Q(2,1)*sind(thetaf))))*180/pi;
psif = (atan2(Q(3,2),Q(3,3)))*180/pi;

%--------------------Display Q----------------------------------
display(Q);