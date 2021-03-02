function gwdraw(varargin)
% GWDRAW draws gridworld and agent. Use name-value arguments to also plot
% optinal information, such as the policy and episode, see below for more
% detatils.
%
% Example:
%     P = getpolicy(Q);
%     e = 10;
%     GWDRAW("Policy", P, "Episode", e);
%
% Optional name-value inputs:
%     "Policy"     - The policy matrix, i.e. the optimal action for each
%                    state. If this is passed to the function the policy is
%                    plotted as a vector field on top of the reward map.
%                    You should use this for the report images.
%     "Episode"    - Episode number, a numeric scalar. Plots this number in
%                    the figure title. Nice for keeping track of progress
%                    during training.
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
% See also: getpolicy, gwdrawpolicy, gwdrawarrow

% Parse optional inputs
DEFAULT_POLICY  = NaN;
DEFAULT_EPISODE = NaN;
DEFAULT_ARROW_STYLE = 'Pretty';
DEFAULT_ARROW_COLOR = 'r';
Parser = inputParser();
addParameter(Parser ,'Policy', DEFAULT_POLICY, @isnumeric);
addParameter(Parser ,'Episode', DEFAULT_EPISODE, @(x) isnumeric(x) && isscalar(x));
addParameter(Parser ,'ArrowStyle', DEFAULT_ARROW_STYLE, @(x) isstring(x) || ischar(x));
addParameter(Parser ,'ArrowColor', DEFAULT_ARROW_COLOR, @ischar);
parse(Parser, varargin{:});

% Load global variables
global GWWORLD;
global GWXSIZE;
global GWYSIZE;
global GWPOS;
global GWFEED;
global GWTERM;
global GWNAME;

% Draw background and set format
cla;
hold on;
imagesc(GWFEED, 'AlphaData', ~isnan(GWFEED));
xlabel('X');
ylabel('Y');

% Set title
if (isnan(Parser.Results.Episode))
    title(sprintf('Feedback Map, World %i\n%s', GWWORLD, GWNAME));
else
    title(sprintf('Feedback Map, World %i\n%s\nEpisode %i', GWWORLD, GWNAME, Parser.Results.Episode));
end

% Create a gray rectangle for the robot
rectangle('Position',[GWPOS(2)-0.5, GWPOS(1)-0.5, 1, 1], 'FaceColor', [0.5,0.5,0.5]);

% If you want to see the color scale of the world you can uncomment this
% line. This will slow down the drawing significantly.
%colorbar;

% Green circle for the goal
for x = 1:GWXSIZE
  for y = 1:GWYSIZE
    if GWTERM(y,x)
      radius = 0.5;
      rectangle('Position',[x-0.5, y-0.5, radius*2, radius*2],...
                'Curvature',[1,1],...
                'FaceColor','g');
    end
  end
end

% If you want to make the robot move slower (to make it easier to
% understand what it does) you can uncomment this line.
%pause(0.1);

if (~(isnan(Parser.Results.Policy) | isscalar(Parser.Results.Policy)))
    gwdrawpolicy(Parser.Results.Policy, 'ArrowStyle', Parser.Results.ArrowStyle, 'ArrowColor', Parser.Results.ArrowColor);
end

axis image;
axis ij;
drawnow;
end


