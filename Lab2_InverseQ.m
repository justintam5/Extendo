clear
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Forward Model\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%---------------------Theta Values---------------------------
theta1 = 90;
theta2 = -20;
theta3 = -80;
theta4 = 19;
theta5 = 0;
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
%disp(Theta);
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Inverse Model\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%---------------------End Effector Values----------------------------------
%{
Q=[0 0.7071 -0.7071 -118.7939;
    0 0.7071 0.7071 257.3869;
  1.0000 0 0 157.0000;
  0 0 0 1];
delta=90;
%}
%--------------------Define Output Matrix----------------------------------
%Using the given equations we expect 8 mathematically possible solutions.  
%To organize this, we create a 8x10 matrix where the rows represent 
%seperate solutions,and the columns represent various values that are 
%either ouputs, values helpful in calculations, or indicators of nonviable 
%solutions. These are defined as such:
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%Columns: |theta1|theta2|theta3|theta4|theta5|gamma|A|B|C|rt|
%         |      |      |      |      |      |     | | | |  |
%         |      |      |      |      |      |     | | | |  |
%         |      |      |      |      |      |     | | | |  |...
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%where A,B,C, and gamma are used in calculations, and rt represents the
%terms being squarerooted during the calculation of theta3
EE=zeros(8,10);
%--------------------Calculate thetai-------------------------------
U=98*Q(2,3);
V=-98*Q(1,3);
W=Q(1,4)*Q(2,3)-Q(2,4)*Q(1,3);
%Calculate theta1, notice we get 2 possible solutions, denoted as s1 and s2
for i=1:8
    j=fix((i+1)/2);
    k=fix((i+3)/4);
    EE(i,1)=2*atan2d((-V+((-1)^i)*sqrt(V^2+(U+W)*(U-W))),(-U-W)); %theta1
    EE(i,2)=atan2d(((-1)^j)*Q(2,3),((-1)^j)*Q(1,3))-EE(i,1); %theta2
    %Where sind(theta1+theta2) != 90 Deg +-180 for gamma:
    EE(i,6)=(Q(1,4)-98*cosd(EE(i,1)))/(cosd(EE(i,1)+EE(i,2))); %gamma 
    EE(i,7)=11520-120*EE(i,6); %A
    EE(i,8)=18840-120*Q(3,4); %B
    EE(i,9)=-(EE(i,6)^2)+192*EE(i,6)-(Q(3,4))^2+314*Q(3,4)-25365; %C
    EE(i,10)=EE(i,8)^2+(EE(i,7)+EE(i,9))*(EE(i,7)-EE(i,9)); %rt
    if EE(i,10)>=0
        EE(i,3)=2*atan2d((-EE(i,8)+((-1)^k)*sqrt(EE(i,10))),...
            (-EE(i,7)-EE(i,9)));
    end
    %Where sind(theta1+theta2) != 90 Deg +-180 for theta4 calculated below:
    EE(i,4)=atan2d(Q(1,3)/cosd(EE(i,1)+EE(i,2)),(-Q(3,3)))-EE(i,3)-delta;
    EE(i,5)=atan2d(-Q(3,2)/(sind(EE(i,3)+EE(i,4)+delta)),...
        Q(3,1)/(sind(EE(i,3)+EE(i,4)+delta)));
end
%
%----------Final end effector location and angles--------------
disp('| Theta1  | Theta2  | Theta3  | Theta4  | Theta5 |')
disp(EE(:,1:5));
