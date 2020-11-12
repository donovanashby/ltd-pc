%normalize function
%normalizes an array of values to preset min and max values.
%if no min/max values provided, it calculates them

function [Nvalues]=normalize(values,minimum,maximum)

if nargin == 1
    minimum=min(values);
    maximum=max(values);
end


Nvalues=(values-minimum)/(maximum-minimum);

bad=Nvalues>1 | Nvalues<0;
Nvalues(bad)=NaN;

end