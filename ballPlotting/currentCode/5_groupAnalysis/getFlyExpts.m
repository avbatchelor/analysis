function flies = getFlyExpts(prefixCode)

switch prefixCode
    % Fig 1
    % n/a
    
    % Fig 2
    case 'Freq'
        flies = {'Freq',2,2,1;'Freq',2,4,2;'Freq',2,5,1;'Freq',2,6,1;'Freq',2,7,1};
        
    % Fig 3
    case 'Males'
        flies = {'Males',1,1,1;'Males',1,2,1;'Males',1,3,1;'Males',1,4,1;'Males',1,5,1};
    
    % Fig 4
    case 'a2Glued'
        flies = {'a2Glued',1,1,1;'a2Glued',1,2,1;'a2Glued',1,3,1;'a2Glued',1,4,1};
    case 'a3Glued'
%         flies = {'a3Glued',1,1,1;'a3Glued',1,2,1;'a3Glued',1,3,1;'a3Glued',1,4,1};
        flies = {'a3Glued',1,2,1;'a3Glued',1,3,1;'a3Glued',1,4,1};
    case 'ShamGlued-45'
        flies = {'ShamGlued',1,1,2;'ShamGlued',1,2,2;'ShamGlued',1,3,2;'ShamGlued',1,4,2};
    
    % Fig 5 
    % n/a
    
    % Fig 6
    case 'RightGlued'
        flies = {'RightGlued',1,1,1;'RightGlued',1,3,1;'RightGlued',1,6,1;'RightGlued',1,7,1;'RightGlued',1,9,1};
    case 'LeftGlued'
        flies = {'LeftGlued',1,1,1;'LeftGlued',1,2,2;'LeftGlued',1,4,1;'LeftGlued',1,7,1};
    case 'ShamGlued-0'
        flies = {'ShamGlued',1,1,1;'ShamGlued',1,2,1;'ShamGlued',1,3,1;'ShamGlued',1,4,1;'ShamGlued',1,5,1};
        
    % Fig 7 
    case 'Diag'
        flies = {'Diag',1,1,2;'Diag',1,3,1;'Diag',1,4,1;'Diag',1,5,4;'Diag',1,6,1};
%     case 'Diag'
%         flies = {'Diag',1,1,2;'Diag',1,3,1};
        
%     % Fig 8
    case 'Cardinal'
        flies = {'Cardinal',4,1,1;'Cardinal',4,2,2;'Cardinal',4,3,1;'Cardinal',4,4,2;'Cardinal',4,5,3};
    
%     case 'Cardinal'
%         flies = {'Cardinal',4,1,1;'Cardinal',4,4,2;'Cardinal',4,5,3};
    
    
end