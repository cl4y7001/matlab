%%  Create Simple Deep Learning Network for Classification
%  
%   Load and explore image data.
%   Define the network architecture.
%   Specify training options.
%   Train the network.
%   Predict the labels of new data and calculate the classification accuracy.
%
%   form: < https://ww2.mathworks.cn/help/deeplearning/examples/create-simple-deep-learning-network-for-classification.html >

%%  step1 餵圖
% 讀圖
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

figure;
perm = randperm(10000,20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

labelCount = countEachLabel(imds)

% 全部圖必須符合指定大小
img = readimage(imds,1);
size(img);

% 將1000張圖拆開，750pic用於訓練 其餘用來驗證
numTrainFiles = 750;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% step2 定義網路架構
layers = [
    imageInputLayer([28 28 1])  %指定圖像大小 h,w,color ch
    
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
    
    fullyConnectedLayer(10) %輸出的數目 (種類)
    softmaxLayer %對全連接層 歸一化
    classificationLayer];

%% step3 訓練
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...   %學習迴圈數
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

%% step4 驗證
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)
