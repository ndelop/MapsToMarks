function [ out ] = max1( in, stop )
if nargin < 2
    stop = inf;
end

m = in;
for i = 1:min(stop,ndims(in))
    m = max(m);
end
out = bsxfun(@rdivide,in,m);
