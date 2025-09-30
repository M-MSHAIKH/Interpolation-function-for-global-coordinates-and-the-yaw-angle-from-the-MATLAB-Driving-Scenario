function [dis] = EuclidianDis(X,Y,i)
% Euclidian distance between 2 points in the gloabal x and y plan
dis = sqrt((X(i+1) - X(i))^2 + (Y(i+1) - Y(i))^2);
end