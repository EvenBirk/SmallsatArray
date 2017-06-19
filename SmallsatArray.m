
function varargout = SmallsatArray(varargin)
% SmallsatArray MATLAB code for SmallsatArray.fig
%      SmallsatArray, by itself, creates a new SmallsatArray or raises the existing
%      singleton*.
%
%      H = SmallsatArray returns the handle to a new SmallsatArray or the handle to
%      the existing singleton*.
%
%      SmallsatArray('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SmallsatArray.M with the given input arguments.
%
%      SmallsatArray('Property','Value',...) creates a new SmallsatArray or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SmallsatArray_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SmallsatArray_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SmallsatArray

% Last Modified by GUIDE v2.5 17-Jun-2017 03:49:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SmallsatArray_OpeningFcn, ...
                   'gui_OutputFcn',  @SmallsatArray_OutputFcn, ...
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


% --- Executes just before SmallsatArray is made visible.
function SmallsatArray_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SmallsatArray (see VARARGIN)

% Choose default command line output for SmallsatArray
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SmallsatArray wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%-------------------Variable initialisation--------------------------------
global res thetalim philim f theta phi thetar phir Element c plotlims E ImportedEF PlotData Version

Version = 1.0;

% Setting up fundamental constants and variables
res         = round(str2num(get(handles.res,'String')));

funit       = get(handles.funit,'Value');
f           = 10^(3*funit)*str2num(get(handles.f,'String'));

thetalim    = [0,180];
philim      = [0,360];

theta       = thetalim(1):thetalim(2);
thetar      = d2r(theta);
phi         = philim(1):philim(2);
phir        = d2r(phi);

plotlims.dB = [-30,40];
plotlims.lin= [0,30];

c           = 299792458;
% Setting up element class
%Element     = Antenna;

Element     = struct('Type', [], 'Excitation', [], 'Position', [],...
    'Rotation', [], 'Dimensions', [], 'E', [], 'Tag', [], 'Compare', [],...
    'CurrentRotation', [], 'Version', [], 'E_nonrot', []);

% Type:         String
% Excitation:   [Amplitude (double), Phase (radians)]
% Position:     [posX, posY, posZ]
% Rotation:     [alpha, beta, gamma]
% CurrentRotation: --||--
% Dimension:    Depends om type [length, depth, height, radius]
% E:            Struct with fields 'Theta' and 'Phi' containing complex
%               numbers
% Version:      

E = struct('Theta',zeros(length(phir),length(thetar)),'Phi',zeros(length(phir),length(thetar)));

ImportedEF = [];

PlotData = [];

%-------------------GUI initialisation-------------------------------------
%Polar axes
axes(handles.gainPlot); %Set axes focus
polarplot(0,0); %Setting graph to polar
%Setting plot tag
ax      = gca;
t       = ax.Tag;
ax.Tag  = 'gainPlot';

ax = gca;
d  = ax.ThetaDir;
ax.ThetaDir          = 'counterclockwise';
ax.ThetaZeroLocation = 'top';

rlim([0 1]); %Set polarplot max and min values
%rticks([0.25 0.5 0.75 1]);

%plotAngSlider
min     = -180;
max     =  180;

set(handles.plotAngSlider,'Min',min);
set(handles.plotAngSlider,'Max',max);
set(handles.plotAngSlider,'SliderStep',[res/(max-min) res*5/(max-min)]);
set(handles.plotAngSlider,'Value',90);

%plotAng
set(handles.plotAng,'String','90');

%Clear element table
set(handles.elmTab,'Data',[]);

%Hide dimensions option
handles.dimText.Visible     = 'off';
handles.lengthText.Visible  = 'off';
handles.elmLength.Visible   = 'off';


% --- Outputs from this function are returned to the command line.
function varargout = SmallsatArray_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




%--------------------------------------------------------------------------
%**************************************************************************
%
%                         CREATE FUNCTIONS
%
%**************************************************************************
%--------------------------------------------------------------------------


%-------------------SATELLITE DIMENTIONS-----------------------------------

% --- Executes during object creation, after setting all properties.
function depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------ELEMENT PROPERTIES-------------------------------------


% --- Executes during object creation, after setting all properties.
function elmAmp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmFace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmFace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmPha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmPha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmPosX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmPosX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmPosY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmPosY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmPosZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmPosZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmBeta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmBeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmGamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function elmTyp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elmTyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function nslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%-------------------SYSTEM AND PROGRAM-------------------------------------

% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function funit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to funit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function res_CreateFcn(hObject, eventdata, handles)
% hObject    handle to res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%-------------------PLOTTING OPTIONS---------------------------------------


% --- Executes during object creation, after setting all properties.
function plotAng_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotAng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plotAngSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotAngSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function plotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plotValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plotField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dBmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dBmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         CALLBACK FUNCTIONS
%
%**************************************************************************
%--------------------------------------------------------------------------



%-------------------SATELLITE DIMENTIONS-----------------------------------


function depth_Callback(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of depth as text
%        str2double(get(hObject,'String')) returns contents of depth as a double


function length_Callback(hObject, eventdata, handles)
% hObject    handle to length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of length as text
%        str2double(get(hObject,'String')) returns contents of length as a double


function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


%-------------------ELEMENT PROPERTIES-------------------------------------


% --- Executes when selected cell(s) is changed in elmTab.
function elmTab_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to elmTab (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% Object handles, for reference
u=[handles.elmTyp; 
   handles.elmLength;
   handles.elmAmp;
   handles.elmPha; 
   handles.elmPosX; 
   handles.elmAlpha];


% Registering selectet cell
table.currentCell = eventdata.Indices;

if isempty(eventdata.Indices)
    return;
elseif table.currentCell(2) == 7 %Compare checkbox
%     comp = handles.elmTab.Data(table.currentCell(1),table.currentCell(2));
%     Element(table.currentCell(1)).Compare = comp{1};
    return;
end
n    = table.currentCell(1);
parm = table.currentCell(2);

% Updating GUI input fields
UpdElmNo(handles,n);

UpdateInputFields(handles,n);

% Update highlighted object
uicontrol(u(parm));


function elmAmp_Callback(hObject, eventdata, handles)
% hObject    handle to elmAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmAmp as text
%        str2double(get(hObject,'String')) returns contents of elmAmp as a double



% --- Executes on selection change in elmFace.
function elmFace_Callback(hObject, eventdata, handles)
% hObject    handle to elmFace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns elmFace contents as cell array
%        contents{get(hObject,'Value')} returns selected item from elmFace


function elmLength_Callback(hObject, eventdata, handles)
% hObject    handle to elmLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmLength as text
%        str2double(get(hObject,'String')) returns contents of elmLength as a double


function elmPha_Callback(hObject, eventdata, handles)
% hObject    handle to elmPha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmPha as text
%        str2double(get(hObject,'String')) returns contents of elmPha as a double


% --- Executes on selection change in elmTyp.
function elmTyp_Callback(hObject, eventdata, handles)
% hObject    handle to elmTyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns elmTyp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from elmTyp

if strcmp(hObject.String(hObject.Value),'Import...')
    %Hide dimensions option
    handles.dimText.Visible     = 'off';
    handles.lengthText.Visible  = 'off';
    handles.elmLength.Visible   = 'off';
    
    %Prompt import
    ImportElement(handles);
elseif strcmp(hObject.String(hObject.Value),'Dipole')
    %Show dimensions option
    handles.dimText.Visible     = 'on';
    handles.lengthText.Visible  = 'on';
    handles.elmLength.Visible   = 'on';
else
    %Hide dimensions option
    handles.dimText.Visible     = 'off';
    handles.lengthText.Visible  = 'off';
    handles.elmLength.Visible   = 'off';
end




function elmPosX_Callback(hObject, eventdata, handles)
% hObject    handle to elmPosX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmPosX as text
%        str2double(get(hObject,'String')) returns contents of elmPosX as a double


function elmPosY_Callback(hObject, eventdata, handles)
% hObject    handle to elmPosY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmPosY as text
%        str2double(get(hObject,'String')) returns contents of elmPosY as a double


function elmPosZ_Callback(hObject, eventdata, handles)
% hObject    handle to elmPosZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmPosZ as text
%        str2double(get(hObject,'String')) returns contents of elmPosZ as a double


function elmAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to elmAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmAlpha as text
%        str2double(get(hObject,'String')) returns contents of elmAlpha as a double


function elmBeta_Callback(hObject, eventdata, handles)
% hObject    handle to elmBeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmBeta as text
%        str2double(get(hObject,'String')) returns contents of elmBeta as a double


function elmGamma_Callback(hObject, eventdata, handles)
% hObject    handle to elmGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elmGamma as text
%        str2double(get(hObject,'String')) returns contents of elmGamma as a double



function n_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double

%Update slider
n = round(str2double(hObject.String));

UpdElmNo(handles,n);

if n > size(Element,2)
    return;
end

UpdateInputFields(handles,n);


% --- Executes on slider movement.
function nslider_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to nslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global Element

%Update n-editbox
n = round(hObject.Value);

UpdElmNo(handles,n);

if n > size(Element,2)
    return;
end

UpdateInputFields(handles,n);


% --- Executes on button press in updElm.
function updElm_Callback(hObject, eventdata, handles)
% hObject    handle to updElm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Updating GUI msgbox
UpdateMsgBox(handles,'Add/Update element...');

global Element

% Fetching element number
n=round(str2num(get(handles.n,'String')));

% Fetching array size (numper of elements)
N=size(Element,2);

% Ensuring new array elements are concatinated
if n>N+1
    n = N+1;
    UpdElmNo(handles,n);
end

% Reading and storing element properties
UpdateElm(handles, n);

% Calculate element factor
ElementFactor(handles, n);

% Rotate element
RotateElement(handles, n);

% Calculating total field
TotalField(handles);

% Updating GUI table
UpdateTable(handles, n);

% Updating plot
UpdatePlot(handles);

UpdateMsgBox(handles,'Add/Update element... Done!');




% --- Executes on button press in delElm.
function delElm_Callback(hObject, eventdata, handles)
% hObject    handle to delElm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Element

N = size(handles.elmTab.Data,1);
n = round(str2double(handles.n.String));

tabData = handles.elmTab.Data;

for i = n:N-1
    h            = tabData(i+1,:);
    tabData(i,:) = h;
    Element(i)   = Element(i+1);
end

tabData(N,:) = [];
Element(N)   = [];

handles.elmTab.Data = tabData;

TotalField(handles);
UpdatePlot(handles);
UpdateInputFields(handles,n);


% --- Executes when entered data in editable cell(s) in elmTab.
function elmTab_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to elmTab (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global Element

tabdat = handles.elmTab.Data;

I = eventdata.Indices;

tabdat{I(1),I(2)} = eventdata.EditData;

handles.elmTab.Data = tabdat;

Element(I(1)).Compare = eventdata.EditData;


%-------------------SYSTEM AND PROGRAM-------------------------------------

function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double

global f Element

funit       = get(handles.funit,'Value');

if ~isscalar(str2num(handles.f.String))
    handles.f.String = num2str(f/10^(3*funit));
    return;
end

f           = 10^(3*funit)*str2num(handles.f.String);

N = size(Element,2);

if N > 0 && isempty(Element(1).Type) == 0
    for n=1:N
        ElementFactor(handles, n);
        RotateElement(handles, n);
    end
    TotalField(handles);
    UpdatePlot(handles);
end


% --- Executes on selection change in funit.
function funit_Callback(hObject, eventdata, handles)
% hObject    handle to funit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns funit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from funit

global f Element

funit       = get(handles.funit,'Value');

if ~isscalar(str2num(handles.f.String))
    handles.f.String = num2str(f/10^(3*funit));
    return;
end

f           = 10^(3*funit)*str2num(handles.f.String);

N = size(Element,2);

if N > 0 && isempty(Element(1).Type) == 0
    for n=1:N
        ElementFactor(handles, n);
        RotateElement(handles, n);
    end
    TotalField(handles);
    UpdatePlot(handles);
end


function res_Callback(hObject, eventdata, handles)
% hObject    handle to res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of res as text
%        str2double(get(hObject,'String')) returns contents of res as a double

global res Element

%Round and update res gui
res = round(str2num(get(hObject,'String')));
handles.res.String  = num2str(res);


%Update plotslider values
min     = -180;
max     =  180;

set(handles.plotAngSlider,'Min',min);
set(handles.plotAngSlider,'Max',max);

set(handles.plotAngSlider,'SliderStep',[res/(max-min), res*5/(max-min)]);

N = size(Element,2);

if N > 0 && isempty(Element(1).Type) == 0
    for n=1:N
        ElementFactor(handles, n);
        RotateElement(handles, n);
    end
    TotalField(handles);
    UpdatePlot(handles);
end


% --- Executes on button press in opnFileBtn.
function opnFileBtn_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to opnFileBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Element Version

[filename, directory] = uigetfile('*.rpt');

if filename == 0
    return
end

data = importdata(strcat(directory,filename));

old = false;
if ~isfield(data,'Version')
    old = true;
elseif any(data(1).Version < Version)
    old = true;
end

if any(old)
    cont = questdlg(strcat({'Element(s) '},num2str(find(old)'),{' are from an older version and might not function properly'}),...
        'Continue?','Ok','Cancel','Ok');
    
    if strcmp(cont,'Cancel')
        return;
    end
end

combine = questdlg('Do you want to add the file to the array?','Add to array?','Open file','Add to array','Open file');

if strcmp(combine,'Open file')
    Element = [];
    Element = importdata(strcat(directory,filename));
    
    tabdat = handles.elmTab.Data;
    clear tabdat
    newRow      = repmat({''},1,7);
    tabdat(1,:) = newRow(:);
    handles.elmTab.Data = tabdat;
elseif strcmp(combine,'Add to array')
    N = size(Element,2);
    
    Element = horzcat(Element,importdata(strcat(directory,filename)));
else
    return;
end



for n = 1:size(Element,2)
    UpdateTable(handles, n);
end

TotalField(handles);

UpdatePlot(handles);

handles.elmTyp.Value = find(not(cellfun('isempty',strfind(handles.elmTyp.String,Element(n).Type))));;


% --- Executes on button press in exportBtn.
function exportBtn_Callback(hObject, eventdata, handles)
% hObject    handle to exportBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, directory] = uiputfile({'*.png'});

if filename == 0
    return
end

[az,el] = view;

tempFig = figure(2);
tempPlot = plot(0,0);

UpdatePlot(handles);

view(az,el);

saveas(gcf,strcat(directory,filename));

close(tempFig);

% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Element E Version

if size(Element,2) < 1
    UpdateMsgBox(handles,'No data to save');
    return
elseif isempty(Element(1).Type)
    UpdateMsgBox(handles,'No data to save');
    return
end

all           = 'Save all array elements';
single        = 'Save array as single element';

format        = questdlg('Save As...',...
            'Select output option',all,...
            single,all);

if isempty(format)
    return;
end

[filename, directory] = uiputfile('*.rpt');

if filename == 0
    return;
end

if strcmp(format,all)
    save(strcat(directory,filename),'Element');
elseif strcmp(format,single)
    A.Type          = 'Misc';
    A.Excitation    = 1;
    A.Position      = [0,0,0];
    A.Rotation      = [0,0,0];
    A.Dimensions    = '-';
    A.E             = E;
    A.Tag           = filename;
    A.Version       = Version;
    
    save(strcat(directory,filename),'A');
else
    return
end


%-------------------PLOTTING OPTIONS---------------------------------------

% --- Executes on button press in dbCheck.
function dbCheck_Callback(hObject, eventdata, handles)
% hObject    handle to dbCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dbCheck

UpdatePlot(handles);


function plotAng_Callback(hObject, eventdata, handles)
% hObject    handle to plotAng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotAng as text
%        str2double(get(hObject,'String')) returns contents of plotAng as a double

global res Element

v=round(str2num(get(hObject,'String'))/res)*res;

set(hObject,'String',num2str(v));
set(handles.plotAngSlider,'Value',v);

compare = {Element(:).Compare};

props = whos('compare');

switch props.class
    case 'cell'
        compare = cell2mat(compare);
end

if any(compare)
    UpdatePlot(handles);
else
    PlotData(handles);
end


% --- Executes on slider movement.
function plotAngSlider_Callback(hObject, eventdata, handles)
% hObject    handle to plotAngSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global res Element

v=round(get(hObject,'Value')/res)*res;
set(handles.plotAng,'String',num2str(v));

compare = {Element(:).Compare};

props = whos('compare');

switch props.class
    case 'cell'
        compare = cell2mat(compare);
end

if any(compare)
    UpdatePlot(handles);
else
    PlotData(handles);
end


% --- Executes on selection change in plotType.
function plotType_Callback(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotType
global Element

compare = {Element(:).Compare};

props = whos('compare');

switch props.class
    case 'cell'
        compare = cell2mat(compare);
end

if any(compare)
    UpdatePlot(handles);
else
    PlotData(handles);
end


% --- Executes on selection change in plotValue.
function plotValue_Callback(hObject, eventdata, handles)
% hObject    handle to plotValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotValue contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotValue

UpdatePlot(handles);


% --- Executes on selection change in plotField.
function plotField_Callback(hObject, eventdata, handles)
% hObject    handle to plotField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotField contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotField

UpdatePlot(handles);


% --- Executes on button press in normCheck.
function normCheck_Callback(hObject, eventdata, handles)
% hObject    handle to normCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normCheck

UpdatePlot(handles);


% --- Executes on button press in plotBtn.
function plotBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UpdatePlot(handles);


% --- Executes when selected object is changed in plotplane.
function plotplane_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in plotplane 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Element

compare = {Element(:).Compare};

props = whos('compare');

switch props.class
    case 'cell'
        compare = cell2mat(compare);
end

if any(compare)
    UpdatePlot(handles);
else
    PlotData(handles);
end


function dBmin_Callback(hObject, eventdata, handles)
% hObject    handle to dBmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dBmin as text
%        str2double(get(hObject,'String')) returns contents of dBmin as a double

global plotlims

if ~isscalar(str2num(hObject.String)) || not(str2num(hObject.String) < plotlims.dB(2))
    hObject.String = num2str(plotlims.dB(1));
    return;
end

plotlims.dB(1) = str2num(hObject.String);

UpdatePlot(handles);

% --- Executes on button press in smoothen.
function smoothen_Callback(hObject, eventdata, handles)
% hObject    handle to smoothen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothen

UpdatePlot(handles);


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         USER FUNCTIONS
%
%**************************************************************************
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         CORE CALCULATION FUNCTIONS
%
%**************************************************************************
%--------------------------------------------------------------------------

%-------------------Update Element variable with element properties--------

function UpdateElm(handles,n)
UpdateMsgBox(handles, 'Reading element properties...');
global Element Version

eTyp=handles.elmTyp.String;

% Prevent changing the element type to 'Import...' if the antenna element 
% already has an imported radiation pattern
if size(Element,2) < n
    Element(n).Type = eTyp{handles.elmTyp.Value};
elseif not(strcmp(Element(n).Type,'Imported'))
    Element(n).Type = eTyp{handles.elmTyp.Value};
end


if ~strcmp(Element(n).Type,{'Import...','Imported'})
    Element(n).Tag = Element(n).Type;
end

Element(n).Excitation   = str2num(get(handles.elmAmp,'String'))*...
                          exp(1i*d2r(str2num(get(handles.elmPha,'String'))));
                      
Element(n).Position     =[str2num(get(handles.elmPosX,'String')),...
                          str2num(get(handles.elmPosY,'String')),...
                          str2num(get(handles.elmPosZ,'String'))];
                      
Element(n).Rotation     =[d2r(str2num(get(handles.elmAlpha,'String'))),...
                          d2r(str2num(get(handles.elmBeta,'String'))),...
                          d2r(str2num(get(handles.elmGamma,'String')))];

Element(n).Dimensions   = struct(...
    'Length',str2num(get(handles.elmLength,'String')));

Element(n).Version = Version;

UpdateMsgBox(handles, 'Reading element properties...Done!');


%-------------------Import Element-----------------------------------------
function ImportElement(handles)
UpdateMsgBox(handles,'Importing element data...');

% Fetching element number
n = round(str2num(handles.n.String));

global Element thetar phir

% Prompting format selection
format        = questdlg('Select input format',...
    'Select input format','CST','HFSS','CST');

switch format
    case 'CST'
        [cstfile,directory]     = uigetfile('*.txt','Select a file to import');
        
        % Checking valid input
        if cstfile == 0
            UpdateMsgBox(handles,'Importing element data failed.');
            return;
        end
        
        % Clearing variable
        if not(size(Element,2)>n)
            Element(n).E_nonrot=[];
        end
        
        Element(n).Tag = cstfile;
        
        
        %Assuming input format:
        %Theta|Phi|Abs(tot)|Abs(theta)|Phase(theta)|Abs(phi)|Phase(phi)|Ax.Ratio
        
        A = cstread(strcat(directory,cstfile));
        H = cstheadread(strcat(directory,cstfile));
        
        %Checking angle units units
        if strcmp(H{2},'[deg.]')
            angleunit = 'deg';
        else
            error('elmTyp_Callback: Unknown angle unit');
        end
        
        % Calculating resolution
        ImportedEF.res = A(2,1)-A(1,1);
        
        % Reading data and storing in desired data structures and
        % units
        for i=1:size(A,1)
            t_idx = A(i,1)/ImportedEF.res+1;
            p_idx = A(i,2)/ImportedEF.res+1;
            ImportedEF.theta(p_idx,t_idx)   = A(i,4);
            ImportedEF.phi(p_idx,t_idx)     = A(i,6);
            %ImportedEF.tot(p_idx,t_idx)=A(i,3);
            ImportedEF.t_phase(p_idx,t_idx) = A(i,5);
            ImportedEF.p_phase(p_idx,t_idx) = A(i,7);
        end
        
        % Checking scale
        if any(strfind(H{6},'dB'))
            ImportedEF.theta   = dB2lin(ImportedEF.theta);
            ImportedEF.phi     = dB2lin(ImportedEF.phi);
        end
        
        % Checking unit for power
        if any(strcmp(H{5},{'Abs(Grlz)','Abs(Dir.)','Abs(Gain)','Abs(P)'})) || any(strcmp(H{5},{'Abs(E)','Abs(V)','Abs(H)'})) && any(strfind(H{6},'dB'))
            ImportedEF.theta   = sqrt(ImportedEF.theta);
            ImportedEF.phi     = sqrt(ImportedEF.phi);
        end
        
        if any(strcmp(H{5},{'Abs(H)'}))
            thetamag   = ImportedEF.theta;
            thetaphase = ImportedEF.t_phase;
            
            ImportedEF.theta   = ImportedEF.phi;
            ImportedEF.t_phase = ImportedEF.p_phase;
            
            ImportedEF.phi     = thetamag;
            ImportedEF.p_phase = thetaphase;
        end
        
        
    case 'HFSS'
        [FileName,PathName,FilterIndex] = uigetfile('*.csv','Select a file to import');
        A = csvread(strcat(PathName,FileName),1,0);
        
        Element(n).Tag = FileName;
        
        % Calculating resolution
        ImportedEF.res = abs(A(1,1)-A(2,1));
        
        % Reading data and storing in desired data structures and
        % units
        for i=1:size(A,1)
            [i_p, i_t]=r2t(d2r(A(i,2)), d2r(A(i,1)), ImportedEF.res);
            
            ImportedEF.theta(i_p,i_t)=dB2lin(A(i,3));
            ImportedEF.phi(i_p,i_t)=dB2lin(A(i,4));
            ImportedEF.tot(i_p,i_t)=...
                sqrt(ImportedEF.theta(i_p,i_t)^2+...
                ImportedEF.phi(i_p,i_t)^2);
        end
        ImportedEF.t_phase=zeros(size(ImportedEF.theta));
        ImportedEF.p_phase=zeros(size(ImportedEF.phi));
        
    otherwise
        return;
end


Element(n).E_nonrot.Theta =...
    Interpol2(ImportedEF.theta,ImportedEF.t_phase,thetar,phir);
Element(n).E_nonrot.Phi   =...
    Interpol2(ImportedEF.phi,ImportedEF.p_phase,thetar,phir);

Element(n).Type = 'Imported';

Element(n).CurrentRotation = [0,0,0];


UpdateMsgBox(handles,'Importing element data... Done!');


%-------------------Reading text files exported by CST---------------------
function [A] = cstread(filename)
% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\Ola\git\master-thesis\NorSat-3_FF.txt
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/03/28 15:35:09

% Initialize variables.
%filename = 'C:\Users\Ola\git\master-thesis\NorSat-3_FF.txt';
%filename = uigetfile('*.txt','Select a file to import');
startRow = 3;

% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%8f%16f%21f%20f%20f%20f%20f%20f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

% Create output variable
A = [dataArray{1:end-1}];
% Clear temporary variables
clearvars filename startRow formatSpec fileID dataArray ans;


%-------------------Read the header from the CST-file----------------------
function [H] = cstheadread(filename)

fileID = fopen(filename,'r');
s    = fscanf(fileID,'%c');
fclose(fileID);

h{1} = '';
i    = 1;
j    = 1;
while s(i) ~= '-' 
    if strcmp(s(i),' ') && (not(strcmp(s(i-1),' ')) || not(strcmp(s(i-1),'')))
        j = j + 1;
        h{j} = '';
    elseif s(i) == ']' || s(i) == ')'
        h{j} = strcat(h{j},s(i));
        j = j + 1;
        h{j} = '';
    elseif strcmp(s(i),'[')
        j = j + 1;
        h{j} = s(i);
    else
        h{j} = strcat(h{j},s(i));
    end
    
    i = i + 1;
end

j = 1;
%H = cell(1);
for i=1:length(h)
    if strcmp(h{i},']') || strcmp(h{i},')')
        H{j-1} = strcat(H{j-1},h{i});
    elseif strcmp(h{i},'')
        continue;
    else
        H{j} = h{i};
        j = j + 1;
    end
end

%-------------------Calculate element factor-------------------------------
%Calculates normalised E field
function ElementFactor(handles, n)

% Updating GUI msgbox
UpdateMsgBox(handles, strcat({'Calculating element factor for element '},num2str(n),'...'));

global f thetar phir Element c

Element(n).Compare = false;

% Defining canstants for calculations
k = 2*pi*f/c;

switch Element(n).Type
    case 'Isotropic'
        Element(n).E_nonrot.Theta  = ones(length(phir),length(thetar));
        Element(n).E_nonrot.Phi    = zeros(length(phir),length(thetar));
        Element(n).CurrentRotation = [0,0,0];
    case 'Dipole'
        l = Element(n).Dimensions.Length;
        
        Element(n).E_nonrot.Theta = 1i*ones(length(phir),length(thetar)).*...
                            (cos(pi*l*cos(thetar))-cos(pi*l))./sin(thetar);
        
        nans = isnan(Element(n).E_nonrot.Theta);
        
        Element(n).E_nonrot.Theta(nans) = 0;
        
        Element(n).E_nonrot.Phi   = zeros(length(phir),length(thetar));
        
        Element(n).CurrentRotation = [0,0,0];
        
    case 'Import...'
        % Checking for if element has been imported
        ImportElement(handles);
    otherwise
        
end

%Normalising to RMS value of field
UpdateMsgBox(handles,'Normalising field...');
[Element(n).E_nonrot.Theta,Element(n).E_nonrot.Phi] = RMSField(Element(n).E_nonrot.Theta,Element(n).E_nonrot.Phi,'dB',0,'Power',0);
UpdateMsgBox(handles,'Normalising field... Done!');

UpdateMsgBox(handles, strcat('Calculating element factor for element ',num2str(n),'... Done!'));


%-------------------Calculate total field----------------------------------
function TotalField(handles)

UpdateMsgBox(handles, strcat('Calculating total field...'));

global E thetar phir f Element c

%Reading array size
N   = size(Element,2);

%Setting up constants for calculation
k   = 2*pi*f/c;

%Clearing E variable
E.Theta     = zeros(length(phir),length(thetar));
E.Phi       = zeros(length(phir),length(thetar));

for n=1:N
    PHIx    = exp(1i*k*Element(n).Position(1)*cos(phir')*sin(thetar));
    PHIy    = exp(1i*k*Element(n).Position(2)*sin(phir')*sin(thetar));
    PHIz    = exp(1i*k*Element(n).Position(3)*ones(length(phir),1)*cos(thetar));
    PHIsp   = PHIx.*PHIy.*PHIz;
    
    E.Theta = E.Theta + Element(n).E.Theta.*PHIsp.*Element(n).Excitation;
    E.Phi   = E.Phi +   Element(n).E.Phi  .*PHIsp.*Element(n).Excitation;
end

UpdateMsgBox(handles,'Normalising field...');
[E.Theta,E.Phi] = RMSField(E.Theta,E.Phi,'dB',false);
UpdateMsgBox(handles,'Normalising field... Done!');
E.Abs = sqrt(abs(E.Theta).^2+abs(E.Phi.^2));


UpdateMsgBox(handles, strcat('Calculating total field... Done!'));


%-------------------Rotates element n--------------------------------------
function RotateElement(handles, n)
global thetar phir res Element

Rotation = Element(n).Rotation-Element(n).CurrentRotation;

if Element(n).Rotation == [0,0,0]
    Element(n).E = Element(n).E_nonrot;
    return;
elseif Rotation == [0,0,0]
    return;
else
    Rotation = Element(n).Rotation;
end

UpdateMsgBox(handles, strcat('Rotating element ',num2str(n),'...'));


% Reverse order rotation without interpolation

% Setting up rotation matrix for reverse rotation
Rr      = rotZ(-Rotation(3))*rotY(-Rotation(2))*...
          rotZ(-Rotation(1));

% Setting up rotation matrix for regular rotation
Rf      = rotZ(Rotation(1))*rotY(Rotation(2))*...
          rotZ(Rotation(3));

% [theta,phi] = meshgrid(thetar,phir');
% 
% [x,y,z]     = s2c(theta,phi,1);
% 
% v           = Rr*[x;y;z];
      
for i=1:length(thetar)
    for ii=1:length(phir)
        %Setting up index vector for rotation
        [x,y,z]     = s2c(thetar(i),phir(ii),1);
        
        %Rotating index vector reversely
        v           = Rr*[x;y;z];
        
        %Converting index vector to spherical coordinates
        [u(1),u(2),u(3)] = c2s(v(1),v(2),v(3));
        
        %Converting index vector to matrix indecies
        [i_p,i_t]   = r2t(u(1),u(2),res);
                
        %Setting up field vector for rotation
        %Theta component spherical vector coverted to Cartesian
        [Et(1),Et(2),Et(3)] = s2c(thetar(i_t)+pi/2,phir(i_p),Element(n).E_nonrot.Theta(i_p,i_t));
        
        %Phi component spherical vector coverted to Cartesian
        [Ep(1),Ep(2),Ep(3)] = s2c(pi/2,phir(i_p)+pi/2,Element(n).E_nonrot.Phi(i_p,i_t));
        
        %Combining field components
        E  = Et+Ep;
        
        %Rotating field vector
        rE = Rf*[E(1),E(2),E(3)]';
        %rEt = Rf*[Et(1),Et(2),Et(3)]';
        %rEp = Rf*[Ep(1),Ep(2),Ep(3)]';
        
        %Creating reference tangential vectors at target rotation
        [v_ref_t(1),v_ref_t(2),v_ref_t(3)]=s2c(thetar(i)+pi/2,phir(ii),1);
        [v_ref_p(1),v_ref_p(2),v_ref_p(3)]=s2c(pi/2, phir(ii)+pi/2,1);
        
        %Decomposing rotated field vector using tangential reference vector
        %Et = dot(rEt,v_ref_t)+dot(rEp,v_ref_t);
        %Ep = dot(rEt,v_ref_p)+dot(rEp,v_ref_p);
        
        Et = dot(rE,v_ref_t);
        Ep = dot(rE,v_ref_p);
        
        %Removing NaN values
        if isnan(Et)
            Et = 0;
        end
        if isnan(Ep)
            Ep = 0;
        end
                
        %Writing to element variable
        Element(n).E.Theta(ii,i) = Et;
        Element(n).E.Phi(ii,i)   = Ep;
    end
end

Element(n).CurrentRotation = Element(n).Rotation;

UpdateMsgBox(handles, strcat('Rotating element ',' ',num2str(n),'... Done!'));


%-------------------Update plot--------------------------------------------
function UpdatePlot(handles)
UpdateMsgBox(handles,'Updating plot...');

global Element

compare = {Element(:).Compare};

props = whos('compare');

switch props.class
    case 'cell'
        compare = cell2mat(compare);
end

if ~any(compare) || nnz(compare) == 1
    
    CalcPlotData(handles)
    
    ScalePlotData(handles);
    
    PlotData(handles);
    
else
    
    s = handles.plotType.String(handles.plotType.Value);
    if strcmp(s,'2D') || strcmp(s,'3D')
        return;
        error('Cannot compare in 2D or 3D plot');
    end
    
    k = 1;
    for n=1:length(compare)
        if compare(n) && k == 1
            CalcCompPlotData(handles,n)
            
            ScalePlotData(handles);
            
            PlotData(handles);
            
            k = k + 1;
            
        elseif compare(n)
            CalcCompPlotData(handles,n)
            
            ScalePlotData(handles);
            
            hold on
            PlotData(handles);
            hold off
            
            k = k + 1;
        end
    end
end
UpdateMsgBox(handles,'Updating plot... Done!');


%-------------------Calculate plot data------------------------------------
function CalcPlotData(handles)
UpdateMsgBox(handles,'Calculating plot data...');
global E PlotData

PlotData    = [];
s           = handles.plotValue.String;
k           = handles.plotValue.Value;

switch s{k}
    case 'Abs'
        PlotData = sqrt(abs(E.Theta).^2 + abs(E.Phi).^2);
    case 'Theta'
        PlotData = abs(E.Theta);
    case 'Theta Phase'
        PlotData = angle(E.Theta);
    case 'Phi'
        PlotData = abs(E.Phi);
    case 'Phi Phase'
        PlotData = angle(E.Phi);
    case 'Axial Ratio'
        Em = E.Theta - 1i.*E.Phi;
        Ep = E.Theta + 1i.*E.Phi;
        
        t  = angle(Em./Ep)./2;
        
        Ex = E.Theta.*sin(t)-E.Phi.*cos(t);
        Ey = E.Theta.*cos(t)-E.Phi.*sin(t);
        
        PlotData = abs(Ey./Ex);
    case 'Theta/Phi'
        PlotData = abs(E.Theta)./abs(E.Phi);
    case 'Phi/theta'
        PlotData = abs(E.Phi)./abs(E.Theta);
end

% Field pattern or power pattern
s2  = handles.plotField.String;
k2  = handles.plotField.Value;

if strcmp(s2{k2},'Directivity') && not(strcmp(s{k}, 'Axial Ratio'))
    PlotData = PlotData.^2;
% elseif strcmp(s2{k2},'E-pattern') && not(strcmp(s{k}, 'Axial Ratio'))
%     PlotData = PlotData.*4.0862;
%     if handles.dbCheck.Value == true
%         PlotData = PlotData.^2;
%     end
end
UpdateMsgBox(handles,'Calculating plot data... Done!');

%-------------------Calculates plot data for compare mode------------------
function CalcCompPlotData(handles, n)
UpdateMsgBox(handles,strcat({'Calculating plot data for element '},num2str(n),'...'));
global Element PlotData

PlotData    = [];
s           = handles.plotValue.String;
k           = handles.plotValue.Value;

switch s{k}
    case 'Abs'
        PlotData = sqrt(abs(Element(n).E.Theta).^2 + abs(Element(n).E.Phi).^2);
    case 'Theta'
        PlotData = abs(Element(n).E.Theta);
    case 'Theta Phase'
        PlotData = angle(Element(n).E.Theta);
    case 'Phi'
        PlotData = abs(Element(n).E.Phi);
    case 'Phi Phase'
        PlotData = angle(Element(n).E.Phi);
    case 'Axial Ratio'
        Em = Element(n).E.Theta - 1i.*Element(n).E.Phi;
        Ep = Element(n).E.Theta + 1i.*Element(n).E.Phi;
        
        t  = angle(Em./Ep)./2;
        
        Ex = Element(n).E.Theta.*sin(t)-Element(n).E.Phi.*cos(t);
        Ey = Element(n).E.Theta.*cos(t)-Element(n).E.Phi.*sin(t);
        
        PlotData = abs(Ey./Ex);
    case 'Theta/Phi'
        PlotData = abs(Element(n).E.Theta)./abs(Element(n).E.Phi);
    case 'Phi/theta'
        PlotData = abs(Element(n).E.Phi)./abs(Element(n).E.Theta);
end

% Field pattern or power pattern
s2  = handles.plotField.String;
k2  = handles.plotField.Value;

if strcmp(s2{k2},'Directivity') && not(strcmp(s{k}, 'Axial Ratio'))
    PlotData = PlotData.^2;
elseif strcmp(s2{k2},'E-pattern') && not(strcmp(s{k}, 'Axial Ratio'))
    PlotData = PlotData.*4.0862;
    if handles.dbCheck.Value == true
        PlotData = PlotData.^2;
    end
end
UpdateMsgBox(handles,strcat({'Calculating plot data for element '},num2str(n),'... Done!'));


%-------------------Scale plot data for plot options-----------------------
function ScalePlotData(handles)
UpdateMsgBox(handles,'Scaling plot data...');
%Manual settings
smoothen.bool = handles.smoothen.Value;
%smoothen.bool = true;
smoothen.n = 10;

global PlotData E plotlims thetar phir

norm    = handles.normCheck.Value;
dB      = handles.dbCheck.Value;

s           = handles.plotValue.String;
k           = handles.plotValue.Value;

switch s{k}
    case {'Abs', 'Theta', 'Phi'}
        
        switch norm
            case true
                m = max(max(PlotData));
                
                PlotData = PlotData./m;
            case false
                
        end
        
        switch dB
            case true
                PlotData = 10.*log10(PlotData);
            case false
                
        end
        
    case 'Axial Ratio'

end

% Removing NaN, Inf and too small values
for i=1:size(PlotData,2)
    for ii=1:size(PlotData,1)
        switch dB
            case true
                if PlotData(ii,i) > plotlims.dB(2)
                    PlotData(ii,i) = plotlims.dB(2);
                elseif PlotData(ii,i) < plotlims.dB(1) || isnan(PlotData(ii,i))
                    PlotData(ii,i) = plotlims.dB(1);
                end
            case false
                if PlotData(ii,i) > plotlims.lin(2)
                    PlotData(ii,i) = plotlims.lin(2);
                elseif PlotData(ii,i) < plotlims.lin(1) || isnan(PlotData(ii,i))
                    PlotData(ii,i) = plotlims.lin(1);
                end
        end
    end
end

if smoothen.bool == true
    if 1 %Stable
    for i=1:size(PlotData,2)
        PlotData(:,i) = smooth(PlotData(:,i),smoothen.n);
    end
    
    for i=1:size(PlotData,1)
        PlotData(i,:) = smooth(PlotData(i,:),smoothen.n);
    end
    
    else %Experimental
    
    [theta3,phi3] = meshgrid(thetar,phir);
    
    if dB == true
        rho3 = PlotData - plotlims.dB(1);
    else
        rho3 = PlotData;
    end
    
    [X,Y,Z] = s2c(theta3,phi3,rho3);
    
    V(:,:,1) = X;
    V(:,:,2) = Y;
    V(:,:,3) = Z;
    
    W = smooth3(V);
    
    %[theta3,phi3,rho3] = c2s(W(:,:,1),W(:,:,2),W(:,:,3));
    
    PlotData=sqrt(W(:,:,1).^2+W(:,:,2).^2+W(:,:,3).^2);
    end
end
UpdateMsgBox(handles,'Scaling plot data... Done!');


%-------------------Plot Data----------------------------------------------
function PlotData(handles)
UpdateMsgBox(handles,'Plotting...');
global PlotData res thetar phir plotlims Element

if isempty(PlotData)
    return;
end

PlotMat = [];

s   = handles.plotType.String;
k   = handles.plotType.Value;

dB      = handles.dbCheck.Value;
norm    = handles.normCheck.Value;

D0 = max(max(PlotData));
limits(2) = D0;

if dB == true
    limits(1) = plotlims.dB(1);
    if limits(2) < 0
        limits(2) = 0;
    end
else
    limits(1) = plotlims.lin(1);
    if limits(2) < 1
        limits(2) = 1;
    end
end

limits(2) = ceil(limits(2)*100)/100;

if limits(2) > 100
    limits(2) = 100;
end

if dB == true
    i = 2;
    ticks(1) = plotlims.dB(1)+10;
    while ticks(i-1)<limits(2)-10
        ticks(i) = plotlims.dB(1)+10*i;
        i = i + 1;
    end
    ticks(i) = limits(2);
else
    i = 2;
    ticks(1) = plotlims.lin(1)+0.25;
    while ticks(i-1)<limits(2)-0.25
        ticks(i) = plotlims.lin(1)+0.25*i;
        i = i + 1;
    end
    ticks(i) = limits(2);
end

switch s{k}
    case {'Polar', 'Rectangular'}
        Plane       = handles.plotplane.SelectedObject.String;
        PlaneAngle  = round(handles.plotAngSlider.Value);
        
        PlotMat(1,:) = 0:2*pi/360*res:2*pi;
        
        switch Plane
            case 'Phi'
                for i = 1:size(PlotMat,2)
                    [i_p, i_t]   = r2t(PlotMat(1,i),d2r(PlaneAngle),res);
                    
                    PlotMat(2,i) = PlotData(i_p,i_t);
                    
                    label = '\theta';
                end
            case 'Theta'
                PlotMat(2,:) = PlotData(:,mod(PlaneAngle,180)+1);
                
                label = '\phi';
                
                % For tilted theta plane:
%                 R = rotY(-(pi/2-d2r(PlaneAngle)));
%                 for i = 1:size(PlotData,1)
%                     [x,y,z]     = s2c(pi/2,phir(i),1);
%                     q           = R*[x,y,z]';
%                     [u,v,r]     = c2s(q(1),q(2),q(3));
%                     [i_p,i_t]   = r2t(u,v,res);
%                     PlotMat(2,i)= PlotData(i_p,i_t);
%                 end
        end
        
        switch s{k}
            case 'Polar'
                polarplot(PlotMat(1,:),PlotMat(2,:));
                rlim(limits);
                
                ax = gca;
                d  = ax.ThetaDir;
                ax.ThetaDir          = 'counterclockwise';
                ax.ThetaZeroLocation = 'top';
                
            case 'Rectangular'
                PlotMat(1,:) = r2d(PlotMat(1,:));
                plot(PlotMat(1,:),PlotMat(2,:));
                xlim([0,360]);
                ylim(limits);
                
                xlabel(label);
                
                if dB == true
                    ylabel('dB');
                    
                end
        end
        
        case '2D'
            [Y,X] = meshgrid(thetar,phir);

            X = r2d(X);
            Y = r2d(Y);
            
            R = PlotData-min(min(PlotData));
            Rmax = max(max(R));

            % Red
            C(:,:,1) = subplus(-cos(pi.*R./Rmax));
            % Green
            C(:,:,2) = sin(pi.*R./Rmax);
            % Blue
            C(:,:,3) = subplus(cos(pi.*R./Rmax));
            

            surf(X,Y,PlotData,C,'FaceColor','interp','MeshStyle','none');
            view(0,90);
            axis([0,360,0,180]);
            rotate3d off
            xlabel('\phi');
            ylabel('\theta');
            set(gca,'Ydir','reverse');
            
        case '3D'
        [az,el] = view;
            
        [theta3,phi3] = meshgrid(thetar,phir);
        
        if dB == true
            rho3 = PlotData - plotlims.dB(1);
        else
            rho3 = PlotData;
        end
        
        [X,Y,Z] = s2c(theta3,phi3,rho3);
        
        R       = sqrt(X.^2+Y.^2+Z.^2);
        Rmax    = max(max(R));
        
        % Colour matrix
        % Red
        C(:,:,1) = subplus(-cos(pi.*R./Rmax));
        % Green
        C(:,:,2) = sin(pi.*R./Rmax);
        % Blue
        C(:,:,3) = subplus(cos(pi.*R./Rmax));
            
        surf(X,Y,Z,C,'FaceColor','interp','MeshStyle','both','LineWidth',0.001,'EdgeAlpha',0.1,'LineStyle','-','EdgeLighting','none');
        set(gca,'DataAspectRatio',[1 1 1])
        h=rotate3d;
        set(h,'Enable','on');
        xlabel('x');
        ylabel('y');
        zlabel('z');
        
        view(az,el);
    otherwise
        error('Unsupported plot type');
        
        
end

%Filling inn supplimentary information
FieldTypeStr    = handles.plotField.String(handles.plotField.Value);
FieldValue      = handles.plotValue.String(handles.plotValue.Value);

switch FieldValue{1}
    case 'Abs'
        FieldValueStr = 'Absolute value';
    case 'Theta'
        FieldValueStr = 'Theta component';
    case 'Phi'
        FieldValueStr = 'Phi component';
    case 'Axial Ratio'
        FieldValueStr = 'Axial ratio';
end


if strcmp(FieldTypeStr,'Directivity')
    maxstr = 'D_0';
else
    maxstr = 'E_0';
end


% Unit label
if dB == true && strcmp(FieldTypeStr,'Directivity') && norm == false
    unitlabel = 'dBi';
elseif dB == true && strcmp(FieldTypeStr,'Directivity') && norm == true
    unitlabel = 'dB';
elseif dB == false && strcmp(FieldTypeStr,'Directivity')
    unitlabel = '';
elseif dB == true && strcmp(FieldTypeStr,'E-pattern')
    unitlabel = 'dBV';
elseif dB == false && strcmp(FieldTypeStr,'E-pattern')
    unitlabel = 'V';
end

compare = {Element(:).Compare};

props = whos('compare');

switch props.class
    case 'cell'
        compare = cell2mat(compare);
end

switch s{k}
    case {'2D', '3D'}
        % Colormap
        r        = linspace(0,Rmax);
        
        map(:,1) = subplus(-cos(pi.*r./Rmax));
        map(:,2) = sin(pi.*r./Rmax);
        map(:,3) = subplus(cos(pi.*r./Rmax));
        
        map      = abs(map)./max(max(map));
        
        % Colorbar
        if dB == true
            tickLbl = linspace(plotlims.dB(1),max(max(PlotData)),10);
        else
            tickLbl = linspace(0,Rmax,10);
        end
        
        tickLbl = round(tickLbl,2);
        
        c = colorbar('TickLabels',tickLbl,'Ticks',linspace(0,1,10));
        colormap(map);
        c.Position = c.Position + [0.12,0,0,0];
        
        % Colorbar label
        c.Label.String = unitlabel;
        c.Label.Rotation = 0;
        c.Label.Position = c.Label.Position + [0.5,0,0];
        
        % Title
        if strcmp(FieldValue,'Axial Ratio')
            title(FieldValueStr);
            return;
        end
        title(strcat(FieldValueStr,{' of '},FieldTypeStr));
        return;
    case {'Polar','Rectangular'}
        
        % Title
        if strcmp(Plane,'Theta')
            planestr = '\theta';
        else
            planestr = '\phi';
        end
        
        
        
        if strcmp(FieldValueStr,'Axial ratio')
            title(strcat(FieldValueStr,{', '},planestr, {' = '},num2str(PlaneAngle), {char(176)}));
            return;
        else
            title(strcat(FieldValueStr,{' of '},FieldTypeStr,{', '},planestr, {' = '},num2str(PlaneAngle), {char(176)}));
        end
        
        if strcmp(s{k},'Polar')
            D0pos   = [d2r(315),D0+(D0-limits(1))*0.05];
            HPBWpos = [d2r(312),D0];
        else
            D0pos   = [370,(D0-limits(1))/2+limits(1)];
            HPBWpos = [370,(D0-limits(1))/2+limits(1)-1];
        end
        
        % Mainlobe marker
        [M,I] = max(PlotMat,[],2);
        
        text(D0pos(1),D0pos(2),strcat(maxstr,{' = '},...
            num2str(round(PlotMat(2,I(2)),2)),{' '},unitlabel),...
            'VerticalAlignment','bottom','HorizontalAlignment','left');
        hold on
        line([PlotMat(1,I(2)),PlotMat(1,I(2))],[limits(1),D0],'LineWidth',1.5,'Color','red');
        hold off
        
        if any(compare)
            return;
        end
        
        % HPBW markers
        if dB == true && strcmp(FieldTypeStr,'Directivity')
            HP = max(PlotMat(2,:))-10*log10(2);
        elseif dB == false && strcmp(FieldTypeStr,'Directivity')
            HP = max(PlotMat(2,:))*0.5;
        elseif dB == false && strcmp(FieldTypeStr,'E-pattern')
            HP = max(PlotMat(2,:))*sqrt(0.5);
        elseif dB == true && strcmp(FieldTypeStr,'E-pattern')
            HP = max(PlotMat(2,:))-10*log10(sqrt(2));
        end
        
        HPi = [];
        i   = 1; 
        
        while isempty(HPi) && i<length(PlotMat)
            if PlotMat(2,mod(I(2)-i-1,length(PlotMat))+1) < HP
                HPi(1) = mod(I(2)-i-1,length(PlotMat))+1;
                break;
            end
            i = i+1;
        end
        
        if ~isempty(HPi) && abs(PlotMat(2,HPi(1))-HP) > abs(PlotMat(2,HPi(1)+1)-HP)
            HPi(1) = HPi(1)+1;
        end
        
        HPi(2) = 1i;
        i      = 1;
        
        while ~isreal(HPi(2)) && i<length(PlotMat)
            if PlotMat(2,mod(I(2)+i-1,length(PlotMat))+1) < HP
                HPi(2) = mod(I(2)+i-1,length(PlotMat))+1;
            end
            i = i+1;
        end
        
        if real(HPi(1)) == real(HPi(2)) || ~isreal(HPi(2))
            HPi = [];
        end
        
        if ~isempty(HPi) && abs(PlotMat(2,HPi(2))-HP) > abs(PlotMat(2,HPi(2)-1)-HP)
            HPi(2) = HPi(2)-1;
        end
        
        
        
        hold on
        for i=1:length(HPi)
            line([PlotMat(1,HPi(i)),PlotMat(1,HPi(i))],[limits(1),D0],'LineWidth',1,'Color','m');
        end
        hold off
        
        % HPBW label
        if ~isempty(HPi)
            HPBW = mod((PlotMat(1,HPi(2))-PlotMat(1,HPi(1))),2*pi);
            
            
            if strcmp(s{k},'Polar')
                HPBW = round(r2d(HPBW),1);
            else
                HPBW = round(HPBW,1);
            end
            
            text(HPBWpos(1),HPBWpos(2),strcat({'HPBW = '},...
                num2str(HPBW),char(176)),...
                'VerticalAlignment','bottom','HorizontalAlignment','left');
        end
        
        
        
       
end
UpdateMsgBox(handles,'Plotting... Done!');


%-------------------Normalise field to average power-----------------------
function [varargout] = RMSField(varargin)
% RMSFIELD Normalises the field to the average power
%   RMSFIELD(A) normalises E to its average power
%   RMSFIELD(A,B) normalises Et and Ep to the average power of
%   A^2+B^2
%   RMSFIELD(_,'Name',Value)
%
% Calculates the RMS-value of input fild(s)
% If the input has one field, it is normalised to its RMS value
% If the input has two fields, they are normalised to the RMS value of
% their combined value
% Options: dB, boolean          power, boolean

global thetar

narginchk(1,6);

args  = varargin;

%Default values
dB    = false;
power = false;
Z0    = 377;

%Checking dB option
for i=1:length(args)
    if strncmpi('dB',args{i},3)
        if varargin{i+1} == true
            dB = true;
        end
        args{i}     = [];
        args{i+1}   = [];
        args        = args(~cellfun('isempty',args));
        break
    end
end

%Checking power option
for i=1:length(args)
    if strncmpi('Power',args{i},3) || strncmpi('power',args{i},3)
        if varargin{i+1} == true
            power = true;
        end
        args{i}     = [];
        args{i+1}   = [];
        args        = args(~cellfun('isempty',args));
        break
    end
end

nfields = length(args);

%Calculating rms
switch nfields
    case 1
        if dB == true
            U = 10.^(abs(args{1})./10);
        else
            U = args{1};
        end
        if power == false
            U = U.^2;
        end
        
    case 2
        if dB == true
            U = 10.^(abs(args{1})./10)+10.^(abs(args{2})./10);
        else
            U{1} = abs(args{1});
            U{2} = abs(args{2});
        end
        if power == false
            U    = U{1}.^2+U{2}.^2;
        else
            U    = U{1}+U{2};
        end
        
    otherwise
        error('RMSField: number of inputfields must be 1 or 2');
end

% U is now radiation intensity. (Power, linear)
Prad   = 0;
Totang = 0;
%thetar = linspace(0,pi,size(U,2));
for ii=1:size(U,1)
    for i=1:size(U,2)
        Prad = Prad + U(ii,i)*sin(thetar(i))*d2r(1)^2;
        Totang = Totang + sin(thetar(i))*d2r(1)^2;
    end
end

U0 = Prad./(Totang);

if power == false
    U0 = sqrt(U0);
end

%Outputing fields
switch nfields
    case 1
        if dB == true
            varargout{1} = args{1}-10.*log10(U0);
        else
            varargout{1} = args{1}./U0;
        end
    case 2
        if dB == true
            varargout{1} = args{1}-10.*log10(U0);
            varargout{2} = args{2}-10.*log10(U0);
        else
            varargout{1} = args{1}./U0;
            varargout{2} = args{2}./U0;
        end
end


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         MINOR CALULATIONS
%
%**************************************************************************
%--------------------------------------------------------------------------

%-------------------Calculate rotation matrix for rotation around Y-axis---
function [R]=rotY(theta)
R=[ cos(theta),    0,    sin(theta);
             0,    1,             0;
   -sin(theta),    0,    cos(theta)];

%-------------------Calculate rotation matrix for rotation around Z-axis---
function [R]=rotZ(phi)
R=[ cos(phi),    -sin(phi),      0;
    sin(phi),     cos(phi),      0;
           0,            0,      1];
       

%-------------------Interpolate complex field------------------------------
function Field = Interpol2(V,W,Xq,Yq)
% Interpolates field and phase values and constructs complex matrix
% V is a matrix containing field values
% W is a matrix containing phase values
% Xq is an array of theta meassurement points for the output field
% Yq is an array of phi meassurement points for the output field
x       = 0:pi/(size(V,2)-1):pi;
y       = 0:2*pi/(size(V,1)-1):2*pi;
[X,Y]   = meshgrid(x,y);
[Xq,Yq] = meshgrid(Xq,Yq);

U = V.*exp(1i.*d2r(W));

Field   = interp2(X,Y,U,Xq,Yq);


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         GUI FUNCTIONS
%
%**************************************************************************
%--------------------------------------------------------------------------

%-------------------Uptade GUI table---------------------------------------

function UpdateTable(handles, n)

UpdateMsgBox(handles, 'Updating GUI table...');

global Element

% Reading curren table data
tabdat  = handles.elmTab.Data;

% Setting tabdat format to cell if empty
if isempty(tabdat)
    clear tabdat
    newRow      = repmat({''},1,7);
    tabdat(n,:) = newRow(:);
end

tabdat(n,1) = {Element(n).Tag};
if strcmp(Element(n).Type,'Dipole')
    tabdat(n,2) = {strcat('L = ',num2str(Element(n).Dimensions.Length))};
else
    tabdat(n,2) = {'-'};
end
tabdat(n,3) = {abs(Element(n).Excitation)};
tabdat(n,4) = {r2d(angle(Element(n).Excitation))};
%tabdat(n,5) = {0};%elm.F(n);
tabdat(n,5) = {mat2str(Element(n).Position)};
tabdat(n,6) = {mat2str(r2d(Element(n).Rotation))};
tabdat(n,7) = {0};

set(handles.elmTab,'Data',tabdat);

UpdateMsgBox(handles, 'Updating GUI table... Done!');

%------------------Update n and nslider objects----------------------------
function UpdElmNo(handles,n)
n = round(n);

handles.n.String      = num2str(n);
handles.nslider.Value = n;

%------------------Updetes input fields with current selected element------
function UpdateInputFields(handles,n)

global Element

% Ensure n is an interger value
n = round(n);

handles.elmTyp.Enable = 'on';

% If the element does not exist in the array, there is no need to update
% input fields
if n > size(Element,2)  
    return;
    
% If the element type is empty, there is no data to evaluate
elseif isempty(Element(n).Type)
    return;
    
% If the element type is one that can be selected in the popup menue,the
% popup menue should be updated with this element type
elseif any(strcmp(Element(n).Type,handles.elmTyp.String))
    
    handles.elmTyp.Value    = find(not(cellfun('isempty',strfind(handles.elmTyp.String,Element(n).Type))));
    
    handles.elmTyp.Visible = 'on';
    
% If the element type is 'Imported', the popup menue is set to 'Import...'
elseif strcmp(Element(n).Type, 'Imported')
    handles.elmTyp.Value    = find(not(cellfun('isempty',strfind(handles.elmTyp.String,'Import...'))));
end


handles.elmAmp.String   = num2str(abs(Element(n).Excitation));
handles.elmPha.String   = num2str(round(r2d(angle(Element(n).Excitation))));
handles.elmPosX.String  = num2str(Element(n).Position(1));
handles.elmPosY.String  = num2str(Element(n).Position(2));
handles.elmPosZ.String  = num2str(Element(n).Position(3));
handles.elmAlpha.String = num2str(r2d(Element(n).CurrentRotation(1)));
handles.elmBeta.String  = num2str(r2d(Element(n).CurrentRotation(2)));
handles.elmGamma.String = num2str(r2d(Element(n).CurrentRotation(3)));
handles.elmLength.String= num2str(Element(n).Dimensions.Length);


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         CONVERSION FUNCTIONS
%
%**************************************************************************
%--------------------------------------------------------------------------

%-------------------Convert radians to degrees-----------------------------
function [d]=r2d(r)

d=r.*180./pi;

%-------------------Convert degrees to radians-----------------------------
function [r]=d2r(d)

r=d.*pi./180;

%-------------------Convert decibel to linear------------------------------
function [lin] = dB2lin(dB)
lin = 10.^(dB./10);

%-------------------Convert linear to decibel------------------------------
function [dB] = lin2dB(lin)
dB = 10.*log10(lin);

%-------------------Convert radians to table indices-----------------------
function [row, column]=r2t(theta, phi, res)

%Scaling theta 0-pi, phi 0-2pi
if mod(theta,2*pi)>pi
    theta=pi-mod(theta,pi);
    phi=mod(phi+pi,2*pi);
else
    theta=mod(theta,2*pi);
    phi=mod(phi,2*pi);
end

%Converting to row and column
column=round(r2d(theta)/res)+1;
row=round(r2d(phi)/res)+1;

%-------------------Convert degrees to table indices-----------------------
function [row, column] = d2t(theta, phi, res)

%Scaling theta 0-180, phi 0-359
if mod(theta,360)>180
    theta=180-mod(theta,180);
    phi=mod(phi+180,360);
else
    theta=mod(theta,2*pi);
    phi=mod(phi,2*pi);
end

%Converting to row and column
column=round(theta*rtd/res)+1;
row=round(phi*rtd/res)+1;

%-------------------Convert spherical coordinates to cartesian-------------
function [x, y, z]=s2c(theta, phi, rho)
x=rho.*sin(theta).*cos(phi);
y=rho.*sin(theta).*sin(phi);
z=rho.*cos(theta);

%-------------------Convert cartesian coordinates to spherical-------------
function [theta, phi, rho]=c2s(x, y, z)
rho=sqrt(x.^2+y.^2+z.^2);
theta=acos(z./rho);
phi=atan2(y,x);


%--------------------------------------------------------------------------
%**************************************************************************
%
%                         SYSTEM AND PROGRAM
%
%**************************************************************************
%--------------------------------------------------------------------------


%-------------------Reporting program state to user------------------------
function UpdateMsgBox(handles, msg)

handles.msgBox.String = msg;
drawnow 


%-------------------Placeholder for error function-------------------------
function uError(handles, msg)
return;
log = get(handles.errLog,'String');
N   = size(log,1);

if isempty(log)
    log{1} = msg;
elseif size(log,1) > 30
    
else
    for n=1:N
        log{N-(n-1)+1} = log{N-(n-1)};
    end
    log{1} = msg;
end

handles.errLog.String = log;
