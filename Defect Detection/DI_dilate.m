function varargout = DI_dilate(varargin)
% DI_DILATE MATLAB code for DI_dilate.fig
%      DI_DILATE, by itself, creates a new DI_DILATE or raises the existing
%      singleton*.
%
%      H = DI_DILATE returns the handle to a new DI_DILATE or the handle to
%      the existing singleton*.
%
%      DI_DILATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DI_DILATE.M with the given input arguments.
%
%      DI_DILATE('Property','Value',...) creates a new DI_DILATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DI_dilate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DI_dilate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DI_dilate

% Last Modified by GUIDE v2.5 21-Jan-2019 16:05:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DI_dilate_OpeningFcn, ...
                   'gui_OutputFcn',  @DI_dilate_OutputFcn, ...
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


% --- Executes just before DI_dilate is made visible.
function DI_dilate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DI_dilate (see VARARGIN)

% Choose default command line output for DI_dilate
handles.output = hObject;

global mom_handles
mom_handles = varargin{2};
global imag;
imag=varargin{1};
axes(handles.axes1);
imshow(imag);title('Dilate & Erode');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DI_dilate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DI_dilate_OutputFcn(hObject, eventdata, handles) 
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
global mom_handles
a = handles.axes1.Children.CData;

axes(mom_handles.Faxes);
imshow(a);
 close(gcbf);


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 close(gcbf); 

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R; R=3;  %default 
global H;H=3; %default
global Deg;Deg=0; %default
global num; num=1;% case number

val =get(hObject,'value');
switch val
    case 1  
        num = 1;
    case 2  
        num = 2;
    case 3
        num = 3;
    case 4  
        num = 4;
    case 5  
        num = 5;
    case 6  
        num = 6;
end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function REdit_Callback(hObject, eventdata, handles)
% hObject    handle to REdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(handles.REdit, 'String'));
max=10;min=0;
if(value>max)
    value=max;
    set(handles.REdit, 'String', value);
elseif(value<min)
    value=min;
    set(handles.REdit, 'String', value);
end
set(handles.RSlider, 'Value', value);

global R;
R=value;
% Hints: get(hObject,'String') returns contents of REdit as text
%        str2double(get(hObject,'String')) returns contents of REdit as a double


% --- Executes during object creation, after setting all properties.
function REdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function RSlider_Callback(hObject, eventdata, handles)
% hObject    handle to RSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=get(handles.RSlider, 'Value');
value=floor(value);
position = num2str(value);
set(handles.REdit, 'String', position);

global R;
R = value;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function RSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function HEdit_Callback(hObject, eventdata, handles)
% hObject    handle to HEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(handles.HEdit, 'String'));
max=10;min=0;
if(value>max)
    value=max;
    set(handles.HEdit, 'String', value);
elseif(value<min)
    value=min;
    set(handles.HEdit, 'String', value);
end
set(handles.HSlider, 'Value', value);

global H;
H=value;
% Hints: get(hObject,'String') returns contents of HEdit as text
%        str2double(get(hObject,'String')) returns contents of HEdit as a double


% --- Executes during object creation, after setting all properties.
function HEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function HSlider_Callback(hObject, eventdata, handles)
% hObject    handle to HSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=get(handles.HSlider, 'Value');
value=floor(value);
position = num2str(value);
set(handles.HEdit, 'String', position);

global H;
H=value;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function HSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in DilateButton.
function DilateButton_Callback(hObject, eventdata, handles)
% hObject    handle to DilateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag; global R; global H; global Deg; global num;
switch num
    case 1  
        SE = strel('disk',R);
    case 2  
        SE = strel('line',R,Deg);
    case 3
        SE = strel('ball',R,H);
    case 4  
        SE = strel('diamond',R);
    case 5  
        SE = strel('octagon',R);
    case 6
        SE = strel('square',R);   
end
TImag =imdilate(imag,SE);
axes(handles.axes1);
imshow(TImag);title('Dilate');

% --- Executes on button press in ErodeButton.
function ErodeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ErodeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag; global R; global H; global Deg; global num;
switch num
    case 1  
        SE = strel('disk',R);
    case 2  
        SE = strel('line',R,Deg);
    case 3
        SE = strel('ball',R,H);
    case 4  
        SE = strel('diamond',R);
    case 5  
        SE = strel('octagon',R);
    case 6
        SE = strel('square',R);   
end
TImag =imerode(imag,SE);
axes(handles.axes1);
imshow(TImag);title('Dilate');


% --- Executes on slider movement.
function DSlider_Callback(hObject, eventdata, handles)
% hObject    handle to DSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=get(handles.DSlider, 'Value');
value=floor(value);
position = num2str(value);
set(handles.DEdit, 'String', position);

global Deg;
Deg = value;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function DSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function DEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(handles.DEdit, 'String'));
max=360;min=0;
if(value>max)
    value=max;
    set(handles.DEdit, 'String', value);
elseif(value<min)
    value=min;
    set(handles.DEdit, 'String', value);
end
set(handles.DSlider, 'Value', value);

global Deg;
Deg=value;
% Hints: get(hObject,'String') returns contents of DEdit as text
%        str2double(get(hObject,'String')) returns contents of DEdit as a double


% --- Executes during object creation, after setting all properties.
function DEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
