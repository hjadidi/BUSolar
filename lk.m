function g=lk(theta,E,sigma)
g=(1/(sigma*(2*pi)^0.5))*exp(-0.5*((theta-E)/sigma)^2);
end