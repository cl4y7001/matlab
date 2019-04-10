function [particle,defect,range]=Wafer_DetectIm(bgRoot,imRoot,path,fileName,show)
%%
%  Ver �s�X�Ӥ� 2019/3/29
%  �ק����
%  �̤p����з�: 14 >> 30 (20um)
%  ��P�_ �G�����@�u�b ���Ťߵ{�� >> �u�b�Ťߵ{��
%  defect: temp_area > 750 && temp_rl > 50
% ------------------------------------------------------------
%  �Ω󴹶ꪺ�岫�˴�
%  �D�n�ت��O��X�U��(defect)
%  �NROI��h�I���঳�Į����t��ż�������ҥ����������D
%  ��B�H�ۭq�֭�(TVal)�o�X������(particle)
%  ��h���ɫ�A�i�檽��B��A�ӧ�X���ê��U��
%
% INPUT:
%     bgRoot - �I���Ϥ����|
%     imRoot - ROI�Ϥ����|
%     path - �w�s�x�Ϥ������|
%     fileName - �ɮת��R�W(�ݧt���ɦW ex.bmp)
%
% OUTPUT:
%     particle - ���ɪ����n(Ap)�B��߮y��(Cp)     at line195
%     defect - �U�ʪ����n(Ad)�B��߮y��(Cd)       at line196(end)
%     range - �U�϶�particle���Ӽ�        at line194

%% step1 ��X����
%warning('off','all');
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

%��h�I��ż��
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
%�ˬd�ֽ�O�_�L�C
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
    f=find(rl>30);%�d�U���b�j��6pixel���岫
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
% �x�}�B��y�лݬ������

for n=1:s(1)
    %��B�z��
    if (rl(n)>50) && (rs(n)>rl(n)*0.1) && (rl(n)<300)
        %�إX�ؼаϰ�A�ӧO�p��֭�
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
        Obox=im(Oby1:Oby2,Obx1:Obx2);%���C�@�ӷ岫�p�⭱�n��
        
        %          figure(1);imshow(pic1);hold on
        %          rectangle('position',[Obx1,Oby1,Obx2-Obx1,Oby2-Oby1],'edgecolor','r');
        
        picTemp=pic1(Oby1:Oby2,Obx1:Obx2);
        t=graythresh(picTemp);
        picTemp=~im2bw(picTemp,t);
        picTemp=imdilate(picTemp,strel('square',6));
        picTemp=imerode(picTemp,strel('disk',4));
        picTemp=bwareaopen(picTemp,3);
        
        
        %��s�֭Ȥ��ؼаϰ��regionprops
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
            Ibox=picTemp(Iby1:Iby2,Ibx1:Ibx2);%���C�@�ӷ岫�p�⭱�n��
            
%                       figure(4);imshow(picTemp);hold on;
%                       rectangle('position',[Ibx1,Iby1,Ibx2-Ibx1,Iby2-Iby1],'edgecolor','r');
%                       sum(sum(Ibox))/((Ibx2-Ibx1)*(Iby2-Iby1))
%                       hold off;
            
            %�Ѥ��B�~�Ťߵ{�׶i�@�B�P�_
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

% �y���ഫ
% if(mod(L+1,2)==1)
%     try
%         particle_c(:,1)=particle_c(:,1)*0.006+Y_oddtable(L+1)+12.2*N;
%         particle_c(:,2)=particle_c(:,2)*0.006+Xtable(L+1);
%     end
%     try
%         defect_c(:,1)=defect_c(:,1)*0.006+Y_oddtable(L+1)+12.2*N;
%         defect_c(:,2)=defect_c(:,2)*0.006+Xtable(L+1);
%     end
% else
%     try
%         particle_c(:,1)=particle_c(:,1)*0.006+Y_evetable(L+1)-12.2*N;
%         particle_c(:,2)=particle_c(:,2)*0.006+Xtable(L+1);
%     end
%     try
%         defect_c(:,1)=defect_c(:,1)*0.006+Y_evetable(L+1)-12.2*N;
%         defect_c(:,2)=defect_c(:,2)*0.006+Xtable(L+1);
%     end
% end

Ap=[Ap ;particle_area];
Rp=[Rp ;particle_rl];
rp=[rp ;particle_rs];
Cp=[Cp; particle_c];
Ad=[Ad ;defect_area];
Rd=[Rd ;defect_rl];
rd=[rd ;defect_rs];
Cd=[Cd; defect_c];

%figure(10),imshow(pic1),colormap(gray),axis equal,hold on
if show==0
    fig=figure('visible','off');
else
    fig=figure('visible','on');
end

javaFrame = get(fig,'JavaFrame');
set(javaFrame,'FigureIcon',javax.swing.ImageIcon('optic.png'));
set(fig, 'outerposition', [0,0,934,862]);  %W+16 H+94
imshow(pic1,'border','tight','initialmagnification','fit'),axis normal,colormap(gray),hold on
if ~isempty(particle_c)
    plot(particle_c(:,1),particle_c(:,2), 'r*')
    viscircles(particle_c,particle_rl/2,'EdgeColor','r');
end
ss=size(particle_c);
%�e��
for n=1:ss(1)
    str=strcat('P',num2str(n));
    text(particle_c(n,1),particle_c(n,2),str,'Color','R','FontSize',8);
end
fig ;hold on
if ~isempty(defect_c)
    plot(defect_c(:,1),defect_c(:,2), 'b*')
    viscircles(defect_c,defect_rl/2+7,'EdgeColor','b');
end
ss=size(defect_c);
for n=1:ss(1)
    str=strcat('D',num2str(n));
    text(defect_c(n,1),defect_c(n,2),str,'Color','B','FontSize',8);
end
hold off
pause(1)
frame = getframe(fig);
imwrite(frame.cdata, strcat(path,fileName)); %'D:\wafer\after\pic1.bmp'

%�ˬdROI�O�_�]�t�s���B���
%�Ϥ����ɤj�p
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
console='end';



