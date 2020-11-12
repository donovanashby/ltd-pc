%p%position vector x,y coords
%a%point of a line i.e. 147.4462  262.9167
%b%point of a line i.e. 171.1022  392.5463
%l%distance along the line (from a to b)
%d%distance from the line
%calculate line vector:
%

function [L D]=linearize_v2(p,a,b)

n=(b-a)/norm(b-a);%normalized vector defining the line from a to b
ap=bsxfun(@minus,p,a);%array of vector difference p-a (from a to p)
bp=bsxfun(@minus,p,b);%array of vector difference p-b (from b to p)

l_vector=(ap*(n'))*n;%vector defining location along line
d_vector=ap-l_vector;%vector defining location from line

L=sqrt(sum(l_vector.^2,2));%norm of vector l: distance on line (relative to a, absolute value)
D=sqrt(sum(d_vector.^2,2));%norm of vector d: distance from line

%index of values exceeding line segment, assign distance value as distance
%to nearest endpoint

ind1=(l_vector*n')<0; %is l_vector in same direction as b-a?
D(ind1)=sqrt(sum(ap(ind1,:).^2,2));%assign indexed D values as distance to a (norm of ap)
L(ind1)=0;%assign line values to 0

ind2=L>norm(a-b); %does L exceed length of line?
D(ind2)=sqrt(sum(bp(ind2,:).^2,2));%assign indexed D values as distance to b (norm of bp)
L(ind2)=norm(a-b);%assign line values to endpoint value

end

