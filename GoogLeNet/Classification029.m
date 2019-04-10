%%  Create Simple Deep Learning Network for Classification
%  
%   Load and explore image data.
%   Define the network architecture.
%   Specify training options.
%   Train the network.
%   Predict the labels of new data and calculate the classification accuracy.
%
%   form: < https://ww2.mathworks.cn/help/deeplearning/examples/create-simple-deep-learning-network-for-classification.html >

%%  step1 ����
% Ū��
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

% �����ϥ����ŦX���w�j�p
img = readimage(imds,1);
size(img);

% �N1000�i�ϩ�}�A750pic�Ω�V�m ��l�Ψ�����
numTrainFiles = 750;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% step2 �w�q�����[�c
layers = [
    imageInputLayer([28 28 1])  %���w�Ϲ��j�p h,w,color ch
    
    convolution2dLayer(3,8,'Padding','same')
    % filterSize : �o�i���j�p��3*3
    % numFilters : �o�i���ƶq(���g��)
    batchNormalizationLayer  %�u�� �[�t�����V�m�B���C�ӷP��
    reluLayer  %�k�@��ݭ��W�@�ӿE�����(activation func)
    % �`�����E�y��ƿ�ܦ� sigmoid, tanh, Relu�A
    % ��ΤW�̱`�ϥ� ReLU �A�@���ܧΦp Leaky ReLU, Maxout �]�i�H�ոաA
    % tanh �M sigmoid �ɶq�O�ΡC << ��׮���
    
    %��X�H�W�B�J�i��D�u���ഫ��A�o��S�x��(feature map)
    
    %����(Pooling)
    % �ھ�feature map�����G�h��pooling�A
    % �M��o�������S�x��
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(10) %��X���ƥ� (����)
    softmaxLayer %����s���h �k�@��
    classificationLayer];

%% step3 �V�m
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...   %�ǲ߰j���
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

%% step4 ����
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)
