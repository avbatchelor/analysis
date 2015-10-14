function [idx_img, traces, colorMat] = kmeansCorr(mov,frameRate,k)

% Clusters pixels in movie into k clusters based on how correlated pixels
% are over time

%% Remove pixels that have low std 
kmat = reshape(mov, [size(mov,1)*size(mov,2) size(mov,3)] );
stds = std(kmat,0,2);

figure
hist(stds,100)
xlabel('Std')
ylabel('Counts')
[cutoff,~] = ginput(1);
close all

highStdInd = find(stds>cutoff); 
kmat2 = kmat(highStdInd,:); 

%% Perfom kmeans 
[IDX] = kmeans( kmat2 , k ,'distance','correlation');

%% Plot cluster image 
IDX2(1:size(kmat,1),1) = k+1;
IDX2(highStdInd) = IDX; 

idx_img = reshape( IDX2, [ size(mov,1) size(mov,2) ]);

% figure;
% imagesc(idx_img);
% title('Kmeans clusters');
% lutbar

%% Plot mean traces for each cluster 
figure;
colormap jet;
cmap = colormap;
temp = linspace(1,size(cmap,1),k+1);
colorMat = cmap(floor(temp),:);
t = [0:size(mov,3)-1]./frameRate;
for i=1:k
    clustIdx = find(IDX2 == i);
    traces(i,:) = mean(kmat(clustIdx,:));
    hold on;
    plot(t, traces(i,:), 'color', colorMat(i,:) , 'DisplayName', ['Cluster: ' num2str(i)]);
end
title('Mean traces for each Kmeans cluster');

end