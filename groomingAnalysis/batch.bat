for %%a in ("*.avi*") do "C:\Program Files (x86)\mmpeg\ffmpeg-20160517-git-af3e944-win64-static\ffmpeg-20160517-git-af3e944-win64-static\bin\ffmpeg" -i "%%a" -vcodec cinepak "C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids\%%~na.mov"

