function H = gauss3var(sigma,theta,fi,size)

[x,y,z] = ndgrid(-size(1):size(1),-size(2):size(2),-size(3):size(3));

a = sin(theta)^2 * cos(fi)^2 / (sigma(1)^2) + sin(theta)^2 *sin(fi)^2 / (sigma(2)^2) + cos(theta)^2 / (sigma(3)^2);

b = cos(theta)^2 * cos(fi)^2 / (sigma(1)^2) + cos(theta)^2 *sin(fi)^2 / (sigma(2)^2) + sin(theta)^2 / (sigma(3)^2);

c = sin(fi)^2 / (sigma(1)^2) + cos(fi)^2 / (sigma(2)^2);

d = sin(2*theta) * (cos(fi)^2) / (sigma(1)^2) + sin(2*theta) * (sin(fi)^2) / (sigma(2)^2) - sin(2*theta) / (sigma(3)^2);

e = - cos(theta) * sin(2*fi) / (sigma(1)^2) + cos(theta) * sin(2*fi) / (sigma(2)^2);

f = - sin(theta) * sin(2*fi) / (sigma(1)^2) + sin(theta) * sin(2*fi) / (sigma(2)^2) ;

H = exp(-(a* x.*x + b*y.*y + c*z.*z + d*x.*y + e*y.*z + f*x.*z));

end 