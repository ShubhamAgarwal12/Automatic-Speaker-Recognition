function writeHTK(outfile,e)
% Write data into HTK format
% outfile: file name
% e: data matrix
% Written by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

dtfile=fopen(outfile,'wb','b');

% header
fwrite(dtfile,size(e,2),'integer*4');       % nSamples
fwrite(dtfile,100000,'integer*4');          % sampPeriod = 10ms
fwrite(dtfile,size(e,1)*4,'integer*2');     % sampSize
fwrite(dtfile,9,'integer*2');               % parmKind = usr_defined

% write data
for i=1:size(e,2)
for j=1:size(e,1)    
    fwrite(dtfile,e(j,i),'real*4');
end
end

fclose(dtfile);