function [ kernel ] = kernelns(n, sigma, pad)

if nargin < 3
    pad = n;
end
pad = max(pad,n);
if mod(pad,2)~=1
    pad = pad+1;
end

kernel = zeros(pad);
v = -(n-1)/2:(n-1)/2;
center = 1+(pad-n)/2:pad-(pad-n)/2;
kernel(center,center) = exp(-bsxfun(@plus,v.'.^2,v.^2)./(2*sigma^2));

end