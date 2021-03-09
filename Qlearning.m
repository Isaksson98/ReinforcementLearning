%% Initialization
%  Initialize the world, Q-table, and hyperparameters

world = 4;
state = gwinit(world);
gwdraw();

actions = [1 2 3 4]; %1=down, 2=up, 3=right and 4=left

state_size_y = state.ysize;
state_size_x = state.xsize;
action_size = length(actions);
Q = -1 + 2*rand(state_size_y,state_size_x,action_size);

%Hyperparameters
episodes = 2000;
epsilon = 0.5;  %   exploration factor
learningRate = 0.4;
gamma = 0.8;        %discount factor
prob_a = ones(1,length(actions))/length(actions); %uniform probability

%% Training loop
%  Train the agent using the Q-learning algorithm.

for episode = 1:episodes
    %initiate new rndm start pos
    gwinit(world);
    state = gwstate();
    while state.isterminal~=1 %Run until agent reaches goal 
        
        state_y = state.pos(1);
        state_x = state.pos(2);
        prev_state = gwstate(); %save previous state in case we want to go back
        [a, oa] = chooseaction(Q, state_y, state_x, actions, prob_a, epsilon);
        
        state = gwaction(a);
        state_y_next = state.pos(1);
        state_x_next = state.pos(2);
        r = state.feedback;         %reward
        V = getvalue(Q);
        
        
       if state_y_next > state.ysize || state_y_next < 0 || state_x_next > state.xsize || state_x_next < 0  
           r = -inf;
           state = prev_state;
           disp('----------------------')
           disp(state_y_next)
           disp(state_x_next)
           disp(state)
      end
       
       Q(state_y,state_x, a) = (1-learningRate)*Q(state_y,state_x, a)...
            + learningRate*(r + gamma*V(state_y_next,state_x_next));
       
       
    end
end


%% Test loop
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0; always pick
%  the optimal action.

gwinit(world);
state = gwstate()
while state.isterminal~=1 %Run until agent reaches terminal 
    
    state_y = state.pos(1);
    state_x = state.pos(2);
	
    [a, oa] = chooseaction(Q, state_y, state_x, actions, prob_a, 0);
	state = gwaction(oa);
    gwdraw("Policy", getpolicy(Q))
end 

%P = getpolicy(Q);
%gwdrawpolicy(P)