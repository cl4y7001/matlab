function ParforWafer(bgRoot,folderRoot,extension,inch,mode)
%%
% �f�t��lfunc (Wafer_Detect_nf)
% �j�M�ؼи�Ƨ����Ҧ��ŦX���ɦW���Ϥ�
% ������J�lfunc�A�H����B�̶i��B��
% �æb�ؿ��U�ͦ�3��txt�A���O��
% P.txt: ����(particle)���n ��߮y��Y ��߮y��X          n*3
% D.txt: �U��(defect)���n ��߮y��Y ��߮y��X            n*3
% R.txt: �U�϶�particle���Ӽ�                           1*11
%       ~10 10~20 20~30 30~40 40~50 50~60 60~70 70~80 80~90 90~100 100~ (um)
%
% INPUT:
%     bgRoot - �I���Ϥ����|(�ݧt���ɦW ex.bmp)
%     folderRoot - �s��Ϥ�����Ƨ����|
%     extension - ��Ƨ����ؼйϤ������ɦW(ex.bmp)
%
% OUTPUT:
%       �L
%%
tic
data_particle=[];
data_defect=[];
folder=strcat(folderRoot,'*.bmp');
folder = dir(folder);
length(folder);
R=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
parfor(n=1:length(folder))
    range=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    imRoot=strcat(folderRoot,folder(n).name);
    remainder = folder(n).name
    [L,remainder] = strtok(remainder,'_'); 
    remainder = strrep(remainder,'_','')
    [N,remainder] = strtok(remainder,'.'); 
    L=str2num(L);
    N=str2num(N);
    
    [particle, defect,range]=Wafer_Detect_nf(bgRoot,imRoot,L,N,inch,mode);
    if (length(range)~=21)
        range=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    end
    R=R+range;
    if ~isempty(particle)
        data_particle=[data_particle; particle];
    end
    if ~isempty(defect)
        data_defect=[data_defect; defect];
    end
end

fid = fopen('P.txt','wt');  %'at'������ۼg 'wt'���мg
matrix=data_particle;                  
[m,n]=size(matrix);
 for i=1:1:m
   for j=1:1:n
      if j==n
        fprintf(fid,'%g\n',matrix(i,j));
     else
       fprintf(fid,'%g\t',matrix(i,j));
      end
   end
 end
fclose(fid);


fid = fopen('D.txt','wt');
matrix=data_defect;                  
[m,n]=size(matrix);
 for i=1:1:m
   for j=1:1:n
      if j==n
        fprintf(fid,'%g\n',matrix(i,j));
     else
       fprintf(fid,'%g\t',matrix(i,j));
      end
   end
 end
fclose(fid);

fid = fopen('R.txt','wt');
matrix=R;                  
[m,n]=size(matrix);
 for i=1:1:m
   for j=1:1:n
      if j==n
        fprintf(fid,'%g\n',matrix(i,j));
     else
       fprintf(fid,'%g\t',matrix(i,j));
      end
   end
 end
fclose(fid);

toc
console = 'end'
