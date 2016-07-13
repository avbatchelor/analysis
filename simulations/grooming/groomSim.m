%%%%%%%%%%%%%%%%%%%%%%%%%%
% hierarchical_suppression_computational_model

% This code will simulate dust-induced fly grooming behavior
%
%
% Original modeling and code by Primoz Ravbar
% March, 2013
%
% Unilateral inhibition implementation and code by Brett Mensh
% June, 2013
%
% Expanded and edited by Primoz Ravbar
% July, 2013
%
% Tidied up code AVB 07/13/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
function groomSim(modelType)

%% Specify model parameters
numb_of_segments=4; % how many cleaning modules? Current model uses 4

threshold_range = [0.0 0.0]; % sensory threshold difference not used in the current model

dust_amount=1; % this is the initial dust that is on the fly. Default = 1, meaning fully dusty fly. Use 0 to simulate constitutive cleaning without dust.
dust_homo=10; % how homogeneous is the dust? 1 means random amount of dust; 10 means that the dust varies randomly within the upper 10% while 90% of the body is fully covered

clean_incr=0.08; %how much dust is taken off of a body part in each "cleaning iteration" or "wipe"

numIterations = 2000; 
num_front_segments = 2;

switch modelType
    case 'SGM'
        % set sensory gain here (for SGM):
        %sensory_gain=[0.5 0.4 0.3 0.2 0.1]; %used these weights for the sensory gain part
        %of Figure 4 (Figure 4C) %only use for 5 segment model (5 cleaning modules)
        % the following line should be used for arbitrary number of segments (cleaning modules):
        sensory_gain_range = [3.0 1.0];
        sensory_gain = linspace(sensory_gain_range(1),sensory_gain_range(2),numb_of_segments);
        weight_unilateral_inh=0.0;      % no unilateral inhibition
    case 'UIM'
        sensory_gain_range = [1.0 1.0]; % sensory gain equal across modules
        sensory_gain = linspace(sensory_gain_range(1),sensory_gain_range(2),numb_of_segments);
        weight_unilateral_inh=-0.5;     % as in Fig 4D
end

%%%%%%%%%%%%% INCLUDE LEG RUBBING %%%%%%%%%%%%%%%%%%%%%%%%%
numb_of_leg_pairs =2; % how many pairs of legs; current model uses 2 pairs of legs involved in grooming

leg_gain=30; % set sensitivity of legs to dust (sensory gain of legs); in the current model it is set at 30
dust_removed_leg_rub=0.08; % the fraction of dust removed from legs with every leg rub;

dust_added_to_leg=0.08; % the fraction of dust added to legs as they clean the body, per stroke.
%dust_added_to_leg=0.00; % select this line to simulate the model without
%involvment of legs
threshold_leg = 0.00; % in current model threshold is set to zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% SET CONSTITUTIVE ACTIVATION OF A CLEANING MODULE %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the module for constitutive activation (1-5). Works only for a 5
% segment model. Use 0 for no constitutive activation.
gal = 0;

%%%%%%%%%%%%%%%% END OF USER PARAMETER SETTING %%%%%%%%%%%%%%%%%%%%%

%% Initialize model
% Set dust levels for first time step
for i=1:numb_of_segments;
    dust_mat(i,1)=10.*(dust_amount-((dust_amount*rand)/dust_homo)); % Not sure what the multiplication by 10 is for
end

for i=1:numb_of_leg_pairs;
    threshold_record_leg(i,1)=threshold_leg; % currently 0
    dust_amount_record_leg(i,1)=0;
    activity_record_leg(i,1)=dust_amount_record_leg(i,1)-threshold_record_leg(i,1); % currently 0
end

sensory_threshold = linspace(threshold_range(1),threshold_range(2),numb_of_segments)'; %0

%% Select module for constitutive activation
switch gal
    case 0
        fly_type='wild-type';
    case 1
        fly_type='GAL-eyes';
    case 2
        fly_type='GAL-antennae';
    case 3
        fly_type='GAL-abdomen';
    case 4
        fly_type='GAL-wings';
    case 5
        fly_type='GAL-thorax';
