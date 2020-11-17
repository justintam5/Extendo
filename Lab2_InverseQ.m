%---------------------End Effector Values---------------------------

%{
Q=[0 0.7071 -0.7071 -118.7939;
    0 0.7071 0.7071 257.3869;
  1.0000 0 0 157.0000;
  0 0 0 1];
%}
%thetai=0;
%phii=-90;
%psii=180;
%delta=90;
%--------------------Define Output Matrix----------------------------------
%Using the given equations we expect 16 mathematical solutions. To organize
%this we create a 16x10 matrix where the rows represent seperate solutions,
%and the columns represent various values that are either ouputs,
%values helpful in calculations, or indicators of nonviable solutions.
%These are defined as such:
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%Columns: |theta1|theta2|theta3|theta4|theta5|gamma|A|B|C|rt|
%         |      |      |      |      |      |     | | | |  |
%         |      |      |      |      |      |     | | | |  |
%         |      |      |      |      |      |     | | | |  |...
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%where A,B,C, and gamma are used in calculations, and rt represents the
%terms being squarerooted during the calculation of theta3
EE=zeros(16,10);
%--------------------Calculate thetai-------------------------------
U=98*Q(2,3);
V=-98*Q(1,3);
W=Q(1,4)*Q(2,3)-Q(2,4)*Q(1,3);
%Calculate theta1, notice we get 2 possible solutions, denoted as s1 and s2
EE(1:8,1)=2*atan2d((-V+sqrt(V^2+(U+W)*(U-W))),(-U-W));
EE(9:16,1)=2*atan2d((-V-sqrt(V^2+(U+W)*(U-W))),(-U-W));
%2 solutions of theta1, we get 4 solutions for gamma, and thus 4
%solutions for our A,B, and C constants used to calculate theta3
%Note the smn format, where m denotes the connection to the corresponding
%theta1 solution
for i=1:16
    EE(i,6)=sqrt
end 
gamma_s11=sqrt((Q(1,4)-98*cosd(theta1i_s1))^2+(Q(2,4)-98*sind(theta1i_s1))^2);
gamma_s12=-sqrt((Q(1,4)-98*cosd(theta1i_s1))^2+(Q(2,4)-98*sind(theta1i_s1))^2);
gamma_s21=sqrt((Q(1,4)-98*cosd(theta1i_s2))^2+(Q(2,4)-98*sind(theta1i_s2))^2);
gamma_s22=-sqrt((Q(1,4)-98*cosd(theta1i_s2))^2+(Q(2,4)-98*sind(theta1i_s2))^2);
A_s11=11520-120*gamma_s11; A_s12=11520-120*gamma_s12; 
A_s21=11520-120*gamma_s21; A_s22=11520-120*gamma_s22; 
B_s11=18840-120*Q(3,4); B_s12=B_s11; B_s21=B_s11; B_s22=B_s11;
C_s11=-(gamma_s11^2)+192*gamma_s11-(Q(3,4))^2+314*Q(3,4)-25365;
C_s12=-(gamma_s12^2)+192*gamma_s12-(Q(3,4))^2+314*Q(3,4)-25365;
C_s21=-(gamma_s21^2)+192*gamma_s21-(Q(3,4))^2+314*Q(3,4)-25365;
C_s22=-(gamma_s22^2)+192*gamma_s22-(Q(3,4))^2+314*Q(3,4)-25365;
%Using theta1 and gamma to calculate theta3, we obtain 8 solutions for
%theta3. The function involves a squareroot, so I'll calculate that ahead
%of time to immediately reject any complex values
a=B_s11^2+(A_s11+C_s11)*(A_s11-C_s11);
b=B_s12^2+(A_s12+C_s12)*(A_s12-C_s12);
c=B_s21^2+(A_s21+C_s21)*(A_s21-C_s21);
d=B_s22^2+(A_s22+C_s22)*(A_s22-C_s22);

%Set all 8 theta3 values to 0:
theta3i_s111=0; %a
theta3i_s112=0; %a
theta3i_s121=0; %b
theta3i_s122=0; %b
theta3i_s211=0; %c
theta3i_s212=0; %c
theta3i_s221=0; %d
theta3i_s222=0; %d

%testing each rooted term, if the term is >= 0, we proceed to calculate the
%2 theta 3 values per term, and the corresponding 2 possible theta4 values
%per theta3 value. The result is 8 possible theta3 values, and 16 possible 
%theta4 values
if a>=0
    %theta3
    theta3i_s111=2*atan2d((-B_s11+sqrt(a)),(-A_s11-C_s11));
    theta3i_s112=2*atan2d((-B_s11-sqrt(a)),(-A_s11-C_s11));
    %theta4:
    theta4i_s1111=acosd(-Q(3,3))-theta3i_s111-delta;
    theta4i_s1112=-acosd(-Q(3,3))-theta3i_s111-delta;
    theta4i_s1121=acosd(-Q(3,3))-theta3i_s112-delta;
    theta4i_s1122=-acosd(-Q(3,3))-theta3i_s112-delta;
end 
if b>=0
    theta3i_s121=2*atan2d((-B_s12+sqrt(b)),(-A_s12-C_s12));
    theta3i_s122=2*atan2d((-B_s12-sqrt(b)),(-A_s12-C_s12));
    %theta4:
    theta4i_s1211=acosd(-Q(3,3))-theta3i_s121-delta;
    theta4i_s1212=-acosd(-Q(3,3))-theta3i_s121-delta;
    theta4i_s1221=acosd(-Q(3,3))-theta3i_s122-delta;
    theta4i_s1222=-acosd(-Q(3,3))-theta3i_s122-delta;
end
if c>=0
    theta3i_s211=2*atan2d((-B_s21+sqrt(c)),(-A_s21-C_s21));
    theta3i_s212=2*atan2d((-B_s21-sqrt(c)),(-A_s21-C_s21));
    %theta4:
    theta4i_s2111=acosd(-Q(3,3))-theta3i_s211-delta;
    theta4i_s2112=-acosd(-Q(3,3))-theta3i_s211-delta;
    theta4i_s2121=acosd(-Q(3,3))-theta3i_s212-delta;
    theta4i_s2122=-acosd(-Q(3,3))-theta3i_s212-delta;
    %theta2:
end
if d>=0
    theta3i_s221=2*atan2d((-B_s22+sqrt(d)),(-A_s22-C_s22));
    theta3i_s222=2*atan2d((-B_s22-sqrt(d)),(-A_s22-C_s22));
    %theta4:
    theta4i_s2211=acosd(-Q(3,3))-theta3i_s221-delta;
    theta4i_s2212=-acosd(-Q(3,3))-theta3i_s221-delta;
    theta4i_s2221=acosd(-Q(3,3))-theta3i_s222-delta;
    theta4i_s2222=-acosd(-Q(3,3))-theta3i_s222-delta;
end
%Define a test value that when true, indicates an arctan of a negative over
%a negative has happened, but is hidden and so we manually adjust
%test=theta
%theta5i=atan2d(-Q(3,2),Q(3,1)); %one solution for theta5i
%theta2ia=(atan2d(Q(2,3),Q(1,3))-theta1ia);
%theta2ib=(atan2d(Q(2,3),Q(1,3))-theta1ib);
%}
%----------Final end effector location and angles--------------

%--------------------Display possible soutions of thetai_matrix------------
%thetai_matrix=[theta1i;theta2i;theta3i;theta4i;theta5i;]