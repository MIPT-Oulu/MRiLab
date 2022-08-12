%                                                _______
% _________________________________________     / _____ \      
%     .  .     |---- (OO)|       ___   |       | |     | |     
%    /\  /\    |__ |  || |      /   \  |___    |_|     |_|     
%   /  \/  \   |  \   || |      \___/  |   \   |S|     |N|     
%  /   ||   \  |   \_ || |____|     \  |___/  MRI Simulator    
% _________________________________________                  
% Numerical MRI Simulation Package
% Version 1.2  - https://sourceforge.net/projects/mrilab/
%
% The MRiLab is a numerical MRI simulation package. It has been developed to 
% simulate factors that affect MR signal formation, acquisition and image 
% reconstruction. The simulation package features highly interactive graphic 
% user interface for various simulation purposes. MRiLab provides several 
% toolboxes for MR researchers to analyze RF pulse, design MR sequence, 
% configure multiple transmitting and receiving coils, investigate B0 
% in-homogeneity and object motion sensitivity et.al. The main simulation 
% platform combined with these toolboxes can be applied for customizing 
% various virtual MR experiments which can serve as a prior stage for 
% prototyping and testing new MR technique and application.
%
% Author:
%   Fang Liu <leoliuf@gmail.com>
%   University of Wisconsin-Madison
%   April-6-2014
% _________________________________________________________________________
% Copyright (c) 2011-2014, Fang Liu <leoliuf@gmail.com>
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
% _________________________________________________________________________

function varargout = MotList(varargin)
% MotionLIST MATLAB code for MotList.fig
%      MotionLIST, by itself, creates a new MotionLIST or raises the existing
%      singleton*.
%
%      H = MotionLIST returns the handle to a new MotionLIST or the handle to
%      the existing singleton*.
%
%      MotionLIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MotionLIST.M with the given input arguments.
%
%      MotionLIST('Property','Value',...) creates a new MotionLIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotList_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotList_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotList

% Last Modified by GUIDE v2.5 01-May-2013 21:32:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotList_OpeningFcn, ...
                   'gui_OutputFcn',  @MotList_OutputFcn, ...
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


% --- Executes just before MotList_figure is made visible.
function MotList_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotList_figure (see VARARGIN)

handles.Simuh=varargin{1};
Category=dir([handles.Simuh.MRiLabPath handles.Simuh.Sep 'Mot']);
ind=1;
for i=1:length(Category)
    if ~strcmp(Category(i).name,'.') & ~strcmp(Category(i).name,'..') & Category(i).isdir
        handles.CategoryDir{ind,1}=Category(i).name;
        ind=ind+1;
    end
end
set(handles.Category_listbox,'String',handles.CategoryDir);

handles.accept = 0;
% Choose default command line output for MotList_figure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotList_figure wait for user response (see UIRESUME)
% uiwait(handles.MotList_figure);


% --- Outputs from this function are returned to the command line.
function varargout = MotList_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in Mot_listbox.
function Mot_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Mot_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Mot_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Mot_listbox

if ~isempty(get(handles.MotPath_text,'String'))
    return;
end

if strcmp(handles.MotList,'Empty')
    return;
end

handles.MotXMLFile=[handles.Simuh.MRiLabPath handles.Simuh.Sep ...
                    'Mot' handles.Simuh.Sep ...
                    handles.CategoryDir{get(handles.Category_listbox,'Value')} handles.Simuh.Sep ...
                    handles.MotList{get(handles.Mot_listbox,'Value')} handles.Simuh.Sep...
                    handles.MotList{get(handles.Mot_listbox,'Value')} '.xml'];
                
handles.MotXMLDir=[handles.Simuh.MRiLabPath handles.Simuh.Sep ...
                    'Mot' handles.Simuh.Sep ...
                    handles.CategoryDir{get(handles.Category_listbox,'Value')} handles.Simuh.Sep ...
                    handles.MotList{get(handles.Mot_listbox,'Value')}];

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Mot_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mot_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Category_listbox.
function Category_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Category_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Category_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Category_listbox

if ~isempty(get(handles.MotPath_text,'String'))
    return;
end

if strcmp(handles.CategoryDir,'Empty')
    return;
end

set(handles.Mot_listbox,'Enable','on');

Mot=dir([handles.Simuh.MRiLabPath handles.Simuh.Sep ...
          'Mot' handles.Simuh.Sep ...
          handles.CategoryDir{get(handles.Category_listbox,'Value')}]);
ind=1;
handles.MotList=[];
for i=1:length(Mot)
    if ~strcmp(Mot(i).name,'.') & ~strcmp(Mot(i).name,'..')
        handles.MotList{ind,1}=Mot(i).name;
        ind=ind+1;
    end
end
if ind==1
    handles.MotList='Empty';
end
set(handles.Mot_listbox,'String',handles.MotList);
set(handles.Mot_listbox,'Value',1);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Category_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Category_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Accept_pushbutton.
function Accept_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Accept_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if isempty(get(handles.MotPath_text,'String'))
    try
        if strcmp(handles.MotList{get(handles.Mot_listbox,'Value')},'Empty')
            DoUpdateInfo(handles.Simuh,'No Motion is selected!');
            return;
        end
    catch me
        DoUpdateInfo(handles.Simuh,'No Motion is selected!');
        return;
    end
end

%----update Motion selection
handles.Simuh.MotXMLFile=handles.MotXMLFile;
handles.Simuh.MotXMLDir=handles.MotXMLDir;
Mot=DoParseXML(handles.MotXMLFile);
handles.Simuh.MotStruct=Mot;
Mot_text=uicontrol(handles.Simuh.MotSel_uipanel,'Style','text');
set(Mot_text,'FontWeight','bold','FontSize',10,'Position',[0,0,140,18],...
    'String', Mot.Attributes(1).Value,'TooltipString',handles.MotXMLFile);
%----end
guidata(handles.Simuh.SimuPanel_figure,handles.Simuh);
DoUpdateInfo(handles.Simuh,'Mot file was successfully loaded!');
handles.accept = 1;
guidata(hObject, handles);
close(handles.MotList_figure);



% --- Executes on button press in Cancel_pushbutton.
function Cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MotList_figure_CloseRequestFcn(hObject, eventdata, handles);


% --- Executes when user attempts to close MotList_figure.
function MotList_figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MotList_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DoDisableButton([],[],handles.Simuh);
if handles.accept == 0
    DoUpdateInfo(handles.Simuh,'Mot file loading was cancelled!');
end
% Hint: delete(hObject) closes the figure
delete(handles.MotList_figure);


% --- Executes on button press in MotPath_pushbutton.
function MotPath_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to MotPath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname,filterindex]=uigetfile({'Mot*.xml','XML-files (*.xml)'},'MultiSelect','off');
if filename~=0
    handles.MotXMLFile=[pathname filename];
    handles.MotXMLDir=pathname(1:end-1);
    set(handles.MotPath_text,'String',[pathname filename]);
else
    errordlg('No Mot was loaded!');
    return;
end
guidata(hObject, handles);


% --- Executes on button press in Default_pushbutton.
function Default_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Default_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.Simuh,'MotXMLFile')
    handles.Simuh=rmfield(handles.Simuh,'MotXMLFile');
    delete(get(handles.Simuh.MotSel_uipanel,'Children'));
    guidata(handles.Simuh.SimuPanel_figure,handles.Simuh);
end
DoUpdateInfo(handles.Simuh,'Use default Motion!');
handles.accept = 1;
guidata(hObject, handles);
close(handles.MotList_figure);
