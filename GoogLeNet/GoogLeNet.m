function varargout = GoogLeNet(varargin)
% GOOGLENET MATLAB code for GoogLeNet.fig
%      GOOGLENET, by itself, creates a new GOOGLENET or raises the existing
%      singleton*.
%
%      H = GOOGLENET returns the handle to a new GOOGLENET or the handle to
%      the existing singleton*.
%
%      GOOGLENET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOOGLENET.M with the given input arguments.
%
%      GOOGLENET('Property','Value',...) creates a new GOOGLENET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GoogLeNet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GoogLeNet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GoogLeNet

% Last Modified by GUIDE v2.5 08-Apr-2019 17:10:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GoogLeNet_OpeningFcn, ...
                   'gui_OutputFcn',  @GoogLeNet_OutputFcn, ...
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


% --- Executes just before GoogLeNet is made visible.
function GoogLeNet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GoogLeNet (see VARARGIN)

% Choose default command line output for GoogLeNet
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GoogLeNet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GoogLeNet_OutputFcn(hObject, eventdata, handles) 
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
[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.bmp','All Image Files';'*.*','All Files' });
fullFilename = [pathname filename];
global Imag;
Imag = imread(fullFilename);
axes(handles.axes1);
imshow(Imag);
set(handles.btn_analyze,'Enable','on');


% --- Executes on button press in btn_analyze.
function btn_analyze_Callback(hObject, eventdata, handles)
% hObject    handle to btn_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
net = googlenet;
inputSize = net.Layers(1).InputSize;
global Imag;
Imag = imresize(Imag,inputSize(1:2));
classNames = net.Layers(end).ClassNames;
[label,scores] = classify(net,Imag);
axes(handles.axes1);
title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");

[~,idx] = sort(scores,'descend');
idx = idx(5:-1:1);
classNamesTop = net.Layers(end).ClassNames(idx);
scoresTop = scores(idx);

axes(handles.axes2);
barh(scoresTop)
xlim([0 1])
title('Top 5 Predictions')
xlabel('Probability')
yticklabels(classNamesTop)


% --- Executes on button press in btn_pre.
function btn_pre_Callback(hObject, eventdata, handles)
% hObject    handle to btn_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
global vid;
vid = videoinput('winvideo', 1, 'MJPG_1280x720');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;

start(vid)
vidRes = get( vidobj1 , 'VideoResolution');                                                                                
nBands = get( vidobj1 , 'NumberOfBands');                                                                             
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );

preview(vid,hImage);axis equal;


