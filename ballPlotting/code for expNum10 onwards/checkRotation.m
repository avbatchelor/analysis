function checkRotation(groupedData,R,stimNumInd)

count = 0;
for j = stimNumInd
    count = count+1;
    rotVel(count,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
    rotDisp(count,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
    xDisp(count,:) = groupedData.xDisp{j};
    yDisp(count,:) = groupedData.yDisp{j};
    xVel(count,:) = groupedData.xVel{j};
    yVel(count,:) = groupedData.yVel{j}; 
end

rotXDisp = squeeze(rotDisp(:,1,:));
rotYDisp = squeeze(rotDisp(:,2,:));
rotXVel = squeeze(rotVel(:,1,:));
rotYVel = squeeze(rotVel(:,2,:));

figure(2); 
hold on 
plot(mean(xDisp),mean(yDisp))
plot(mean(rotXDisp),mean(rotYDisp),'r')

figure(3); 
hold on 
plot(mean(xVel))
plot(mean(rotXVel),'r')

figure(4); 
hold on 
plot(mean(yVel))
plot(mean(rotYVel),'r')

