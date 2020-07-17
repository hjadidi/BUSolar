function f=prior(theta,mu,sigma)
f=(1/(sigma*(2*pi)^0.5))*exp(-0.5*((theta-mu)/sigma)^2);
end
