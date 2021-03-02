function gwdrawpolicy(Policy, varargin)
% GWDRAWPOLICY draws the policy of the gridworld as an arrow in each state,
% pointing in the direction to move from that state. This should be used
% together with gwdraw. If the policy "P" is provided to the gwdraw
% function, GWDRAWPOLICY will be called automatically.
%
% Example:
%     P = getpolicy(Q);
%     gwdraw();
%     GWDRAWPOLICY("Policy", P);
%
% Optional name-value inputs:
%     "Policy"     - The policy matrix, i.e. the optimal action for each
%                    state. If this is passed to the function the policy is
%                    plotted as a vector field on top of the reward map.
%                    You should use this for the report images.
%     "ArrowStyle" - Value should be a string, options ["Pretty", "Fast"].
%                    Pretty arrows look nicer but are slower to draw. If
%                    you want to see the agent "walk" in the world, i.e.
%                    plot every step, we recommend using the fast arrow
%                    style to make it a bit faster.
%     "ArrowColor" - As the name suggests, the color of the policy arrows.
%                    Can for example be useful if you want to plot the
%                    policy in one color, and the path the agent walks in
%                    another color, which might be nice for world 4 (hint).
%                    To plot the path, use the gwplotarrow function.
%
% See also: gwdraw, gwplotarrow

% Parse optional inputs
DEFAULT_ARROW_STYLE = 'Pretty';
DEFAULT_ARROW_COLOR = 'r';
Parser = inputParser();
addRequired(Parser, 'Policy', @isnumeric);
addParameter(Parser ,'ArrowStyle', DEFAULT_ARROW_STYLE, @(x) isstring(x) || ischar(x));
addParameter(Parser ,'ArrowColor', DEFAULT_ARROW_COLOR, @ischar);
parse(Parser, Policy, varargin{:});

% Load global variables
global GWXSIZE;
global GWYSIZE;
global GWFEED;
global GWTERM;

if (strcmp(Parser.Results.ArrowStyle, 'Fast'))
    % Using Matlab built-in function (looks worse but is faster)
    [MX,MY] = meshgrid(1:GWXSIZE, 1:GWYSIZE);
    VALID = (GWTERM==0) & ~isnan(GWFEED);
    U = ((Policy==3)-(Policy==4)) .* double(VALID);
    V = ((Policy==1)-(Policy==2)) .* double(VALID);
    quiver(MX,MY,U,V, 'AutoScaleFactor', 0.45, 'Color', Parser.Results.ArrowColor, 'LineWidth', 1);
    scatter(MX(U==0 & V==0 & VALID), MY(U==0 & V==0 & VALID), [Parser.Results.ArrowColor, '.']);
elseif (strcmp(Parser.Results.ArrowStyle, 'Pretty'))
    % Using custom arrows (looks nicer but is slower)
    for x = 1:GWXSIZE
        for y = 1:GWYSIZE
            if ~GWTERM(y,x) && ~isnan(GWFEED(y,x))
                gwplotarrow([y x], Policy(y, x), 'Color', Parser.Results.ArrowColor);
            end
        end
    end
end

end

