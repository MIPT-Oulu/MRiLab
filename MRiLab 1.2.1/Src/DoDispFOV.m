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

function DoDispFOV(varargin)

global VObj;
handles=varargin{1};
handles=guidata(handles.SimuPanel_figure);

if ~strcmp(get(handles.Coronal_uipanel,'Title'),'Coronal')
    return;
end

if nargin==1
    switch gca
        case handles.Axial_axes
            p=getPosition(handles.AxialFOV);
            handles.ISO(1)=round(p(1)+p(3)/2);
            handles.ISO(2)=round(p(2)+p(4)/2);
        case handles.Sagittal_axes
            p=getPosition(handles.SagittalFOV);
            handles.ISO(2)=round(p(1)+p(3)/2);
            handles.ISO(3)=round(p(2)+p(4)/2);
        case handles.Coronal_axes
            p=getPosition(handles.CoronalFOV);
            handles.ISO(1)=round(p(1)+p(3)/2);
            handles.ISO(3)=round(p(2)+p(4)/2);
    end
end
SP=get(handles.Attrh1.ScanPlane,'String');
FD=get(handles.Attrh1.FreqDir,'String');
switch SP{get(handles.Attrh1.ScanPlane,'Value')}
    case 'Axial'
        if strcmp(FD{get(handles.Attrh1.FreqDir,'Value')},'S/I')
            set(handles.Attrh1.FreqDir,'Value',1);
        end
        if  strcmp(FD{get(handles.Attrh1.FreqDir,'Value')},'A/P')
            xsize=str2double(get(handles.Attrh1.FOVPhase,'String'));
            ysize=str2double(get(handles.Attrh1.FOVFreq,'String'));
        else
            xsize=str2double(get(handles.Attrh1.FOVFreq,'String'));
            ysize=str2double(get(handles.Attrh1.FOVPhase,'String'));
        end
        zsize=str2double(get(handles.Attrh1.SliceThick,'String'))*...
              max(1,str2double(get(handles.Attrh1.SliceNum,'String')) - mod(str2double(get(handles.Attrh1.SliceNum,'String')),2));
    case 'Sagittal'
        if strcmp(FD{get(handles.Attrh1.FreqDir,'Value')},'L/R')
            set(handles.Attrh1.FreqDir,'Value',3);
        end
        if  strcmp(FD{get(handles.Attrh1.FreqDir,'Value')},'S/I')
            zsize=str2double(get(handles.Attrh1.FOVFreq,'String'));
            ysize=str2double(get(handles.Attrh1.FOVPhase,'String'));
        else
            zsize=str2double(get(handles.Attrh1.FOVPhase,'String'));
            ysize=str2double(get(handles.Attrh1.FOVFreq,'String'));
        end
        xsize=str2double(get(handles.Attrh1.SliceThick,'String'))*...
              max(1,str2double(get(handles.Attrh1.SliceNum,'String')) - mod(str2double(get(handles.Attrh1.SliceNum,'String')),2));
    case 'Coronal'
        if strcmp(FD{get(handles.Attrh1.FreqDir,'Value')},'A/P')
            set(handles.Attrh1.FreqDir,'Value',2);
        end
        if  strcmp(FD{get(handles.Attrh1.FreqDir,'Value')},'L/R')
            xsize=str2double(get(handles.Attrh1.FOVFreq,'String'));
            zsize=str2double(get(handles.Attrh1.FOVPhase,'String'));
        else
            xsize=str2double(get(handles.Attrh1.FOVPhase,'String'));
            zsize=str2double(get(handles.Attrh1.FOVFreq,'String'));
        end
        ysize=str2double(get(handles.Attrh1.SliceThick,'String'))*...
              max(1,str2double(get(handles.Attrh1.SliceNum,'String')) - mod(str2double(get(handles.Attrh1.SliceNum,'String')),2));
end

