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

function DoPlotCoilSen(handles)

global VMco;
global VCtl;
global VObj;
%--------Display Parameters
fieldname=fieldnames(handles.Attrh2);
for i=1:length(fieldname)/2
    try 
        eval(['SD.' fieldname{i*2} '=' get(handles.Attrh2.(fieldname{i*2}),'String') ';']);
    catch me
        TAttr=get(handles.Attrh2.(fieldname{i*2}),'String');
        eval(['SD.' fieldname{i*2} '=''' TAttr{get(handles.Attrh2.(fieldname{i*2}),'Value')}  ''';']);
    end
end
handles.SD=SD;
%--------End

% update grid
VMco.xdimres=str2num(get(handles.Attrh2.('XDimRes'),'String'));
VMco.ydimres=str2num(get(handles.Attrh2.('YDimRes'),'String'));
VMco.zdimres=str2num(get(handles.Attrh2.('ZDimRes'),'String'));

Mxdims=size(VObj.Rho);
[VMco.xgrid,VMco.ygrid,VMco.zgrid]=meshgrid((-(Mxdims(2)-1)/2)*VObj.XDimRes:VMco.xdimres:((Mxdims(2)-1)/2)*VObj.XDimRes,...
                                            (-(Mxdims(1)-1)/2)*VObj.YDimRes:VMco.ydimres:((Mxdims(1)-1)/2)*VObj.YDimRes,...
                                            (-(Mxdims(3)-1)/2)*VObj.ZDimRes:VMco.zdimres:((Mxdims(3)-1)/2)*VObj.ZDimRes);

DoWriteXML2m(DoParseXML(handles.CoilXMLFile),[handles.CoilXMLFile(1:end-3) 'm']);
clear functions; % remove the M-functions from the memory
clear -global VCco; % remove previous coil loops
[pathstr,name,ext]=fileparts(handles.CoilXMLFile);
eval(['[B1x, B1y, B1z, Pos]=' name ';']);
handles.IV.Pos=Pos;
handles.IV.CoilDisplay=SD.CoilDisplay;
handles.IV.Colormap=SD.Colormap;

switch SD.CoilShow
    case 'All'
        handles.B1x=sum(B1x,4);
        handles.B1y=sum(B1y,4);
        handles.B1z=sum(B1z,4);
    case 'Current'
        if ~isempty(handles.Attrh1)
            handles.B1x=B1x(:,:,:,str2num(get(handles.Attrh1.('CoilID'),'String')));
            handles.B1y=B1y(:,:,:,str2num(get(handles.Attrh1.('CoilID'),'String')));
            handles.B1z=B1z(:,:,:,str2num(get(handles.Attrh1.('CoilID'),'String')));
        else
        handles.B1x=sum(B1x,4);
        handles.B1y=sum(B1y,4);
        handles.B1z=sum(B1z,4);
        end
end

switch SD.Mode
    case 'Magnitude'
        handles.B1=sqrt(handles.B1x.^2+handles.B1y.^2);
    case 'Phase'
        handles.B1=angle(handles.B1x+1i*handles.B1y);
    case 'Real'
        handles.B1=handles.B1x;
    case 'Imaginary'
        handles.B1=handles.B1y;
end

handles.IV.C_upper=SD.CLimUp;
handles.IV.C_lower=SD.CLimDown;
DoUpdateSlice(handles.CoilSen_axes,handles.B1,handles.IV,'Coil');
guidata(handles.CoilDesignPanel_figure,handles);                    
                         

end