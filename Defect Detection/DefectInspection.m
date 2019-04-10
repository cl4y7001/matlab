function varargout = DefectInspection(varargin)
% DEFECTINSPECTION MATLAB code for DefectInspection.fig
%      DEFECTINSPECTION, by itself, creates a new DEFECTINSPECTION or raises the existing
%      singleton*.
%
%      H = DEFECTINSPECTION returns the handle to a new DEFECTINSPECTION or the handle to
%      the existing singleton*.
%
%      DEFECTINSPECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFECTINSPECTION.M with the given input arguments.
%
%      DEFECTINSPECTION('Property','Value',...) creates a new DEFECTINSPECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DefectInspection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DefectInspection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DefectInspection

% Last Modified by GUIDE v2.5 19-Feb-2019 16:50:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DefectInspection_OpeningFcn, ...
                   'gui_OutputFcn',  @DefectInspection_OutputFcn, ...
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


% --- Executes just before DefectInspection is made visible.
function DefectInspection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DefectInspection (see VARARGIN)

% Choose default command line output for DefectInspection
handles.output = hObject;

% %out=DI_thresholding(imag);
% out=varargin{1};
% uiwait(handles.figure1);
% global FImag;
% FImag = out;
% axes(handles.Faxes);
% imshow(FImag);title('Final Image')
% Update handles structure

guidata(hObject, handles);

% UIWAIT makes DefectInspection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DefectInspection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in UpButton.
function UpButton_Callback(hObject, eventdata, handles)
% hObject    handle to UpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename,pathname]=uigetfile({'*.bmp','*.jpg'},'Load image');
[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.bmp','All Image Files';'*.*','All Files' });
fullFilename = [pathname filename];
Imag = imread(fullFilename);
axes(handles.Oaxes);

global FImag;
FImag = Imag;
axes(handles.Faxes);
imshow(FImag);title('Final Image')
axes(handles.Oaxes);
imshow(Imag);title('Original Image')
axis off  
guidata(hObject, handles)



% --- Executes on button press in TButton.
function TButton_Callback(hObject, eventdata, handles)
% hObject    handle to TButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
DI_thresholding(imag,handles);

% [FImag,min,max] = DI_thresholding(imag);


% --- Executes on button press in FilterButton.
function FilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to FilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
DI_filter(imag,handles);


% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
DI_remove(imag,handles);


% --- Executes on button press in InverseButton.
function InverseButton_Callback(hObject, eventdata, handles)
% hObject    handle to InverseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
imag = ~imag;
axes(handles.Faxes);
imshow(imag);title('Final Image')



% --- Executes on button press in EDButton.
function EDButton_Callback(hObject, eventdata, handles)
% hObject    handle to EDButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
DI_dilate(imag,handles);


% --- Executes on button press in RecoverButton.
function RecoverButton_Callback(hObject, eventdata, handles)
% hObject    handle to RecoverButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FImag;
axes(handles.Faxes);
imshow(FImag);title('Final Image');


% --- Executes on button press in CloseButton.
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf)


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Fimag=handles.Faxes.Children.CData;
[FileName, PathName, FilterIndex] = uiputfile('*.bmp', 'Save picture as:');
if ~ischar(FileName)
  disp('User aborted the dialog');
  return;
end
File = fullfile(PathName, FileName);
imwrite(Fimag, File);



% --- Executes on button press in CropButton.
function CropButton_Callback(hObject, eventdata, handles)
% hObject    handle to CropButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
axes(handles.Oaxes);
axis off;
%cursor換成十字，來框範圍
h=imrect; 
setColor(h,'R');
pos=getPosition(h);  %pos為start xy end xy

FImag = imcrop(imag,pos);
% axes(handles.Oaxes);
% imshow(FImag);title('Original Image');
axes(handles.Faxes);
imshow(FImag);title('Final Image');
%delete(h);   


% --- Executes on button press in EntropyButton.
function EntropyButton_Callback(hObject, eventdata, handles)
% hObject    handle to EntropyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imag=handles.Faxes.Children.CData;
enValue = entropy(imag);
val = num2str(enValue);
set(handles.EntropyText, 'String', val);

stats = regionprops('table',imag,'Centroid',...
    'MajorAxisLength','MinorAxisLength','Area');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
Area= stats.Area
figure(2),imshow(imag);
hold on;
viscircles(centers,radii);
hold off;


% --- Executes on button press in CapButton.
function CapButton_Callback(hObject, eventdata, handles)
% hObject    handle to CapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vidobj1
axes(handles.Oaxes)
src = getselectedsource(vidobj1);
%src.BacklightCompensation = 'off';
%src.FrameRate = '30';
%src.FocusMode = 'manual';
%src.Focus = 75;
% src.ExposureAuto = 'Off';
% src.GainAuto = 'Off';
src.Exposure = 0.01;
src.Brightness = 0;
src.Gain = 0;
%pause(1)
%start(vidobj1)
Imag= getsnapshot(vidobj1);%擷取照片

global FImag;
FImag = Imag;
axes(handles.Faxes);
imshow(FImag);title('Final Image')
axes(handles.Oaxes);
imshow(Imag);title('Original Image')
axis off  
set(handles.PreButton,'Enable','on');


% --- Executes on button press in PreButton.
function PreButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to PreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vidobj1

axes(handles.Oaxes)
vidobj1 = videoinput('tisimaq_r2013_64', 1, 'Y800 (2448x2048)');
src = getselectedsource(vidobj1);
src.ExposureAuto = 'Off';
src.GainAuto = 'Off';
src.Exposure = 0.01;
src.Brightness = 0;
src.Gain = 0;
src.FrameRate = 30;
vidobj1.FrameGrabInterval = 1;  % distance between captured frames 

start(vidobj1)
vidRes = get( vidobj1 , 'VideoResolution');                                                                                
nBands = get( vidobj1 , 'NumberOfBands');                                                                             
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview( vidobj1 , hImage );axis equal;
%防止連按兩次preview
set(handles.PreButton,'Enable','off');