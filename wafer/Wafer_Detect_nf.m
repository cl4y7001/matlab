function [particle, defect,range]=Wafer_Detect_nf(bgRoot,imRoot,L,N,inch,mode) 
%%
% 修改紀錄:
%   Ver 取消貓眼、刮傷 2019/3/29 
%   最小抓取標準: 14 >> 30 (20um)
%   短軸空心程度 (1/2 >> 1)
%   defect: temp_area > 750 && temp_rl > 50
%  -----------------------------------------------------------------------
%  用於晶圓的瑕疵檢測
%  主要目的是找出磊缺(defect)
%  將ROI減去背景能有效消除系統髒汙及環境光不均之問題
%  抓出磊缺及顆粒後座標轉換為整片wafer之座標
%
% INPUT:
%     bgRoot - 背景圖片路徑
%     imRoot - ROI圖片路徑
%     L - 照片編號(行數)
%     N - 照片編號(個數)
%     inch - 幾英吋的wafer
%     mode - 全部掃描、十字掃描
%
% OUTPUT:
%     particle - 顆粒的面積(Ap)、質心座標(Cp)     at line195
%     defect - 磊缺的面積(Ad)、質心座標(Cd)       at line196(end)
%     range - 各區間particle的個數        at line194

%% 座標轉換表
% 4 inch
inch4Xtable=[35.3845625
50.10896375
64.833365
79.55776625
94.2821675
109.00656875
123.73097
138.45537125
153.1797725
167.90417375
182.628575
197.35297625
212.0773775
226.80177875
241.52618
256.25058125
270.9749825
285.69938375
300.423785
315.14818625
329.8725875
344.59698875
359.32139
374.04579125
388.94342075
403.49459375
418.218995
432.94339625
447.6677975
462.39219875
476.94337175
491.84100125
506.5654025
521.28980375
536.014205
550.73860625
565.4630075
580.18740875
594.91181
609.63621125
624.3606125
639.08501375
653.809415
668.53381625
683.2582175
697.98261875
712.70702
727.43142125
742.1558225
756.88022375
771.604625
786.32902625
801.0534275
815.77782875
830.50223];

inch4Y_oddtable=[336.62652885
300.04072245
263.45491605
239.06437845
214.67384085
190.28330325
178.08803445
165.89276565
141.50222805
129.30695925
117.11169045
104.91642165
104.91642165
92.72115285
80.52588405
80.52588405
68.33061525
68.33061525
56.13534645
56.13534645
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
43.94007765
56.13534645
56.13534645
68.33061525
68.33061525
80.52588405
80.52588405
92.72115285
104.91642165
104.91642165
117.11169045
129.30695925
141.50222805
165.89276565
178.08803445
190.28330325
214.67384085
239.06437845
263.45491605
300.04072245
336.62652885];


inch4Y_evetable=[531.75082965
568.33663605
604.92244245
629.31298005
653.70351765
678.09405525
690.28932405
702.48459285
726.87513045
739.07039925
751.26566805
763.46093685
763.46093685
775.65620565
787.85147445
787.85147445
800.04674325
800.04674325
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
812.24201205
800.04674325
800.04674325
787.85147445
787.85147445
775.65620565
763.46093685
763.46093685
751.26566805
739.07039925
726.87513045
702.48459285
690.28932405
678.09405525
653.70351765
629.31298005
604.92244245
568.33663605
531.75082965];

% 2 inch
inch2Xtable=[43.05236
72.5011625
101.949965
131.3987675
160.84757
190.2963725
219.745175
249.1939775
278.64278
308.0915825
337.540385
366.9891875
396.43799
425.8867925
455.335595
484.7843975
514.2332
543.6820025
573.130805
602.5796075
632.02841
661.4772125
690.926015
720.3748175
749.82362
779.2724225
808.721225];

inch2Y_oddtable=[379.5962833
282.0341329
233.2530577
184.4719825
160.0814449
135.6909073
111.3003697
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
86.9098321
111.3003697
135.6909073
160.0814449
184.4719825
233.2530577
282.0341329
379.5962833];

