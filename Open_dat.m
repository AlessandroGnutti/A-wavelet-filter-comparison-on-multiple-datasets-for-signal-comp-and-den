function Orig_Sig = Open_dat(filename)

% [filename, pathname] = uigetfile(name, 'Open file .dat');% only image Bitmap

fid=fopen(filename,'r');

time=10;
f=fread(fid,2*360*time,'ubit12');
fclose(fid);
Orig_Sig=f(1:2:length(f));