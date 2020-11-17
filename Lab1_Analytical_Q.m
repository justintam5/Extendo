clear
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Forward Model\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%---------------------Theta Values-----------------------------------------
Theta=[0 0 0 0 0];
delta = 90;
%--------------------Calculate Q-------------------------------------------
a = Theta(3)+Theta(4)+delta; %arbritrary constant for simplicity
b = Theta(1)+Theta(2);
c = Theta(5);
Q = [cosd(c)*cosd(b)*cosd(a)+sind(c)*sind(b) -sind(c)*cosd(b)*cosd(a)+...
    cosd(c)*sind(b) cosd(b)*sind(a) cosd(b)*(110*sind(a)+60*...
    cosd(Theta(3))+96)+98*cosd(Theta(1));
    cosd(c)*sind(b)*cosd(a)-sind(c)*cosd(b) -sind(c)*sind(b)*cosd(a)-...
    cosd(c)*cosd(b) sind(b)*sind(a) sind(b)*(110*sind(a)+60*...
    cosd(Theta(3))+96)+98*sind(Theta(1));
    cosd(c)*sind(a) -sind(c)*sind(a) -cosd(a) -110*cosd(a)+...
    60*sind(Theta(3))+157;
    0 0 0 1];
%----------------------Final end effector location and angles--------------
%
thetaf = (atan2d(Q(2,1), Q(1,1)));
phif = (atan2d((-Q(3,1)),(Q(1,1)*cosd(thetaf)+Q(2,1)*sind(thetaf))));
psif = (atan2d(Q(3,2),Q(3,3)));
%}
%-------------------------------Display Q----------------------------------
display(Q);
endeffec=[0.0393701*Q(1,4) 0.0393701*Q(2,4) 0.0393701*Q(3,4) thetaf phif psif];