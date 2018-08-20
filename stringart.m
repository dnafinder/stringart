function stringart(varargin)
% String art, or pin and thread art, is characterized by an arrangement of
% colored thread strung between points to form geometric patterns. Though
% straight lines are formed by the string, the slightly different angles
% and metric positions at which strings intersect gives the appearance of
% Bézier curves (as in the mathematical concept of envelope of a family of
% straight lines). Quadratic Bézier curve are obtained from strings based
% on two intersecting segments. String art has its origins in the 'curve
% stitch' activities invented by Mary Everest Boole at the end of the 19th
% century to make mathematical ideas more accessible to children. It was
% popularised as a decorative craft in the late 1960s through kits and
% books.    
% 
% Syntax: 	stringart(varargin)
%      
%     Properties:
%           'Sides' - sides number of polygon you want to use (default = 3)
%           'Crossed' - logical value that says if you want to use the
%           perimeter (0 - default) or bisettrices of vertices (1).
%           'Density' - The number of pins you want to use for each side
%           (default = 40)
%           'Color' - 1x3 vector that indicates the colors of the wires
%           (default = [0 0 0] black)
% 
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
% 
% To cite this file, this would be an appropriate format:
% Cardillo G. (2018) Stringart: Play with geometry and Bézier's quadratic
% curve
% http://www.mathworks.com/matlabcentral/fileexchange/

p = inputParser;
addParameter(p,'Sides',3, @(x) validateattributes(x,{'numeric'},{'scalar','real','finite','integer','>=',3,'nonnan','nonempty'}));
addParameter(p,'Crossed',0, @(x) validateattributes(x,{'numeric'},{'scalar','real','finite','integer','>=',0,'<=',1,'nonnan','nonempty'}));
addParameter(p,'Density',40, @(x) validateattributes(x,{'numeric'},{'scalar','real','finite','integer','>=',10,'nonnan','nonempty'}));
addParameter(p,'Color',[0 0 0], @(x) validateattributes(x,{'numeric'},{'row','real','finite','ncols',3,'>=',0,'<=',1,'nonnan','nonempty'}));
parse(p,varargin{:})

hold on
axis square
set(gcf,'Color', 'white');
set(gca,'XColor','w','YColor','w')

%Matrix preallocation
MX=zeros(p.Results.Density,p.Results.Sides+1); 
MY=MX;
switch p.Results.Crossed
    case 0
        mp=0.5; %middle point of the side
        h=mp*tan(pi*(0.5-1/p.Results.Sides)); %apotema
        MX(:,1)=linspace(0,1,p.Results.Density)'; %coordinates of first side
    case 1
        mp=linspace(0,0.5,p.Results.Density); %middle point of the side
        h=mp.*tan(pi*(0.5-1/p.Results.Sides)); %apotema
        MX(:,1)=mp'; 
        MY(:,1)=h';
end

%Rotate around incentrum by theta angle
k=(2*pi)/p.Results.Sides;
for I=1:p.Results.Sides
    theta=k*I;
    Rot=[cos(theta) -sin(theta); sin(theta) cos(theta)];
    t=(Rot*(eye(2)*[MX(:,1)';MY(:,1)']-[mp(end);h(end)]))+[mp(end);h(end)];
    MX(:,I+1)=t(1,:)'; MY(:,I+1)=t(2,:)';  
end
clearvars -except MX MY p

%connect points
L=length(MX);
for I=p.Results.Crossed:L-1
    for J=1:p.Results.Sides
        switch p.Results.Crossed
            case 0
                plot([MX(I+1,J) MX(I+1,J+1)],[MY(I+1,J) MY(I+1,J+1)],'Color',p.Results.Color)
            case 1
                plot([MX(I+1,J) MX(L+1-I,J+1)],[MY(I+1,J) MY(L+1-I,J+1)],'Color',p.Results.Color)
        end
        pause(0.05)
    end
end

hold off
set(gcf,'units','normalized','outerposition',[0 0 1 1]);