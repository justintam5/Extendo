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
disp(Q);
disp('| Theta1F | Theta2F | Theta3F | Theta4F | Theta5F |');
fprintf(['|    %d   |    %d   |    %d   |    %d   |    %d   |\n']...
    ,Theta(1),Theta(2),Theta(3),Theta(4),Theta(5));
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Inverse Model\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%------------------------Current Bounds------------------------------------
%
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
zero_flag=zeros(1,8); %1 if solution involved atan2d of a complex number
%--------------------Calculate thetai--------------------------------------
U=98*Q(2,3);V=-98*Q(1,3);W=Q(1,4)*Q(2,3)-Q(2,4)*Q(1,3);
%Main for loop: calculates all 8 possible thetai solutions
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
    %to calculate theta3 we first check to see if the correspoding term
    %being squarooted is positive, and only proceed if that is the case
    if EE(i,10)>=0
        EE(i,3)=2*atan2d((-EE(i,8)+((-1)^k)*sqrt(EE(i,10))),...
            (-EE(i,7)-EE(i,9)));
    else
        zero_flag(1,i)=1;
    end
    %Knowing theta1-3 we can calculate a singular theta4/5 pair for every
    %solution calculated so far, and thus we end up with 8 solutions.
    %Where sind(theta1+theta2) != 90 Deg +-180 for theta4 calculated below:
    EE(i,4)=atan2d(Q(1,3)/cosd(EE(i,1)+EE(i,2)),(-Q(3,3)))-EE(i,3)-delta;
    EE(i,5)=atan2d(-Q(3,2)/(sind(EE(i,3)+EE(i,4)+delta)),...
        Q(3,1)/(sind(EE(i,3)+EE(i,4)+delta)));
end
%-----------Post Calculations to obtain realizable solutions---------------
EEO1=EE(:,1:5); %where EEO1 is an intermidiate EE matrix
cntr=1;
for q=1:8
    for m=1:5
        %convert any awkward angles by adding or subtracting 360
        if EEO1(q,m)<-180
            EEO1(q,m)=EEO1(q,m)+360;
        end
        if EEO1(q,m)>180
            EEO1(q,m)=EEO1(q,m)-360;
        end
    end
    %check if a solution involved a complex number, while also checking if
    %another condition of the Q matrix is satisfied by the theta1-5
    %solution
    %We also use fix() to convert the condition to be percise to 2 decimal
    %places.
    if zero_flag(q)==0 && fix((-110*cosd(EEO1(q,3)+EEO1(q,4)+delta)+...
            60*sind(EEO1(q,3))+157)*1e2)/1e2==fix(Q(3,4)*1e2)/1e2
        EEO(cntr,:)=EEO1(q,:); %Defines End-Effector_Output matrix
        cntr=cntr+1; %so the final matrix has as many terms as viable sols. 
    end
end

%----------Final end effector location and angles--------------------------
disp('| Theta1I | Theta2I | Theta3I | Theta4I | Theta5I |');
disp(EEO);
