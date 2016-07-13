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
% AVB 07/13/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear all;close all
 
%% Specify model parameters
% User: set the following parameters to simulate the grooming sequence
% model. The default setting includes leg rubbing and uses sensory gain
% implementation. 
 
numb_of_segments=4; % how many cleaning modules? Current model uses 4
 
threshold_range = [0.0 0.0]; % sensory threshold difference not used in the current model 
 
dust_amount=1; % this is the initial dust that is on the fly. Default = 1, meaning fully dusty fly. Use 0 to simulate constitutive cleaning without dust.
dust_homo=10; % how homogeneous is the dust? 1 means random amount of dust; 10 means that the dust varies randomly within the upper 10% while 90% of the body is fully covered
 
clean_incr=0.08; %how much dust is taken off of a body part in each "cleaning iteration" or "wipe"
 
%% 
%%%%%%%%%%%% SET THE IMPLEMENTATION: UIM OR SGM %%%%%%%%%%%%%%%%
% set sensory gain here (for SGM):
%wii=[0.5 0.4 0.3 0.2 0.1]; %used these weights for the sensory gain part
%of Figure 4 (Figure 4C) %only use for 5 segment model (5 cleaning modules)
% the following line should be used for arbitrary number of segments (cleaning modules):
sensory_gain_range = [3.0 1.0];
wii = linspace(sensory_gain_range(1),sensory_gain_range(2),numb_of_segments); 
%use the range on the following line to make sensory gain accross the
%modules equal
%sensory_gain_range = [1.0 1.0];wii = linspace(sensory_gain_range(1),sensory_gain_range(2),numb_of_segments); 

 
% set unilateral inhibition here (for UIM):
%weight_unilateral_inh=-0.5; %used this value for the unilateral inhibition shown in Figure 4D - weights of unidirectional inhibitions (0 to -1)
weight_unilateral_inh=0.0; % weights of unidirectional inhibitions removed
 
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
ect_drive_module = 0;
 
 
%%%%%%%%%%%%%%%% END OF USER PARAMETER SETTING %%%%%%%%%%%%%%%%%%%%%

%% 
for i=1:numb_of_segments;
  dust_amount_record(i,1)=dust_amount-((dust_amount*rand)/dust_homo);
end
 
d=dust_amount_record*10; 
 
for i=1:numb_of_leg_pairs;
    threshold_record_leg(i,1)=threshold_leg;
end
 
 
for i=1:numb_of_leg_pairs;
  dust_amount_record_leg(i,1)=0;
end
 
 
 
for i=1:numb_of_leg_pairs;
   activity_record_leg(i,1)=dust_amount_record_leg(i,1)-threshold_record_leg(i,1);
end
 
 
 
%creates a vector of the threshold range for the number of segements
    
   threshold_initial = linspace(threshold_range(1),threshold_range(2),numb_of_segments)';
   threshold_record = linspace(threshold_range(1),threshold_range(2),numb_of_segments)';
 
 
% Select module for constitutive activation
for gal=ect_drive_module:ect_drive_module;
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
    
 
  
    
    
       % construct the inhibitory weight matrix wij for UIM implementation
         w=weight_unilateral_inh; 
                
          for m=1:numb_of_segments; 
              for n=1:numb_of_segments;
                  if m > n; wij(m,n)=0;end;
                  if m == n; wij(m,n)=1;end;
                  if m < n; wij(m,n)=w;end;
              end;
          end
 
                wij_string='uptri';  
 
        dustmat=d; %this stores all the "dust levels" across all the iterations
        segment_record=zeros(1,numb_of_segments);
        weight_record=ones(numb_of_segments,1); % no self-excitation in current model; keep at 1
 
        
        %%%%%%%%%%%%%%% MAIN LOOP STARTS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
        i=0;
        sent=0;
%runs for 2000 iterations
        while sent~=99 & i<2000
            i=i+1;
            sensin=(dustmat(:,i)'.*wii) - threshold_record'; %this is activation level:the activity of the sensory neuron is the amount of dust times the sensory gain
            out=sensin*wij;  %sensory input times the synaptic weight matrix for UDM implementation
            [y,ind] = max(out);  % select the winner
            if y<0 % stop if the winner's activation level is negative
                sent=99;
            end
            
            out(out<0)=0;
            
            
            if ind <  numb_of_segments/2; l=1;end % set the index for legs; if the anterior modules are active set l = 1 for front legs; 
            if ind >= numb_of_segments/2; l=2;end % if posterior modules are actove set l = 2;
            
           
           %%%%%%%%%%% INCLUDE LEG RUBBING TO THE MODEL %%%%%%%%%%%%%% 
            %update all the data logs appropriately
            activitymat(1:numb_of_segments,i)=out';
           
            dustmat(1:numb_of_segments,i+1)=dustmat(1:numb_of_segments,i);
            dustmat(ind,i+1)=dustmat(ind,i+1)-clean_incr;
            
             dust_amount_record_leg(:,i+1)=dust_amount_record_leg(:,i);           
             dust_amount_record_leg(l,i+1)=dust_amount_record_leg(l,i+1) + dust_added_to_leg;
             dust_amount_record_leg(dust_amount_record_leg<0)=0;
             dust_amount_record_leg(dust_amount_record_leg>1)=1;
            
             activity_record_leg(l,i)=dust_amount_record_leg(l,i)*leg_gain;
            
             max_activity_leg=max(activity_record_leg(:,i)); % same as above for legs
             max_activity = max(activitymat(:,i));
            
 
              if dust_amount_record_leg(l,i) > threshold_record_leg(l,1) && activity_record_leg(l,i) == max_activity_leg && max_activity < max_activity_leg;
          
                dust_amount_record_leg(l,i+1)=dust_amount_record_leg(l,i )- dust_removed_leg_rub;
                dust_amount_record_leg(dust_amount_record_leg<0)=0;
                ethogram_max_activity(numb_of_segments+l,i+1)=1;
                
                winner(1,i)=numb_of_segments + l;
                winmat(1:numb_of_segments,i)=zeros(numb_of_segments,1); 
                winmat(numb_of_segments + l,i)=1;
                
              else
                  
               winner(1,i)=ind;
               winmat(1:numb_of_segments,i)=zeros(numb_of_segments,1); 
               winmat(ind,i)=1;
                
              end
  
            %%%%%%%%%% IMPLEMENT SENSORY DRIVE HERE %%%%%%%%%%%%  
 
            if gal>0  % if this is not a wild-type fly
               dustmat(gal,i+1)=10;  %then override the constitutive module's actual dust level to a constant dust level of maximum (10) on the next round
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
 
            winner(:,1:i);
            winmat(:,1:i);
            dustmat(:,1:i+1);
 
        end  %%%%%%THIS IS THE END OF THE MAIN LOOP%%%%
 
        disp(['there were ' num2str(i) ' iterations on the ' fly_type ' , ' wij_string ' run'])
 
end 
 
%% MAIN OUTPUT OF THE MODEL
% This is the ethogram: rows: "active cleaning module"; cols: "time"; 
% The bottom 2 rows represent the front and back leg rubbing if
% implemented
ethogram_binary=winmat; 

%% Plot ethogram
for i=1:size(ethogram_binary,1);
    eth(i,:)=ethogram_binary(i,:)*(size(ethogram_binary,1)+1-i);
end
ethogram_total=eth;

figure;
imagesc(ethogram_total)
  