end

%% construct the inhibitory weight matrix wij for UIM implementation
w=weight_unilateral_inh;

for m=1:numb_of_segments;
    for n=1:numb_of_segments;
        if m > n; 
            wij(m,n)=0;
        end
        if m == n; 
            wij(m,n)=1;
        end
        if m < n; 
            wij(m,n)=w;
        end
    end
end

%% Main loop
i=0;
while i<2000 % runs for 2000 iterations
    i=i+1;
    
    % Sensory level
    sensory_input = (dust_mat(:,i)'.*sensory_gain) - sensory_threshold'; % activation level = dust level x sensory gain
    
    % Hierarchical level 
    hier_out = sensory_input*wij;  % sensory input times the synaptic weight matrix for UDM implementation
    hier_out_mat(1:numb_of_segments,i)=hier_out'; 

    % Winner-take-all level
    [winner_level,winner_ind] = max(hier_out);  % select the winner
    if winner_level < 0 % stop if the winner's activation level is negative
        break
    end
    hier_out(hier_out<0)=0; % Prevent negative activation from occurring
    
    %% Leg rubbing
    % Select which legs are used
    if winner_ind <  num_front_segments; 
        m=1; % if the anterior modules are active set m = 1 for front legs;
    else
        m=2; % if posterior modules are active set m = 2;
    end 
        
    %% Update dust levels
    % Remove dust from winning module
    dust_mat(1:numb_of_segments,i+1)=dust_mat(1:numb_of_segments,i);
    dust_mat(winner_ind,i+1)=dust_mat(winner_ind,i+1)-clean_incr;
    
    % Add dust to appropriate legs 
    dust_amount_record_leg(:,i+1)=dust_amount_record_leg(:,i);
    dust_amount_record_leg(m,i+1)=dust_amount_record_leg(m,i+1) + dust_added_to_leg;
    
    % Prevent leg dust moving out of range between 0 and 1. 
    dust_amount_record_leg(dust_amount_record_leg<0)=0;
    dust_amount_record_leg(dust_amount_record_leg>1)=1;
    
    % Calculate leg activity
    activity_record_leg(m,i)=dust_amount_record_leg(m,i)*leg_gain;
    
    % Find the max leg activity
    max_activity_leg = max(activity_record_leg(:,i));
    
    % Find the max other module activity
    max_activity = max(hier_out_mat(:,i));
    
    % Groom legs if:
    % Dust on the legs 
    % Legs corresponding to most active module are most active leg set
    % Legs more active than max module 
    if dust_amount_record_leg(m,i) > threshold_record_leg(m,1)... 
            && activity_record_leg(m,i) == max_activity_leg...
            && max_activity < max_activity_leg;
        
        % Remove dust from leg i.e. groom
        dust_amount_record_leg(m,i+1)=dust_amount_record_leg(m,i )- dust_removed_leg_rub;
        % Make sure dust level doesn't go below 0
        dust_amount_record_leg(dust_amount_record_leg<0)=0;
        
        % Set those legs as the winner
        winmat(1:numb_of_segments,i)=zeros(numb_of_segments,1);
        winmat(numb_of_segments + m,i)=1;
    else
        % Set winning module as winner
        winmat(1:numb_of_segments,i)=zeros(numb_of_segments,1);
        winmat(winner_ind,i)=1;
    end
    
    %% Implement consitutive activation
    if gal>0  % if this is not a wild-type fly
        dust_mat(gal,i+1)=10;  % Set this modules dust level to the max = 10
    end
    
end  % end of main loop

%% Display num iterations 
disp(['There were ' num2str(i) ' iterations on the ' fly_type, ' fly'])

%% Plot ethogram
for i=1:size(winmat,1);
    eth(i,:)=winmat(i,:)*(size(winmat,1)+1-i);
end
ethogram_total=eth;

figure;
imagesc(ethogram_total)

end

