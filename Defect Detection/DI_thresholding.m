function varargout = DI_thresholding(varargin)
% DI_THRESHOLDING MATLAB code for DI_thresholding.fig
%      DI_THRESHOLDING, by itself, creates a new DI_THRESHOLDING or raises the existing
%      singleton*.
%
%      H = DI_THRESHOLDING returns the handle to a new DI_THRESHOLDING or the handle to
%      the existing singleton*.
%
%      DI_THRESHOLDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DI_THRESHOLDING.M with the given input arguments.
%
%      DI_THRESHOLDING('Property','Value',...) creates a new DI_THRESHOLDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DI_thresholding_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DI_thresholding_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DI_thresholding

% Last Modified by GUIDE v2.5 22-Jan-2019 15:28:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DI_thresholding_OpeningFcn, ...
                   'gui_OutputFcn',  @DI_thresholding_OutputFcn, ...
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


% --- Executes just before DI_thresholding is made visible.
function DI_thresholding_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DI_thresholding (see VARARGIN)

% Choose default command line output for DI_thresholding
handles.output = hObject;
global mom_handles;
mom_handles = varargin{2};
global imag;
imag=varargin{1};
axes(handles.axes1);
imshow(imag);title('Threshold')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DI_thresholding wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DI_thresholding_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OButton.
function OButton_Callback(hObject, eventdata, handles)
% hObject    handle to OButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag;
global mom_handles;
a = handles.axes1.Children.CData;

axes(mom_handles.Faxes);
imshow(a);
 close(gcbf); 



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(handles.slider1, 'Value');
position = num2str(value);
set(handles.edit1, 'String', position);
global imag;
imag2 = double(value<imag);
axes(handles.axes1);
imshow(imag2);title('Threshold');




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CButton.
function CButton_Callback(hObject, eventdata, handles)
% hObject    handle to CButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
value = str2double(get(handles.edit1, 'String'));
if(value>255)
    value=255;
    set(handles.edit1, 'String', value);
elseif(value<0)
    value=0;
    set(handles.edit1, 'String', value);
end
global imag;
set(handles.slider1, 'Value', value);
imag2 = double(value<imag);
axes(handles.axes1);
imshow(imag2);title('Threshold')



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AButton.
function AButton_Callback(hObject, eventdata, handles)
% hObject    handle to AButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag;
val=graythresh(imag);
imag2 = im2bw(imag,val); 
axes(handles.axes1);
imshow(imag2);title('Threshold');
set(handles.edit1, 'String', val*255);
set(handles.slider1, 'Value', val*255);


% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imag;
axes(handles.axes1);
val =get(hObject,'value');
switch val
    case 1
        imag2=imag;
    case 2
        imag2=edge(imag,'sobel');
        title('sobel'); 
    case 3
        imag2=edge(imag,'roberts');   
        title('roberts'); 
    case 4
        imag2=edge(imag,'prewitt');  
        title('prewitt'); 
    case 5
        imag2=edge(imag,'log');   
        title('log'); 
    case 6
        imag2=edge(imag,'canny');
        title('canny'); 
end

imshow(imag2)
        
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu


% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