inch2Y_eventable=[477.1584337
574.7205841
623.5016593
672.2827345
696.6732721
721.0638097
745.4543473
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
769.8448849
745.4543473
721.0638097
696.6732721
672.2827345
623.5016593
574.7205841
477.1584337];
%% step1 找出顆粒
%tic

Ap=[];
Rp=[];
rp=[];
Cp=[];
Ad=[];
Rd=[];
rd=[];
Cd=[];
range=[];
defect=[];
particle=[];
defectn=[];
particlen=[];

%減去背景髒汙
bg = imread(bgRoot); %Background
if(ndims(bg)==3)
    bg=rgb2gray(bg);
end
pic1= imread(imRoot);
%figure(1),imshow(pic1);
if(ndims(pic1)==3)
    pic1=rgb2gray(pic1);
end
pic2=bg-pic1; 
%檢查閥質是否過低
TVstate=0;  
loop=1;
while(loop==1)
    TVal=graythresh(pic2)*255;
    if(TVal<1)
        TVal=10+TVstate*2;
    elseif(TVal<20)
        TVal=30+TVstate*2;
    elseif(TVal>70)
        TVal=30+TVstate*4;
    elseif(TVal>50)
        TVal=50+TVstate*2;
    else
        loop=0;
    end
    im = im2bw(pic2,TVal/255);
    im=imdilate(im,strel('square',6));
    %figure(6),subplot(221),imshow(im);
    im=imerode(im,strel('disk',4));
    %figure(6),subplot(222),imshow(im);
    im=bwareaopen(im,3);
    %figure(6),subplot(223),imshow(im);
    im=imdilate(im,strel('disk',2));
    %figure(6),subplot(224),imshow(im);
    s = regionprops('table',im,'Centroid','FilledArea','MajorAxisLength','MinorAxisLength');       
    centroids = s.Centroid;
    area=s.FilledArea;
    rl=s.MajorAxisLength;
    rs=s.MinorAxisLength;
    f=find(rl>30);%留下長軸大於6pixel的瑕疵
    x=size(f);
    TVstate=TVstate+1;
    if( x(1)<300 )
        loop=0;
    end
    if(TVstate>=2)
        console='Too many';
        loop=0;
        %return;
    end
end
centroids = centroids(f,:);
area=area(f);
rl=rl(f);
rs=rs(f);

s=size(centroids);
pic_size=size(im);
% 矩陣運算座標需為正整數

