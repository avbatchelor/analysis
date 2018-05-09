function output = movingMode(input)

% Add padding to front and back of input
frontPad = repmat(mode(input(1:5)),[5,1]);
endPad = repmat(mode(input(end-5:end)),[5,1]);
paddedInput = [frontPad;input;endPad];

% Calculate sliding columns
slidingCols = im2col(paddedInput,[11 1],'sliding');

% Calculate mode 
output = mode(slidingCols)';

end