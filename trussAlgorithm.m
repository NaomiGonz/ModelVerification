% Change loaded file name. Expecting matrices: C, L, Sx, Sy, X, and Y
% values must be in inches or ounces
% make sure to 'clear' after each run to avoid errors
%load('TrussPracticeDesign_NaomiLakshmiIsha_A1.mat');
load('TrussPracticeDesign_NaomiLakshmiIsha_A1.mat','C','Sx','Sy','X','Y','L');

disp(C);

%unit = input('is this is N/m (y/n)','s');
%if unit == 'y'
 %   L = 0.278*L;
  %  X = 39.37*X;
   % Y = 39.37*Y;
%end

%finds the number of joints and members in the truss
[j,m] = size(C);
A = zeros(2*j,m+3);

%copies Sx and Sy martices into A
A(1:j,m+1:m+3) = Sx;
A(j+1:2*j,m+1:m+3) = Sy;

%will keep track of total length of all members
len = 0;

%use to find the critial value of all the members
Pcrit = zeros(m,1);

%populates the rest of matrix A
for i = 1:m
    check = 0;
    k = 1;
    hold = [];
    while (check < 2)
        if C(k,i) == 1
            check = check +1;
            hold = [hold,k];
        end
        k = k+1;
    end
    
    coor1 = [X(hold(1)), Y(hold(1))];
    coor2 = [X(hold(2)), Y(hold(2))];
    
    r = dist(coor1,coor2);
    len = len + r;


    A(hold(1),i) = (X(hold(2))-X(hold(1)))/r;
    A(hold(2),i) = (X(hold(1))-X(hold(2)))/r;

    A(hold(1)+j,i) = (Y(hold(2))-Y(hold(1)))/r;
    A(hold(2)+j,i) = (Y(hold(1))-Y(hold(2)))/r;

    Pcrit(i,1) = -4338*r^-2.125;
end
%disp(Pcrit);
%finds the tensions of each member 
disp(A);
T = (A^(-1))*L;

%finds the total load on the structure
%%%%%%%%%%%ASK ABOUT IF WE NEED TO CONSIDER LOAD IN MORE THEN ONE JOINT HOW
%%%%%%%%%%%THAT EFFECTS THE
load = 0;
for i = 1:size(L,1)
    if (L(i,1) ~= 0)
        load = load + L(i,1);
    end
end

Wfail = zeros(m,1);
index = 0;
ratio = 0;
for i = 1:m
    Wfail(i) = T(i)/Pcrit(i);
    if (Wfail(i)>ratio)
        ratio = Wfail;
        index = i;
        if (ratio >= 1)
            fprintf('ERROR BRIDGE WILL FAIL AT MEMBER %d\n', index);
        end
    end
end

%disp(Wfail);
fprintf('member %d is the critical member. CritRatio = %f\n\n',index,ratio(index));
%calculates the cost
cost = j*10 + len*1;

%prints in desired format 
fprintf('\\%% EK301, Section A3, Group 4: Naomi G., Lakshmi R., Isha M., 4/1/2023.\n');
fprintf('Load: %d oz\n',load);
fprintf('Member forces in oz\n');
for i = 1:m
    fprintf('m%d: ',i);
    letter = 'T';
    if T(i,1) < 0
        letter = 'C';
    end
    fprintf('%.3f (%s)\n',abs(T(i,1)),letter);
end
fprintf('Reaction forces in oz:\n');
fprintf('Sx1: %.2f\n',T(m+1,1));
fprintf('Sy1: %.2f\n',T(m+2,1));
fprintf('Sy2: %.2f\n',T(m+3,1));
fprintf('Cost of truss: $%.2f\n',cost);
fprintf('Theoretical max load/cost ratio in oz/$: %.5f\n',load/cost);

%function used to find the distance between two joints
function r = dist(p1,p2)
    r = norm(p1-p2);
end