for n=1:s(1)
    %初步篩選
    if (rl(n)>50) && (rs(n)>rl(n)*0.1) && (rl(n)<300)
        %框出目標區域，個別計算閥值
        %OutsideBox
        Oby1=ceil(centroids(n,2)-rl(n));
        if Oby1<=0
            Oby1=1;
        end
        Oby2=ceil(centroids(n,2)+rl(n));
        if Oby2>pic_size(1)
            Oby2=pic_size(1);
        end
        Obx1=ceil(centroids(n,1)-rl(n));
        if Obx1<=0
            Obx1=1;
        end
        Obx2=ceil(centroids(n,1)+rl(n));
        if Obx2>pic_size(2)
            Obx2=pic_size(2);
        end
        Obox=im(Oby1:Oby2,Obx1:Obx2);%圈選每一個瑕疵計算面積比
        
        %          figure(1);imshow(pic1);hold on
        %          rectangle('position',[Obx1,Oby1,Obx2-Obx1,Oby2-Oby1],'edgecolor','r');
        
        picTemp=pic1(Oby1:Oby2,Obx1:Obx2);
        t=graythresh(picTemp);
        picTemp=~im2bw(picTemp,t);
        picTemp=imdilate(picTemp,strel('square',6));
        picTemp=imerode(picTemp,strel('disk',4));
        picTemp=bwareaopen(picTemp,3);
        
        
        %對新閥值之目標區域取regionprops
        temp_s = regionprops('table',picTemp,'Centroid','FilledArea','MajorAxisLength','MinorAxisLength');
        temp_centroids = temp_s.Centroid;
        temp_area=temp_s.FilledArea;
        temp_rl=temp_s.MajorAxisLength;
        temp_rs=temp_s.MinorAxisLength;
        
        temp_f=find(temp_rl>50);
        temp_f=find(temp_area>750);
        temp_centroids = temp_centroids(temp_f,:);
        temp_area=temp_area(temp_f);
        temp_rl=temp_rl(temp_f);
        temp_rs=temp_rs(temp_f);
        
        if isempty(temp_centroids)
            particlen=[particlen ;n];
        else
            mini=1000;
            k=size(temp_centroids);
            for m=1:k(1)
                sq=sqrt((centroids(n,1)-Obx1-temp_centroids(m,1))^2+(centroids(n,2)-Oby1-temp_centroids(m,2))^2);
                if sq<mini
                    mini=sq;
                    miniIndex=m;
                end
            end
            %inerbox
            Iner_pic_size=size(picTemp);
            Iby1=ceil(temp_centroids(miniIndex,2)-temp_rs(miniIndex)/2);
            if Iby1<=0
                Iby1=1;
            end
            Iby2=ceil(temp_centroids(miniIndex,2)+temp_rs(miniIndex)/2);
            if Iby2>Iner_pic_size(1)
                Iby2=Iner_pic_size(1);
            end
            Ibx1=ceil(temp_centroids(miniIndex,1)-temp_rs(miniIndex)/2);
            if Ibx1<=0
                Ibx1=1;
            end
            Ibx2=ceil(temp_centroids(miniIndex,1)+temp_rs(miniIndex)/2);
            if Ibx2>Iner_pic_size(2)
                Ibx2=Iner_pic_size(2);
            end
            Ibox=picTemp(Iby1:Iby2,Ibx1:Ibx2);%圈選每一個瑕疵計算面積比
            
%                       figure(4);imshow(picTemp);hold on;
%                       rectangle('position',[Ibx1,Iby1,Ibx2-Ibx1,Iby2-Iby1],'edgecolor','r');
%                       sum(sum(Ibox))/((Ibx2-Ibx1)*(Iby2-Iby1))
%                       hold off;
            
            %由內、外空心程度進一步判斷
            if(sum(sum(Ibox))/((Ibx2-Ibx1)*(Iby2-Iby1))<0.4)
                %sum(sum(Ibox))/((Ibx2-Ibx1)*(Iby2-Iby1))
                defectn=[defectn ;n];
            else
                particlen=[particlen ;n];
            end
        end
    else
        particlen=[particlen ;n];
    end
end

defect_area=area(defectn);
defect_rl=rl(defectn);
defect_rs=rs(defectn);
defect_c = centroids(defectn,:);
particle_area=area(particlen);
particle_rl=rl(particlen);
particle_rs=rs(particlen);
particle_c = centroids(particlen,:);

% 座標換算
stand2XV=425.8867925;  % 2"X軸的垂直基準值
stand2XH=43.05236;      % 2"X軸的水平基準值
stand2YV=86.9098321;    % 2"Y軸的垂直基準值
stand2YH=379.5962833;   % 2"Y軸的水平基準值

stand4XV=432.94339625;  % 4"X軸的垂直基準值
stand4XH=35.3845625;      % 4"X軸的水平基準值
stand4YV=43.94007765;    % 4"Y軸的垂直基準值
stand4YH=434.18867925;   % 4"Y軸的水平基準值

pX=0.006014;
wX=14.7244094;
hX=12.3184602;

