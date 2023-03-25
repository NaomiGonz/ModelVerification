j = input("Enter number of joints:\n ");
m = input("Enter number of members:\n");

C = zeros(j, m);
Sx = zeros(j, 3);
Sy = zeros(j, 3);
X = zeros(1,j);
Y = zeros(1,j);
L = zeros(2*j,1);

for i = 1:j
    for k = 1:m
         fprintf('Is joint %d connected to member %d (y/n) ', i, k);
         letter = input('','s');
         if k == 1
            fprintf('\n');
            if i == 1
                fprintf('Does joint %d have a reaction force in the x-direction (y/n) ',i);
                letter2 = input('','s');
                if letter2 == 'y'
                    Sx(i, 1) = 1;
                end 
            end
            fprintf('\n');
            %fprintf('Enter x-coordinate for joint %d ',i);
            X(1,i) = input(sprintf('Enter x-coordinate for joint %d ',i));
            fprintf('\n');
            %fprintf('Enter y-coordinate for joint %d ',i);
            Y(1,i) = input(sprintf('Enter y-coordinate for joint %d ',i));
         end
         if letter == 'y'
             C(i, k) = 1;
         else 
             C(i, k) = 0;
         end 
    end
end

ry1 = input('Which has a reaction force y1');
ry2 = input('Which has a reaction force y2');
Sy(ry1,2) = 1;
Sy(ry2,3) = 1;

mass = input('What is the mass of the load? ');
jnum = input('What joint is the load on? ');
L(j+jnum, 1) = mass * 9.81;
