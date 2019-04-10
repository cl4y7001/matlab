function varargout = Capture(varargin)
% CAPTURE MATLAB code for Capture.fig
%      CAPTURE, by itself, creates a new CAPTURE or raises the existing
%      singleton*.
%
%      H = CAPTURE returns the handle to a new CAPTURE or the handle to
%      the existing singleton*.
%
%      CAPTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPTURE.M with the given input arguments.
%
%      CAPTURE('Property','Value',...) creates a new CAPTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Capture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Capture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Capture

% Last Modified by GUIDE v2.5 19-Feb-2019 15:59:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Capture_OpeningFcn, ...
                   'gui_OutputFcn',  @Capture_OutputFcn, ...
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


% --- Executes just before Capture is made visible.
function Capture_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Capture (see VARARGIN)

% Choose default command line output for Capture
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Capture wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Capture_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PreButton.
function PreButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vidobj1

axes(handles.axes1)
vidobj1 = videoinput('tisimaq_r2013_64', 1, 'Y800 (2448x2048)');
src = getselectedsource(vidobj1);
src.ExposureAuto = 'Off';
src.GainAuto = 'Off';
src.Exposure = 0.1;
src.Brightness = 0;
src.Gain = 0;
src.FrameRate = 30;
vidobj1.FrameGrabInterval = 1;  % distance between captured frames 

start(vidobj1)
vidRes = get( vidobj1 , 'VideoResolution');                                                                                
nBands = get( vidobj1 , 'NumberOfBands');                                                                             
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview( vidobj1 , hImage );axis equal;


% --- Executes on button press in SnapButton.
function SnapButton_Callback(hObject, eventdata, handles)
% hObject    handle to SnapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vidobj1
axes(handles.axes1)
src = getselectedsource(vidobj1);
%src.BacklightCompensation = 'off';
%src.FrameRate = '30';
%src.FocusMode = 'manual';
%src.Focus = 75;
% src.ExposureAuto = 'Off';
% src.GainAuto = 'Off';
src.Exposure = 0.1;
src.Brightness = 0;
src.Gain = 0;
%pause(1)
%start(vidobj1)
pic1= getsnapshot(vidobj1);%ย^จ๚ทำค๙
axes(handles.axes1);
imshow(pic1);
%colormap(gray)
axis equal