if(mode==10)
    if inch==4
        if L==0
            try
                particle_c(:,1)=particle_c(:,1)*pX+stand4XH+wX*N;
                particle_c(:,2)=particle_c(:,2)*pX+stand4YH;
                defect_c(:,1)=defect_c(:,1)*pX+stand4XH+wX*N;
                defect_c(:,2)=defect_c(:,2)*pX+stand4YH;
            end
        else
            try
                particle_c(:,1)=particle_c(:,1)*pX+stand4XV;
                particle_c(:,2)=particle_c(:,2)*pX+stand4YV+hX*N;
                defect_c(:,1)=defect_c(:,1)*pX+stand4XV;
                defect_c(:,2)=defect_c(:,2)*pX+stand4YV+hX*N;
            end
        end
    elseif inch==2
        if L==0
            try
                particle_c(:,1)=particle_c(:,1)*pX+stand2XH+wX*N*2;
                particle_c(:,2)=particle_c(:,2)*pX+stand2YH;
                defect_c(:,1)=defect_c(:,1)*pX+stand2XH+X*2*N;
                defect_c(:,2)=defect_c(:,2)*pX+stand2YH;
            end
        else
            try
                particle_c(:,1)=particle_c(:,1)*pX+stand2XV;
                particle_c(:,2)=particle_c(:,2)*pX+stand2YV+hX*2*N;
                defect_c(:,1)=defect_c(:,1)*pX+stand2XV;
                defect_c(:,2)=defect_c(:,2)*pX+stand2YV+hX*2*N;
            end
        end
    end
else
    if inch==4
        if(mod(L+1,2)==1)
            try
                particle_c(:,2)=particle_c(:,2)*pX+inch4Y_oddtable(L+1)+hX*N;
                particle_c(:,1)=particle_c(:,1)*pX+inch4Xtable(L+1);
            end
            try
                defect_c(:,2)=defect_c(:,2)*pX+inch4Y_oddtable(L+1)+hX*N;
                defect_c(:,1)=defect_c(:,1)*pX+inch4Xtable(L+1);
            end
            % catch
            %     console = 'Miss D'
        else
            try
                particle_c(:,2)=particle_c(:,2)*pX+inch4Y_evetable(L+1)-hX*N;
                particle_c(:,1)=particle_c(:,1)*pX+inch4Xtable(L+1);
            end
            % catch
            %     console = 'Miss P'
            try
                defect_c(:,2)=defect_c(:,2)*pX+inch4Y_evetable(L+1)-hX*N;
                defect_c(:,1)=defect_c(:,1)*pX+inch4Xtable(L+1);
            end
            % catch
            %     console = 'Miss D'
        end
    elseif(inch==2)
        if(mod(L+1,2)==1)
            try
                particle_c(:,2)=particle_c(:,2)*pX*2+inch2Y_oddtable(L+1)+hX*N*2;
                particle_c(:,1)=particle_c(:,1)*pX*2+inch2Xtable(L+1);
            end
            try
                defect_c(:,2)=defect_c(:,2)*pX*2+inch2Y_oddtable(L+1)+hX*N*2;
                defect_c(:,1)=defect_c(:,1)*pX*2+inch2Xtable(L+1);
            end
            % catch
            %     console = 'Miss D'
        else
            try
                particle_c(:,2)=particle_c(:,2)*pX*2+inch2Y_eventable(L+1)-hX*N*2;
                particle_c(:,1)=particle_c(:,1)*pX*2+inch2Xtable(L+1);
            end
            % catch
            %     console = 'Miss P'
            try
                defect_c(:,2)=defect_c(:,2)*pX*2+inch2Y_eventable(L+1)-hX*N*2;
                defect_c(:,1)=defect_c(:,1)*pX*2+inch2Xtable(L+1);
            end
            % catch
            %     console = 'Miss D'
        end
    end
end

Ap=[Ap ;particle_area];
Rp=[Rp ;particle_rl];
rp=[rp ;particle_rs];
Cp=[Cp; particle_c];
Ad=[Ad ;defect_area];
Rd=[Rd ;defect_rl];
rd=[rd ;defect_rs];
Cd=[Cd; defect_c];
%figure(10),imshow(pic1),colormap(gray),axis equal,hold on
%畫圖fig=figure('visible','off');
%畫圖imshow(pic1,'border','tight','initialmagnification','fit'),axis normal,colormap(gray),hold on
%imtool(uint8(pic1));
%畫圖plot(particle_c(:,1),particle_c(:,2), 'r*')
%畫圖viscircles(particle_c,particle_rl/2,'EdgeColor','r');
ss=size(particle_c);

