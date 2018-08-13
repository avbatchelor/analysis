function fig8QuantVel(maleMeanLatVel, maleMeanVelChange, femaleMeanLatVel, femaleMeanVelChange)

%% Anova on lat velocity
y = [maleMeanLatVel',femaleMeanLatVel'];
p = anova1(y);

disp('ANOVA on lat velocity')
disp(['p = ',num2str(p)])


%% Anova on change in forward vel
y = [maleMeanVelChange',femaleMeanVelChange'];
p = anova1(y);

disp('ANOVA on forward velocity change')
disp(['p = ',num2str(p)])

%%

% [h,p] = jbtest(differences);
% disp('Jarque-Bera test')
% disp(['h = ',num2str(h),', p = ',num2str(p)])

% [h,p] = ttest(differences,0,'Tail','both');
% disp('t-test')
% disp(['h = ',num2str(h),', p = ',num2str(p)])