%Theta Values
NumberOfTransformations = 5;
theta1 = -12;
theta2 = -88;
theta3 = 77;
theta4 = 66;
theta5 = 11;

%DH PARAMS
%cm
%
l = [98 96 60 0 0];
d = [157 0 0 0 110];
%}
%inches
%{
l = [98*0.0393701 96*0.0393701 60*0.0393701 0 0];
d = [157*0.0393701 0 0 0 110*0.0393701];
%}
alpha = [0 90 0 90 0];
theta = [theta1 theta2 theta3 theta4+90 theta5];
%A Matrix Forward Qmatrix definitions
Amatrix = zeros(4, 4, NumberOfTransformations);
Qmatrix = zeros(4, 4);

cosa = @cosd;   
sina = @sind;

%simple function for easily switching between degrees and radians
DegreeOrRadians = 0;       %0 for degrees and 1 for radians
if DegreeOrRadians == 1     
    cosa = @cos;
    sina = @sin;
end

%determing the A matrix values and forward transformation matrix
for i = 1:NumberOfTransformations
    Amatrix(:,:,i) = [cosa(theta(i)) -sina(theta(i))*cosa(alpha(i))...
        sina(theta(i))*sina(alpha(i)) l(i)*cosa(theta(i));
                      sina(theta(i)) cosa(theta(i))*cosa(alpha(i))...
                      -cosa(theta(i))*sina(alpha(i)) l(i)*sina(theta(i));
                      0 sina(alpha(i)) cosa(alpha(i)) d(i);
                      0 0 0 1];
    if i == 1
        Qmatrix = Amatrix(:,:,i);
    else
        Qmatrix = Qmatrix*Amatrix(:,:,i);
    end
end

disp(Qmatrix);

%Final end effector location and angles
%{
xt = Qmatrix(1,4);
yt = Qmatrix(2, 4);
zt = Qmatrix(3, 4);
thetaf = atan2(Qmatrix(2,1), Qmatrix(1,1));
phif = atan2(-Qmatrix(3,1),Qmatrix(1,1)*cosa(thetaf)+Qmatrix(2,1)...
    *sina(thetaf));
psif = atan2(Qmatrix(3,2),Qmatrix(3,3));
%}
