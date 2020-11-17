%Define end effector coordinates and orientation---------------------------
theta=0;
phi=0;
psi=180;
xT=0;
yT=200;
zT=57;
%Calculate Q matrix--------------------------------------------------------
Q=[cosd(theta)*cosd(phi) cosd(theta)*sind(phi)*sind(psi)-sind(theta)*cosd(psi) ...
    cosd(theta)*sind(phi)*cosd(psi)+sind(theta)*sind(psi) xT;
    sind(theta)*cosd(phi) sind(theta)*sind(phi)*sind(psi)+cosd(theta)*cosd(psi) ...
    sind(theta)*sind(phi)*cosd(psi)-cosd(theta)*sind(psi) yT;
    -sind(phi) cosd(phi)*sind(psi) cosd(phi)*cosd(psi) zT;
    0 0 0 1];
disp(Q);