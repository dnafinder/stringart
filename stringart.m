function stringart(varargin)
%STRINGART String art patterns on a regular polygon.
%
%   Syntax
%   ------
%   stringart
%   stringart(Name, Value, ...)
%
%   Description
%   -----------
%   STRINGART creates a "string art" (pin and thread art) pattern on a
%   regular polygon. Points ("pins") are placed along each side and then
%   connected by straight line segments that visually approximate quadratic
%   Bézier curves (envelopes of straight lines). The pattern is drawn into
%   the current axes and no output is returned.
%
%   The pattern can be customized by setting:
%     - the number of polygon sides,
%     - whether the connections follow polygon edges or bisectors,
%     - the number of pins per side (density),
%     - the RGB color of the strings.
%
%   Inputs (Name-Value Pairs)
%   -------------------------
%   'Sides'   : Positive integer, number of sides of the regular polygon.
%               Default: 3 (equilateral triangle).
%
%   'Crossed' : Logical or 0/1 flag that selects the connection mode.
%               0 (false) - use the polygon perimeter (edges).
%               1 (true)  - use the internal bisectors (crossed chords).
%               Default: 0.
%
%   'Density' : Positive integer, number of pins (points) per side.
%               Higher values produce smoother envelopes but require more
%               line segments to be drawn.
%               Minimum allowed: 10. Default: 40.
%
%   'Color'   : 1-by-3 real numeric row vector in the range [0 1]
%               specifying the RGB color of the strings (lines).
%               Default: [0 0 0] (black).
%
%   Outputs
%   -------
%   This function does not return any output arguments. It draws the
%   string-art pattern directly into the current figure.
%
%   Example
%   -------
%   % Draw a black, non-crossed string-art pattern on a triangle
%   figure;
%   stringart('Sides', 3, 'Crossed', 0, 'Density', 40, 'Color', [0 0 0]);
%   title('String Art on a Regular Triangle');
%
%   % Draw a crossed pattern on a square with red strings
%   figure;
%   stringart('Sides', 4, 'Crossed', 1, 'Density', 60, 'Color', [0.8 0 0]);
%   title('Crossed String Art on a Square');
%
%   Notes
%   -----
%   - The drawing is progressive: each line segment is plotted with a
%     short pause, so the pattern appears gradually on the screen,
%     imitating manual string art.
%   - The function uses basic MATLAB graphics and should work on many
%     MATLAB releases.
%
%   Recognition
%   -----------
%   This function was selected as "Pick of the Week" by the MathWorks
%   Editor Team in August 2018. For historical reference, see:
%
%     https://blogs.mathworks.com/pick/2018/08/03/string-art-2/
%     https://blogs.mathworks.com/pick/2018/08/10/string-art/
%
%   These articles describe the mathematical intuition behind the routine
%   and its creative applications.
%
%   Citation
%   --------
%   If you use this function in academic or technical work, please cite:
%
%     Cardillo G. (2018)
%     "Stringart: Play with geometry and Bézier''s quadratic curve".
%     Available from GitHub:
%     https://github.com/dnafinder/stringart
%
%   Metadata
%   --------
%   Author : Giuseppe Cardillo
%   Email  : giuseppe.cardillo.75@gmail.com
%   GitHub : https://github.com/dnafinder
%   Created: 2018-01-01
%   Updated: 2025-11-20
%   Version: 2.0.0
%
%   License
%   -------
%   This function is distributed under the MIT License.
%   See the LICENSE file in the GitHub repository for details.
%

% ---------------------------
% Input parsing and checking
% ---------------------------
p = inputParser;
addParameter(p,'Sides',3, @(x) validateattributes(x,{'numeric'}, ...
    {'scalar','real','finite','integer','>=',3,'nonnan','nonempty'}));
addParameter(p,'Crossed',0, @(x) validateattributes(x,{'numeric'}, ...
    {'scalar','real','finite','integer','>=',0,'<=',1,'nonnan','nonempty'}));
addParameter(p,'Density',40, @(x) validateattributes(x,{'numeric'}, ...
    {'scalar','real','finite','integer','>=',10,'nonnan','nonempty'}));
addParameter(p,'Color',[0 0 0], @(x) validateattributes(x,{'numeric'}, ...
    {'row','real','finite','ncols',3,'>=',0,'<=',1,'nonnan','nonempty'}));
parse(p,varargin{:});

nSides  = p.Results.Sides;
crossed = p.Results.Crossed;
nPins   = p.Results.Density;
col     = p.Results.Color;

% ---------------------------
% Figure and axes settings
% ---------------------------
hold on
axis square
set(gcf,'Color','white');
set(gca,'XColor','w','YColor','w');

% ---------------------------
% Build base side / bisector
% ---------------------------
% Preallocate coordinate matrices:
% rows    -> pins along each side
% columns -> polygon sides (1..nSides+1, last column closes polygon)
MX = zeros(nPins, nSides+1);
MY = MX;

switch crossed
    case 0
        % Pins along the side from (0,0) to (1,0)
        % mp: middle point of the side (used to find incenter)
        mp = 0.5;
        h  = mp * tan(pi*(0.5 - 1/nSides));  % apothem (incenter distance)
        MX(:,1) = linspace(0,1,nPins)';      % x-coordinates of first side
        % MY(:,1) is already zeros
    case 1
        % Pins along the internal bisector from vertex to midpoint
        mp = linspace(0,0.5,nPins);          % middle points
        h  = mp .* tan(pi*(0.5 - 1/nSides)); % corresponding heights
        MX(:,1) = mp';                       % x-coordinates
        MY(:,1) = h';                        % y-coordinates
end

% ---------------------------
% Rotate base to all sides
% ---------------------------
% Rotate around the incenter by angle k for each side
k      = (2*pi)/nSides;
base   = [MX(:,1)'; MY(:,1)'];  % base side/bisector coordinates
center = [mp(end); h(end)];     % incenter (rotation center)

for I = 1:nSides
    theta = k*I;
    Rot   = [cos(theta) -sin(theta); ...
             sin(theta)  cos(theta)];
    t = Rot * (base - center) + center;
    MX(:,I+1) = t(1,:)';
    MY(:,I+1) = t(2,:)';
end

% ---------------------------
% Connect pins (progressive)
% ---------------------------
L = size(MX,1);  % number of pins (rows)

for I = crossed:L-1
    for J = 1:nSides
        switch crossed
            case 0
                % Connect along the perimeter
                plot([MX(I+1,J)   MX(I+1,J+1)], ...
                     [MY(I+1,J)   MY(I+1,J+1)], ...
                     'Color',col);
            case 1
                % Connect across bisectors (crossed chords)
                plot([MX(I+1,J)     MX(L+1-I,J+1)], ...
                     [MY(I+1,J)     MY(L+1-I,J+1)], ...
                     'Color',col);
        end
        pause(0.05); % progressive drawing, as in the original implementation
    end
end

hold off
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

end
