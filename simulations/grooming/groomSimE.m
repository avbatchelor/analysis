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
function groomSimE(modelType,gal,leg_gain,sensory_gain_max,dust_incr,weight_unilateral_inh)

close all;

%% Specify model parameters
labels = {'head','abdomen','wings','thorax','front legs','back legs'};
num_mod=4; % how many cleaning modules? Current model uses 4

dust_amount=10; % initial dust on fly. 1 = fully dusty fly. Use 0 to simulate constitutive cleaning without dust.

%dust_incr=0.08; %how much dust is taken off of a body part in each "cleaning iteration" or "wipe"

numIterations = 2000; 

switch modelType
    case 'SGM'
        % set sensory gain here (for SGM):
        %sensory_gain=[0.5 0.4 0.3 0.2 0.1]; %used these weights for the sensory gain part
        %of Figure 4 (Figure 4C) %only use for 5 segment model (5 cleaning modules)
        % the following line should be used for arbitrary number of segments (cleaning modules):
        %sensory_gain_max = 3;
        sensory_gain_range = [sensory_gain_max 1.0];
        sensory_gain = linspace(sensory_gain_range(1),sensory_gain_range(2),num_mod);
        weight_unilateral_inh=0.0;      % no unilateral inhibition
    case 'UIM'
        sensory_gain_range = [1.0 1.0]; % sensory gain equal across modules
        sensory_gain = linspace(sensory_gain_range(1),sensory_gain_range(2),num_mod);
        %weight_unilateral_inh=-0.5;     % as in Fig 4D
end

%%%%%%%%%%%%% INCLUDE LEG RUBBING %%%%%%%%%%%%%%%%%%%%%%%%%
num_leg_mods =2; % how many pairs of legs; current model uses 2 pairs of legs involved in grooming

%leg_gain=30; % sensory gain of legs - set to 0 to remove legs from model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% SET CONSTITUTIVE ACTIVATION OF A CLEANING MODULE %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the module for constitutive activation (1-5). Works only for a 5
% segment model. Use 0 for no constitutive activation.
%gal = 5;

%%%%%%%%%%%%%%%% END OF USER PARAMETER SETTING %%%%%%%%%%%%%%%%%%%%%

%% Initialize model
% Set dust levels for first time step
for i=1:num_mod;
    dust_record(i,1)=dust_amount; % Not random
end

for i=1:num_leg_mods;
    dust_record_leg(i,1)=0; % currently 0
end

%% Select module for constitutive activation
switch gal
    case 1
        fly_type='GAL-head';
    case 2
        fly_type='GAL-abdomen';
    case 3
        fly_type='GAL-wings';
    case 4
        fly_type='GAL-thorax';
    case 5 
        fly_type='wild-type';
end

%% construct the inhibitory weight matrix wij for UIM implementation
w=weight_unilateral_inh;

wij = zeros(num_mod,num_mod);
for p=1:num_mod;
    for n=1:num_mod;
        if p == n; 
            wij(p,n)=1;
        end
        if p < n; 
            wij(p,n)=w;
        end
    end
end

%% Main loop
i=0;
while i<2000 % runs for 2000 iterations
    i=i+1;
    
    %% Calculate activity levels for body modules
    % Sensory level
    sensory_input = (dust_record(:,i)'.*sensory_gain); % activation level = dust level x sensory gain
    
    % Hierarchical level 
    hier_out = sensory_input*wij;  % sensory input times the synaptic weight matrix for UDM implementation

    % Winner-take-all level
    [winner_level,winner_ind] = max(hier_out);  % select the winner
    if winner_level <= 0 % stop if the winner's activation level is negative
        break
    end
    hier_out(hier_out<0)=0; % Prevent negative activation from occurring
    activity_record(1:num_mod,i)=hier_out'; 

    %% Calculate activity levels for legs
    % Calculate leg activity
    activity_record_leg(:,i)=dust_record_leg(:,i).*leg_gain;
    
    % Find the max leg activity
    [leg_winner_level,leg_winner_ind] = max(activity_record_leg(:,i));

    %% Leg rubbing
    % Select which legs are used if body module wins
    if winner_ind <  num_leg_mods; 
        m=1; % if the anterior modules are active set m = 1 for front legs;
    else
        m=2; % if posterior modules are active set m = 2;
    end 
        
    %% Update dust levels    
    % Before removing dust, set new dust levels to be the same as previous
    % time step
    dust_record(1:num_mod,i+1)=dust_record(1:num_mod,i);
    dust_record_leg(:,i+1)=dust_record_leg(:,i);
            
    % Remove dust
    if winner_level < leg_winner_level; % If legs win - no longer depends on which body module wins
        % Remove dust from leg i.e. groom
        dust_record_leg(leg_winner_ind,i+1)=dust_record_leg(leg_winner_ind,i )- dust_incr;
        
        % Make sure dust level doesn't go below 0
        dust_record_leg(dust_record_leg<0)=0;
        
        % Set those legs as the winner
        winmat(1:num_mod,i)=zeros(num_mod,1);
        winmat(num_mod + leg_winner_ind,i)=1;
        
    else % non-leg module won
        if winner_ind ~= gal % Do nothing if there is constitutive activation
            % Remove dust from winning module
            dust_record(winner_ind,i+1)=dust_record(winner_ind,i+1)-dust_incr;

            % Add dust to appropriate legs 
            dust_record_leg(m,i+1)=dust_record_leg(m,i+1) + dust_incr;

            % Make sure module dust doesn't go below 0
            dust_record(dust_record<0)=0;
        end
        
        % Set winning module as winner
        winmat(1:num_mod,i)=zeros(num_mod,1);
        winmat(winner_ind,i)=1;
    end
    
end  % end of main loop

%% Display num iterations 
disp(['There were ' num2str(i) ' iterations on the ' fly_type, ' fly'])

%% Plot ethogram
% Give each row different numbers to produce different colours on ethogram
for i=1:size(winmat,1);
    ethogram(i,:)=winmat(i,:)*(size(winmat,1)+1-i);
end

figure;
setCurrentFigurePosition(2)
ax(1) = subplot(5,1,1);
imagesc(ethogram)
xlabel('Time step')
set(gca,'YTickLabel',labels)
load('MyColormaps')
set(gcf,'Colormap',jetWhiteBG)
set(gca,'Box','off','TickDir','out')

%% Plot dust levels 
color_ind = round(linspace(size(jetWhiteBG,1),1,num_mod + num_leg_mods+1));
ax(2) = subplot(5,1,2);
for i = 1:num_mod
    plot(dust_record(i,:)','Color',jetWhiteBG(color_ind(i),:))
    hold on 
end
ax(3) = subplot(5,1,3);
plot(dust_record_leg(1,:)','Color',jetWhiteBG(color_ind(num_mod+1),:))
ax(4) = subplot(5,1,4);
plot(dust_record_leg(2,:)','Color',jetWhiteBG(color_ind(num_mod+2),:))

%% Plot activity levels 
color_ind = round(linspace(size(jetWhiteBG,1),1,num_mod + num_leg_mods+1));
ax(5) = subplot(5,1,5);
hold on 
for i = 1:num_mod
    plot(activity_record(i,:)','Color',jetWhiteBG(color_ind(i),:))
end
plot(activity_record_leg(1,:)','Color',jetWhiteBG(color_ind(num_mod+1),:))
plot(activity_record_leg(2,:)','Color',jetWhiteBG(color_ind(num_mod+2),:))

linkaxes(ax(:),'x')
end

