function varargout = CF_defect(varargin)
% CF_DEFECT MATLAB code for CF_defect.fig
%      CF_DEFECT, by itself, creates a new CF_DEFECT or raises the existing
%      singleton*.
%
%      H = CF_DEFECT returns the handle to a new CF_DEFECT or the handle to
%      the existing singleton*.
%
%      CF_DEFECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CF_DEFECT.M with the given input arguments.
%
%      CF_DEFECT('Property','Value',...) creates a new CF_DEFECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CF_defect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CF_defect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CF_defect

% Last Modified by GUIDE v2.5 09-Apr-2019 14:53:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CF_defect_OpeningFcn, ...
                   'gui_OutputFcn',  @CF_defect_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CF_defect is made visible.
function CF_defect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CF_defect (see VARARGIN)

% Choose default command line output for CF_defect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

digitDatasetPath = fullfile('C:\Users\user\Documents\MATLAB\GoogLeNet\dataset');

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

figure;
perm = randperm(length(imds.Files),20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

labelCount = countEachLabel(imds)

% % 全部圖必須符合指定大小
% img = readimage(imds,1);
% size(img);

% 將10張圖拆開，7pic用於訓練 其餘用來驗證
numTrainFiles = 7;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% step2 定義網路架構
layers = [
    imageInputLayer([28 28 3])  %指定圖像大小 h,w,color ch
    
    convolution2dLayer(3,8,'Padding','same')
    % filterSize : 濾波器大小為3*3
    % numFilters : 濾波器數量(神經元)
    batchNormalizationLayer  %優化 加速網路訓練、降低敏感度
    reluLayer  %歸一後需乘上一個激活函數(activation func)
    % 常見的激勵函數選擇有 sigmoid, tanh, Relu，
    % 實用上最常使用 ReLU ，一些變形如 Leaky ReLU, Maxout 也可以試試，
    % tanh 和 sigmoid 盡量別用。 << 梯度消失
    
    %綜合以上步驟進行非線性轉換後，得到特徵圖(feature map)
    
    %池化(Pooling)
    % 根據feature map的結果去做pooling，
    % 然後得降維的特徵圖
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(4) %輸出的數目 (種類)
    softmaxLayer %對全連接層 歸一化
    classificationLayer];

%% step3 訓練
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',50, ...   %學習迴圈數
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');
    %'ExecutionEnvironment','gpu' 
global net;
net = trainNetwork(imdsTrain,layers,options);
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)

% UIWAIT makes CF_defect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CF_defect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_upload.
function btn_upload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.bmp','All Image Files';'*.*','All Files' },'select','D:\4Y_B\1\');
fullFilename = [pathname filename];
global Imag;
Imag = imread(fullFilename);
axes(handles.axes1);
imshow(Imag);


% --- Executes on button press in btn_crop.
function btn_crop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Imag;
h=imrect; 
setColor(h,'R');
pos=getPosition(h);  %pos為start xy end xy

CImag = imcrop(Imag,pos);
% axes(handles.Oaxes);
% imshow(FImag);title('Original Image');
axes(handles.axes2);
imshow(CImag);
CImag=imresize(CImag,[28,28]);
global net;
classNames = net.Layers(end).ClassNames;
[label,scores] = classify(net,CImag);
title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");
delete(h);   


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CImag=handles.axes2.Children.CData;
[FileName, PathName, FilterIndex] = uiputfile('*.png', 'Save picture as:');
if ~ischar(FileName)
  disp('User aborted the dialog');
  return;
end
File = fullfile(PathName, FileName);
CImag=imresize(CImag,[28,28]);
imwrite(CImag, File);
