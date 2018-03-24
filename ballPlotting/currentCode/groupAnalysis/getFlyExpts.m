function flies = getFlyExpts(prefixCode)

switch prefixCode
    case 'Males'
        flies = {'Males',1,1,1;'Males',1,2,1;'Males',1,3,1;'Males',1,4,1;'Males',1,5,1};
    case 'Diag'
        flies = {'Diag',1,1,2;'Diag',1,3,1;'Diag',1,4,1;'Diag',1,5,4;'Diag',1,6,1};
    case 'Freq'
        flies = {'Freq',2,1,1;'Freq',2,2,1;'Freq',2,3,1;'Freq',2,4,2;'Freq',2,5,1;'Freq',2,6,1;'Freq',2,7,1};
    case 'Cardinal'
        flies = {'Cardinal',4,1,1;'Cardinal',4,2,2;'Cardinal',4,3,1;'Cardinal',4,4,2;'Cardinal',4,5,3};
    case 'ShamGlued-0'
        flies = {'ShamGlued',1,1,1;'ShamGlued',1,2,1};
    case 'ShamGlued-45'
        flies = {'ShamGlued',1,1,2;'ShamGlued',1,2,2};
    case 'RightGlued'
        flies = {};
    case 'Left Glued'
        flies = {};
end