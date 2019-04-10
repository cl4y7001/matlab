function varargout = DI_filter(varargin)
% DI_FILTER MATLAB code for DI_filter.fig
%      DI_FILTER, by itself, creates a new DI_FILTER or raises the existing
%      singleton*.
%
%      H = DI_FILTER returns the handle to a new DI_FILTER or the handle to
%      the existing singleton*.
%
%      DI_FILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DI_FILTER.M with the given input arguments.
%
%      DI_FILTER('Property','Value',...) creates a new DI_FILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DI_filter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DI_filter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DI_filter

% Last Modified by GUIDE v2.5 19-Jan-2019 17:19:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DI_filter_OpeningFcn, ...
                   'gui_OutputFcn',  @DI_filter_OutputFcn, ...
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


% --- Executes just before DI_filter is made visible.
function DI_filter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DI_filter (see VARARGIN)

% Choose default command line output for DI_filter
handles.output = hObject;

global mom_handles;
mom_handles = varargin{2};
global imag;
imag=varargin{1};
axes(handles.axes1);
imshow(imag);title('');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DI_filter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DI_filter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OkButton.
function OkButton_Callback(hObject, eventdata, handles)
% hObject    handle to OkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.axes1.Children.CData;

global mom_handles
axes(mom_handles.Faxes);
imshow(a);
 close(gcbf); 



% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf); 


% --- Executes on button press in HisButton.
function HisButton_Callback(hObject, eventdata, handles)
% hObject    handle to HisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag;
if(ndims(imag)==3)
    imag= rgb2gray(imag);
end
Timag=histeq(imag);
axes(handles.axes1);
imshow(Timag);title('Histogram Equalization');


% --- Executes on button press in MeanButton.
function MeanButton_Callback(hObject, eventdata, handles)
% hObject    handle to MeanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag;
fil_size=5; 
fil_func2=ones(fil_size,fil_size)/(fil_size*fil_size); %單元濾波模板尺寸，為n*n  此為5*5
TImag=imfilter(imag,fil_func2);
axes(handles.axes1);
imshow(TImag);title('Mean Filter');



% --- Executes on button press in MedButton.
function MedButton_Callback(hObject, eventdata, handles)
% hObject    handle to MedButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag;
fil_size=5;
TImag=medfilt2(imag,[fil_size fil_size]);
axes(handles.axes1);
imshow(TImag);title('Median filter');

