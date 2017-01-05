function save_pushbutton_callback(src,event,filename)
   fileStem = char(regexp(filename,'.*(?=.fig)','match'));
   newFilename = [fileStem,'_zoom',num2str(1,'%03d'),'.pdf'];
   count = 0;
   while exist(newFilename,'file')
       count = count + 1; 
       newFilename = [fileStem,'_zoom',num2str(count,'%03d'),'.pdf'];
   end
   mySave(newFilename);
end
