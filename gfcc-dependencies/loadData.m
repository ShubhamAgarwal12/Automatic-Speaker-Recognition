function [d]= loadData(file, ext)
% Read an HTK-format feature file
% file: file name
% ext: file extension without '.'
% Written by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

htkFile = sprintf('%s.%s', file, ext);
fid=fopen(htkFile,'r','b');
if fid < 0
   error(sprintf('Cannot read from file %s', htkFile));
end
fprintf(1, '\nloading feature file %s, ...', htkFile);
nf=fread(fid,1,'int32'); %long  numSamples
fp=fread(fid,1,'int32')*1.E-7; %long  sampPeriod
by=fread(fid,1,'int16'); %short  sampSize -- 4 bytes per sample * number of components
tc=fread(fid,1,'int16'); %short  parmKind
hb=floor(tc*pow2(-14:-6));
hd=hb(9:-1:2)-2*hb(8:-1:1);
dt=tc-64*hb(9);

% hd(7)=1 CRC check
% hd(5)=1 compressed data

if ( dt == 0 ),
  d=fread(fid,Inf,'short');
else,
  d=fread(fid,[by/4,nf],'float').';
end;
fclose(fid);
if nargout > 2
   hd(7)=0;
   hd(5)=0;
   ns=sum(hd);
   kinds=['WAVEFORM  ';'LPC       ';'LPREFC    ';'LPCEPSTRA ';'LPDELCEP  ';'IREFC     ';'MFCC      ';'FBANK     ';'MELSPEC   ';'USER      ';'DISCRETE  ';'???       '];
   kind=kinds(min(dt+1,12),:);
   cc='ENDACZK0';
   t=[kind(1:min(find(kind==' '))-1) reshape(['_'*ones(1,ns);cc(hd>0)],1,2*ns)];
end
d = d';
d = d(:, 1:end);
[chnNum frmNum] =  size(d);
fprintf(1, '%d frames done.\n', frmNum);
