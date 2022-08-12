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

function DoPlotGradFie(handles)

global VMgd;
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
VMgd.xdimres=str2num(get(handles.Attrh2.('XDimRes'),'String'));
VMgd.ydimres=str2num(get(handles.Attrh2.('YDimRes'),'String'));
VMgd.zdimres=str2num(get(handles.Attrh2.('ZDimRes'),'String'));
[VMgd.xgrid,VMgd.ygrid,VMgd.zgrid]=meshgrid((-VCtl.ISO(1)+1)*VObj.XDimRes:VMgd.xdimres:(VObj.XDim-VCtl.ISO(1))*VObj.XDimRes,...
                                            (-VCtl.ISO(2)+1)*VObj.YDimRes:VMgd.ydimres:(VObj.YDim-VCtl.ISO(2))*VObj.YDimRes,...
                                            (-VCtl.ISO(3)+1)*VObj.ZDimRes:VMgd.zdimres:(VObj.ZDim-VCtl.ISO(3))*VObj.ZDimRes); 

DoWriteXML2m(DoParseXML(handles.GradXMLFile),[handles.GradXMLFile(1:end-3) 'm']);
clear functions;  % remove the M-functions from the memory
[pathstr,name,ext]=fileparts(handles.GradXMLFile);
eval(['[GxR,GyPE,GzSS]=' name ';']);
eval(['handles.G=' SD.GradLine ';'])
if isempty(find(handles.G ~=0, 1))
    warndlg(['Constant unit gradient is used for ' SD.GradLine '.']);
    return;
end

% calculate grid based on gradient
TmpG=handles.G(:,:,:,1);
TmpG(VMgd.xgrid<=0) = 0;
handles.G(:,:,:,4) = cumsum(TmpG,2) .* VMgd.xdimres;
TmpG=handles.G(:,:,:,1);
TmpG(VMgd.xgrid>=0) = 0;
handles.G(:,:,:,4) = handles.G(:,:,:,4) + flipdim(cumsum(flipdim(-TmpG,2),2),2) .* VMgd.xdimres;

TmpG=handles.G(:,:,:,2);
TmpG(VMgd.ygrid<=0) = 0;
handles.G(:,:,:,4) = handles.G(:,:,:,4) + cumsum(TmpG,1).* VMgd.ydimres;
TmpG=handles.G(:,:,:,2);
TmpG(VMgd.ygrid>=0) = 0;
handles.G(:,:,:,4) = handles.G(:,:,:,4) + flipdim(cumsum(flipdim(-TmpG,1),1),1) .* VMgd.ydimres;

TmpG=handles.G(:,:,:,3);
TmpG(VMgd.zgrid<=0) = 0;
handles.G(:,:,:,4) = handles.G(:,:,:,4) + cumsum(TmpG,3) .* VMgd.zdimres;
TmpG=handles.G(:,:,:,3);
TmpG(VMgd.zgrid>=0) = 0;
handles.G(:,:,:,4) = handles.G(:,:,:,4) + flipdim(cumsum(flipdim(-TmpG,3),3),3) .* VMgd.zdimres;

handles.IV.Colormap=SD.Colormap;
handles.IV.DispMode=SD.DispMode;
DoUpdateSlice(handles.GradField_axes,handles.G,handles.IV,'Grad');
guidata(handles.GradDesignPanel_figure,handles);             
                         

end