%畫圖
% for n=1:ss(1)
%     str=strcat('P',num2str(n));
%     text(particle_c(n,1),particle_c(n,2),str,'Color','R','FontSize',8);
% end
% fig ;hold on
% plot(defect_c(:,1),defect_c(:,2), 'b*')
% viscircles(defect_c,defect_rl/2,'EdgeColor','b');
% ss=size(defect_c);
% for n=1:ss(1)
%     str=strcat('D',num2str(n));
%     text(defect_c(n,1),defect_c(n,2),str,'Color','B','FontSize',8);
% end
% hold off
% pause(1)
% frame = getframe(fig);
% imwrite(frame.cdata, strcat(path,fileName)); %'D:\wafer\after\pic1.bmp'
%檢查ROI是否包含編號、邊界
%區分顆粒大小
pixel=0.675;

range1=0;
range2=0;
range3=0;
range4=0;
range5=0;
range6=0;
range7=0;
range8=0;
range9=0;
range10=0;
range11=0;
range12=0;
range13=0;
range14=0;
range15=0;
range16=0;
range17=0;
range18=0;
range19=0;
range20=0;
range21=0;
x=size(rp);
for(n=1:x(1))
    if(Rp(n)<15)  %~10
        range1=range1+1;
    elseif(Rp(n)<30)
        range2=range2+1;
    elseif(Rp(n)<45)
        range3=range3+1;
    elseif(Rp(n)<60)
        range4=range4+1;
    elseif(Rp(n)<75)
        range5=range5+1;
    elseif(Rp(n)<90)
        range6=range6+1;
    elseif(Rp(n)<105)
        range7=range7+1;
    elseif(Rp(n)<120)
        range8=range8+1;
    elseif(Rp(n)<135)
        range9=range9+1;
    elseif(Rp(n)<150)      %90~100
        range10=range10+1;
    elseif(Rp(n)<165)
        range11=range11+1;
    elseif(Rp(n)<180)
        range12=range12+1;
    elseif(Rp(n)<195)
        range13=range13+1;
    elseif(Rp(n)<210)
        range14=range14+1;
    elseif(Rp(n)<225)
        range15=range15+1;
    elseif(Rp(n)<240)
        range16=range16+1;
    elseif(Rp(n)<255)
        range17=range17+1;
    elseif(Rp(n)<270)
        range18=range18+1;
    elseif(Rp(n)<285)
        range19=range19+1;
    elseif(Rp(n)<300)           %~202mm
        range20=range20+1;
    else                           %202mm~
        range21=range21+1;
    end
end
range=[range1,range2,range3,range4,range5,range6,range7,range8,range9,range10,range11,range12,range13,range14,range15,range16,range17,range18,range19,range20,range21];
particle=[Ap Cp];
defect = [Ad Cd];

%% step2 txt
% N=num2str(N);
% L=num2str(L);
% 
% fid = fopen('PY.txt','at');
% %fprintf(fid,'particle\n');
% matrix=Cp(:,1);                  
% [m,n]=size(matrix);
%  for i=1:1:m
%    for j=1:1:n
%       if j==n
%         fprintf(fid,'%g\n',matrix(i,j));
%      else
%        fprintf(fid,'%g\t',matrix(i,j));
%       end
%    end
%  end
% fclose(fid);
% 
% fid = fopen('PX.txt','at');
% %fprintf(fid,'particle\n');
% matrix=Cp(:,2);                  
% [m,n]=size(matrix);
%  for i=1:1:m
%    for j=1:1:n
%       if j==n
%         fprintf(fid,'%g\n',matrix(i,j));
%      else
%        fprintf(fid,'%g\t',matrix(i,j));
%       end
%    end
%  end
% fclose(fid); 
% 
% 
% fid = fopen('D.txt','at');
% %fprintf(fid,'defect\n');
% matrix=defect;                  
% [m,n]=size(matrix);
%  for i=1:1:m
%    for j=1:1:n
%       if j==n
%         fprintf(fid,'%g\n',matrix(i,j));
%      else
%        fprintf(fid,'%g\t',matrix(i,j));
%       end
%    end
%  end
% fclose(fid);

