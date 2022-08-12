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

function DoPlay3DMotion(handles)

global VMot;
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

%--------Open VRML & Initialize
vrobject = vrworld('Mot3DModel.wrl','new');
open(vrobject);
fig=vrfigure(vrobject);
viewpoint = vrnode(vrobject, SD.ViewPoint); % Set default viewpoint
viewpoint.set_bind = 1;
viewpoint.position = viewpoint.position * SD.ZoomOut; % Set default viewpoint distance
object=vrnode(vrobject, 'Sphere');
object.scale = object.scale .*[VObj.XDim*VObj.XDimRes,VObj.YDim*VObj.YDimRes,VObj.ZDim*VObj.ZDimRes];
%--------End

for j = 1:SD.Repeat
    
    %--------Initialize variables for tracking motion path
    ObjLoc=[0;0;0];
    ObjTurnLoc=[0;0;0];
    ObjMotInd=0;
    %--------End
    
    for i=2:SD.Sample:length(VMot.t)
        
        if ~isempty(VMot.Disp)
            Disp=VMot.Disp(:,i);
            Disp(2)=-Disp(2); % Matlab image coordinate is oppsite againt VMRL coordinate in Y direction
            if ObjMotInd == VMot.ind(i)
                ObjTraj = ObjLoc - ObjTurnLoc;
                Displacement  = Disp - ObjTraj;
            else
                Displacement  = Disp;
                ObjTurnLoc = ObjLoc;
            end
            ObjLoc = ObjLoc + Displacement;
        end
        
        %% time interval
        pause((VMot.t(i)-VMot.t(i-1)));
        
        %% translate
        if ~isempty(VMot.Disp)
            object.translation=Disp' + ObjTurnLoc'; % Matlab image coordinate is oppsite againt VMRL coordinate in Y direction
        end
        
        %% rotate
        if ~isempty(VMot.Ang)
            object.rotation=[VMot.Axis(:,i)', -VMot.Ang(:,i)]; % Matlab image coordinate is oppsite againt VMRL coordinate in Y direction
        end
        
        vrdrawnow;
        ObjMotInd = VMot.ind(i);
    end
end



end