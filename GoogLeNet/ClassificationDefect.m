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

% % �����ϥ����ŦX���w�j�p
% img = readimage(imds,1);
% size(img);

% �N10�i�ϩ�}�A7pic�Ω�V�m ��l�Ψ�����
numTrainFiles = 7;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% step2 �w�q�����[�c
layers = [
    imageInputLayer([28 28 3])  %���w�Ϲ��j�p h,w,color ch
    
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
    
    fullyConnectedLayer(3) %��X���ƥ� (����)
    softmaxLayer %����s���h �k�@��
    classificationLayer];

%% step3 �V�m
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',50, ...   %�ǲ߰j���
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

% im=imread('C:\Users\user\Documents\MATLAB\GoogLeNet\dataset\defect\1.png');
% [label,scores] = classify(net,im);
% axes(handles.axes1);
% title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");
