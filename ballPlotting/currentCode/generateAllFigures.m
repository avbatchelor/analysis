function generateAllFigures

% Fig 2
multiFlyAnalysis('Freq','n','n','y','y')

% Fig 3 
multiFlyAnalysis('Males','y','n','n','y')
multiFlyAnalysis('Males','n','n','n','y')

% Fig 4
multiFlyAnalysis('a2Glued','y','n','n','y')
multiFlyAnalysis('a3Glued','y','n','n','y')
multiFlyAnalysis('ShamGlued-45','y','n','n','y','ShamGlued-45')
multiFlyAnalysis('ShamGlued-45','n','n','n','y','ShamGlued-45-just-mean')

% Fig 5 - Trial to trial variability

% Fig 6
multiFlyAnalysis('RightGlued','y','n','n','y')
multiFlyAnalysis('LeftGlued','y','n','n','y')
multiFlyAnalysis('ShamGlued-0','y','n','n','y','ShamGlued-0')
             
% Fig 7 
multiFlyAnalysis('Diag','y','n','n','y','allFlies')
multiFlyAnalysis('Diag','n','n','n','y','justMean')

% Fig 8
multiFlyAnalysis('Cardinal','y','n','n','y','allFlies')
multiFlyAnalysis('Cardinal','n','n','n','y','justMean')
