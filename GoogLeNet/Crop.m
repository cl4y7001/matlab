function varargout = Crop(varargin)
% CROP MATLAB code for Crop.fig
%      CROP, by itself, creates a new CROP or raises the existing
%      singleton*.
%
%      H = CROP returns the handle to a new CROP or the handle to
%      the existing singleton*.
%
%      CROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROP.M with the given input arguments.
%
%      CROP('Property','Value',...) creates a new CROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Crop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Crop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Crop

% Last Modified by GUIDE v2.5 09-Apr-2019 09:28:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Crop_OpeningFcn, ...
                   'gui_OutputFcn',  @Crop_OutputFcn, ...
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


% --- Executes just before Crop is made visible.
function Crop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Crop (see VARARGIN)

% Choose default command line output for Crop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Crop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Crop_OutputFcn(hObject, eventdata, handles) 
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
pos=getPosition(h);  %pos¬°start xy end xy

CImag = imcrop(Imag,pos);
% axes(handles.Oaxes);
% imshow(FImag);title('Original Image');
axes(handles.axes2);
imshow(CImag);title('Crop Image');
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
