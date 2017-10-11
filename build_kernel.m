function [ kernel ] = build_kernel(sizes,stds)

if length(sizes)~=length(stds) || any(mod(sizes,2)==0)
    error('impossible');
end

N = max(sizes);
kernel = zeros(N);

for i = 1:length(sizes)
    start = 1+(N-sizes(i))/2;
    stop = N-(N-sizes(i))/2;
    kernel(start:stop,start:stop) = kernel(start:stop,start:stop) + kernelns(sizes(i),stds(i))./length(sizes);
end
