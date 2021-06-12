function J = color_vacu(m)

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end


        b=[1,0.94118,0.80392,0.80784,0.60784,0.20000,0.04314,0.09804,0.06667,0.04706,0.03137];
        g=[1,0.88627,0.62745,0.65098,0.75686,0.69412,0.90588,0.96078,0.50980,0.07059,0.05882];
        r=[1,0.94510,0.69804,0.50196,0.40392,0.33725,0.80000,0.98039,0.97255,0.98039,0.59608];

rr=interp1((0:10)/10,r,(0:(m-1))/(m-1));
gg=interp1((0:10)/10,g,(0:(m-1))/(m-1));
bb=interp1((0:10)/10,b,(0:(m-1))/(m-1));

J=zeros(m,3);
J(:,1)=rr;
J(:,2)=gg;
J(:,3)=bb;