if nargin==1
    if abs(get(handles.Axial_slider,'Value')-handles.ISO(3))>zsize/(2*VObj.ZDimRes)
        set(handles.AxialFOV,'Visible','off');
    else
        setPosition (handles.AxialFOV,[handles.ISO(1)-xsize/(2*VObj.XDimRes)...
                                       handles.ISO(2)-ysize/(2*VObj.YDimRes)...
                                       xsize/VObj.XDimRes ysize/VObj.YDimRes]);
        set(handles.AxialFOV,'Visible','on');
        setResizable(handles.AxialFOV,0);
    end
    
    if abs(get(handles.Coronal_slider,'Value')-handles.ISO(2))>ysize/(2*VObj.YDimRes)
        set(handles.CoronalFOV,'Visible','off');
    else
        setPosition (handles.CoronalFOV,[handles.ISO(1)-xsize/(2*VObj.XDimRes)...
                                         handles.ISO(3)-zsize/(2*VObj.ZDimRes)...
                                         xsize/VObj.XDimRes zsize/VObj.ZDimRes]);
        set(handles.CoronalFOV,'Visible','on');
        setResizable(handles.CoronalFOV,0);
    end

    if abs(get(handles.Sagittal_slider,'Value')-handles.ISO(1))>xsize/(2*VObj.XDimRes)
        set(handles.SagittalFOV,'Visible','off');
    else
        setPosition (handles.SagittalFOV,[handles.ISO(2)-ysize/(2*VObj.YDimRes)...
                                          handles.ISO(3)-zsize/(2*VObj.ZDimRes)...
                                          ysize/VObj.YDimRes zsize/VObj.ZDimRes]);
        set(handles.SagittalFOV,'Visible','on');
        setResizable(handles.SagittalFOV,0);
    end

else
   
    handles.AxialFOV=imrect(handles.Axial_axes, [handles.ISO(1)-xsize/(2*VObj.XDimRes)...
                                                 handles.ISO(2)-ysize/(2*VObj.YDimRes)...
                                                 xsize/VObj.XDimRes ysize/VObj.YDimRes]);
    handles.AxialFOV.setColor([0.000 1.000 0.000]) %green box
    setResizable(handles.AxialFOV,0);
    
    handles.CoronalFOV=imrect(handles.Coronal_axes, [handles.ISO(1)-xsize/(2*VObj.XDimRes)...
                                                     handles.ISO(3)-zsize/(2*VObj.ZDimRes)...
                                                     xsize/VObj.XDimRes zsize/VObj.ZDimRes]);
    handles.CoronalFOV.setColor([0.000 1.000 0.000]) %green box
    setResizable(handles.CoronalFOV,0);
    
    handles.SagittalFOV=imrect(handles.Sagittal_axes, [handles.ISO(2)-ysize/(2*VObj.YDimRes)...
                                                       handles.ISO(3)-zsize/(2*VObj.ZDimRes)...
                                                       ysize/VObj.YDimRes zsize/VObj.ZDimRes]);
    handles.SagittalFOV.setColor([0.000 1.000 0.000]) %green box
    setResizable(handles.SagittalFOV,0);
    
    if abs(get(handles.Axial_slider,'Value')-handles.ISO(3))>zsize/(2*VObj.ZDimRes)
        set(handles.AxialFOV,'Visible','off');
    end
        
    if abs(get(handles.Coronal_slider,'Value')-handles.ISO(2))>ysize/(2*VObj.YDimRes)
        set(handles.CoronalFOV,'Visible','off');
    end
    
    if abs(get(handles.Sagittal_slider,'Value')-handles.ISO(1))>xsize/(2*VObj.XDimRes)
        set(handles.SagittalFOV,'Visible','off');
    end
    
end

AP=round(getPosition(handles.AxialFOV));
set(handles.AP1_text,'String',num2str(AP(2)));
set(handles.AP2_text,'String',num2str(AP(2)+AP(4)));
SI=round(getPosition(handles.SagittalFOV));
set(handles.SI1_text,'String',num2str(SI(2)));
set(handles.SI2_text,'String',num2str(SI(2)+SI(4)));
LR=round(getPosition(handles.CoronalFOV));
set(handles.LR1_text,'String',num2str(LR(1)));
set(handles.LR2_text,'String',num2str(LR(1)+LR(3)));
DoDisableButton([],[],handles);
guidata(handles.SimuPanel_figure,handles);
