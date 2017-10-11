function [ d ] = diff_matrix( s )

if  s < 2
    error('size must be greater than 2');
end

d = [ones(1,1), -eye(1)]; %d=[1 -1]

for i = 2:s-1
   nd = [ones(i,1), -eye(i)];
   pad = zeros(size(d,1),1);
   d=[nd;pad, d];
end

end

