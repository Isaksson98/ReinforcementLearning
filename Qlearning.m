%% Initialization
%  Initialize the world, Q-table, and hyperparameters

world = 3;
state = gwinit(world);
gwdraw();

actions = [1 2 3 4]; %1=down, 2=up, 3=right and 4=left

state_size_y = state.ysize;
state_size_x = state.xsize;
action_size = length(actions);
Q = -1 + 2*rand(state_size_y,state_size_x,action_size);

%Hyperparameters
episodes = 1000;
epsilon = 0.1;  %   exploration factor
learningRate = 0.5;
gamma = 0.9;        %discount factor
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
        [a, oa] = chooseaction(Q, state_y, state_x, actions, prob_a, epsilon);
        
        state = gwaction(a);
        state_y_next = state.pos(1);
        state_x_next = state.pos(2);
        r = state.feedback;         %reward
        V = getvalue(Q);
        
        Q(state_y,state_x, a) = (1-learningRate)*Q(state_y,state_x, a)...
            + learningRate*(r + gamma*V(state_y_next,state_x_next));
       if ~state.isvalid
           Q(state_y,state_x, a) = -inf;
       end
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
    pause(0.1)

end 

%P = getpolicy(Q);
%gwdrawpolicy(P)