function ParforWafer(bgRoot,folderRoot,extension,inch,mode)
%%
% 搭配其子func (Wafer_Detect_nf)
% 搜尋目標資料夾中所有符合附檔名的圖片
% 全部丟入子func，以平行處裡進行運算
% 並在目錄下生成3組txt，分別為
% P.txt: 顆粒(particle)面積 質心座標Y 質心座標X          n*3
% D.txt: 磊缺(defect)面積 質心座標Y 質心座標X            n*3
% R.txt: 各區間particle的個數                           1*11
%       ~10 10~20 20~30 30~40 40~50 50~60 60~70 70~80 80~90 90~100 100~ (um)
%
% INPUT:
%     bgRoot - 背景圖片路徑(需含附檔名 ex.bmp)
%     folderRoot - 存放圖片之資料夾路徑
%     extension - 資料夾內目標圖片的副檔名(ex.bmp)
%
% OUTPUT:
%       無
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

fid = fopen('P.txt','wt');  %'at'為接續著寫 'wt'為覆寫
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
