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
%--------------------Calculate thetai-------------------------------
U=98*Q(2,3);
V=-98*Q(1,3);
W=Q(1,4)*Q(2,3)-Q(2,4)*Q(1,3);
theta5i=atan2d(-Q(3,2),Q(3,1)); %one solution for theta5i
theta1ia=2*atan2d((-V+sqrt(V^2+(U+W)*(U-W))),(-U-W));
theta1ib=2*atan2d((-V-sqrt(V^2+(U+W)*(U-W))),(-U-W));
theta2ia=(atan2d(Q(2,3),Q(1,3))-theta1ia);
theta2ib=(atan2d(Q(2,3),Q(1,3))-theta1ib);
%for 2 solutions of theta1/2, we get 2 solutions for gamma, and thus 2
%solutions for our A,B, and C constants used to calculate theta3
gammaa=(Q(1,4)-98*cosd(theta1ia))/(cosd(theta1ia+theta2ia));
gammab=(Q(1,4)-98*cosd(theta1ib))/(cosd(theta1ib+theta2ib));
Aa=11520-120*gammaa; Ab=11520-120*gammab;
Ba=18840-120*Q(3,4); Bb=Ba;
Ca=-(gammaa^2)+192*gammaa-(Q(3,4))^2+314*Q(3,4)-25365;
Cb=-(gammab^2)+192*gammab-(Q(3,4))^2+314*Q(3,4)-25365;
%Using theta1/2 to calculate theta3, we obtain 4 solutions for theta3
a = Ba^2+(Aa+Ca)*(Aa-Ca);
b = Bb^2+(Ab+Cb)*(Ab-Cb);
theta3ia=0;
theta3ib=0;
theta3ic=0;
theta3id=0;
if a>=0
    theta3ia=2*atan2d((-Ba+sqrt(Ba^2+(Aa+Ca)*(Aa-Ca))),(-Aa-Ca));
    theta3ic=2*atan2d((-Ba-sqrt(Ba^2+(Aa+Ca)*(Aa-Ca))),(-Aa-Ca));
end 
if b>=0
    theta3ib=2*atan2d((-Bb+sqrt(Bb^2+(Ab+Cb)*(Ab-Cb))),(-Ab-Cb));
    theta3id=2*atan2d((-Bb-sqrt(Bb^2+(Ab+Cb)*(Ab-Cb))),(-Ab-Cb));
end
%Option 1 of calculating theta4:
%{
theta4ia=acosd(-Q(3,3))-theta3ia-delta;
theta4ib=-theta4ia;
theta4ic=acosd(-Q(3,3))-theta3ia-delta;
%}
%Option 2 of calculating theta4:
%
%We then compute 4 values for theta4, choosing which equation to use based
%off of a condition placed on theta 1 and 2. The condition is calculated
%for both sets of theta1/2 values
alpha=theta1ia+theta2ia;
beta=theta1ib+theta2ib;
%For the theta1ia and theta2ia set:
if a>=0 && alpha~=0 && alpha~=180 && alpha~=-180
    theta4ia=atan2d((Q(2,3))/sind(alpha),-Q(3,3))-theta3ia-delta;
    theta4ic=atan2d((Q(2,3))/sind(alpha),-Q(3,3))-theta3ic-delta;
elseif a>=0
    theta4ia=atan2d((Q(1,3))/cosd(alpha),-Q(3,3))-theta3ia-delta;
    theta4ic=atan2d((Q(1,3))/cosd(alpha),-Q(3,3))-theta3ic-delta;
end

%For the theta1ib and theta2ib set:
if b>=0 && beta~=0 && beta~=180 && beta~=-180
    theta4id=atan2d((Q(2,3))/sind(beta),-Q(3,3))-theta3ib-delta;
    theta4ib=atan2d((Q(2,3))/sind(beta),-Q(3,3))-theta3id-delta;
elseif b>=0
    theta4ib=atan2d((Q(1,3))/cosd(beta),-Q(3,3))-theta3ib-delta;
    theta4id=atan2d((Q(1,3))/cosd(beta),-Q(3,3))-theta3id-delta;
end

%}
%----------Final end effector location and angles--------------

%--------------------Display possible soutions of thetai_matrix------------
%thetai_matrix=[theta1i;theta2i;theta3i;theta4i;theta5i;]