function varargout = DI_remove(varargin)
% DI_REMOVE MATLAB code for DI_remove.fig
%      DI_REMOVE, by itself, creates a new DI_REMOVE or raises the existing
%      singleton*.
%
%      H = DI_REMOVE returns the handle to a new DI_REMOVE or the handle to
%      the existing singleton*.
%
%      DI_REMOVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DI_REMOVE.M with the given input arguments.
%
%      DI_REMOVE('Property','Value',...) creates a new DI_REMOVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DI_remove_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DI_remove_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DI_remove

% Last Modified by GUIDE v2.5 19-Jan-2019 17:36:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DI_remove_OpeningFcn, ...
                   'gui_OutputFcn',  @DI_remove_OutputFcn, ...
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


% --- Executes just before DI_remove is made visible.
function DI_remove_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DI_remove (see VARARGIN)

% Choose default command line output for DI_remove
handles.output = hObject;

global mom_handles
mom_handles = varargin{2};
global imag;
imag=varargin{1};
% val=graythresh(imag);
% imag = im2bw(imag,val); 
axes(handles.axes1);
imshow(imag);title('Remove small area');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DI_remove wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DI_remove_OutputFcn(hObject, eventdata, handles) 
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
im = handles.axes1.Children.CData;
area = regionprops(im,{'centroid','area'});
% a=[area.Area];
% Max=max(a);
% Sum=sum(a(1,:));
a=cat(1,area.Area);
if(~isempty(a))
    Max=max(a);
    Sum=sum(a);
    index=find(a==Max);
    point=area(index).Centroid;
    point=floor(point);  %½è¤ß®y¼Ðx,y
else
    Max=0;
    Sum=0;
end


titl=strcat('Max :',num2str(Max),',  Sum :',num2str(Sum))
axes(mom_handles.Faxes);
imshow(im);title(titl);
%text(point(1)+10,point(2),'A1','Color','R','FontSize',20);
 close(gcbf); 


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=get(handles.slider1, 'Value');
value=floor(value);
position = num2str(value);
set(handles.edit1, 'String', position);

global imag;
imag =double(imag);
TImag = (bwareaopen(imag,value));
axes(handles.axes1);
imshow(TImag);title('Remove small obj');

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 close(gcbf); 



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(handles.edit1, 'String'));
max=1000;min=0;
if(value>max)
    value=max;
    set(handles.edit1, 'String', value);
elseif(value<min)
    value=min;
    set(handles.edit1, 'String', value);
end
set(handles.slider1, 'Value', value);

global imag;
TImag = (bwareaopen(imag,value));
axes(handles.axes1);
imshow(TImag);title('Remove small obj');
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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
