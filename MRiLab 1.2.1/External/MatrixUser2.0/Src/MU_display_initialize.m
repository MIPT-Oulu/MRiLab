% MatrixUser, a multi-dimensional matrix analysis software package
% https://sourceforge.net/projects/matrixuser/
% 
% The MatrixUser is a matrix analysis software package developed under Matlab
% Graphical User Interface Developing Environment (GUIDE). It features 
% functions that are designed and optimized for working with multi-dimensional
% matrix under Matlab. These functions typically includes functions for 
% multi-dimensional matrix display, matrix (image stack) analysis and matrix 
% processing.
%
% Author:
%   Fang Liu <leoliuf@gmail.com>
%   University of Wisconsin-Madison
%   Feb-05-2014
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

function varargout=MU_display_initialize(hObject,handles,currentMatrix,TMatrix)

%------------------------------------------------matrix
% pre-process matrix
dimSize=size(TMatrix);

dimFlag =1; % reset dim panel, default yes
funcFlag =1; % rest func panel, default yes
if isfield(handles,'V')
    if numel(dimSize) == numel(handles.V.DimSize)
        funcFlag = 0;
        if sum((handles.V.DimSize - dimSize).^2)==0
            dimFlag = 0;
        end
    end
end

TMatrix(isnan(TMatrix))=0;
TMatrix(isinf(TMatrix))=0;
Max_D=max(TMatrix(:));
Min_D=min(TMatrix(:));
if Max_D==Min_D
    warndlg(['Matrix does not have element variation,' ' Matrix == ' num2str(Max_D)]);
    delete(hObject);
    varargout{1}=[];
    return;
end

% initialize structures
Localizer=struct(... % localizer line structure
    'Local_switch', 0,...
    'Local_flag', 0,...
    'Local_h1', [],...
    'Local_h2',[],...
    'Local_point',[ceil(dimSize(2)/2) ceil(dimSize(1)/2)] ...
    );

ROI=struct(... % ROI structure
    'ROI_flag', 0,...
    'ROI_mov',[],...
    'ROI_Stat_h', [],...
    'ROI_h', [] ...
    );

V=struct(... % background matrix display structure
    'Current_matrix',currentMatrix,...
    'DimSize', dimSize,...
    'DimPointer',ones(size(dimSize)),...
    'Xlim', [0.5 dimSize(2)+0.5],...
    'Ylim', [0.5 dimSize(1)+0.5],...
    'Min_D', Min_D,...
    'Max_D', Max_D,...
    'Slice',1,...
    'Layer',1,...
    'Row',dimSize(1),...
    'Column',dimSize(2),...
    'C_lower',Min_D,...
    'C_upper',Max_D,...
    'Color_map','Gray',...
    'Color_bar',1,...
    'Grid', 'off',...
    'Localizer',Localizer, ...
    'ROI',ROI,...
    'Segs',[]...
    );
if numel(dimSize)>=3
    V.Layer = dimSize(3);
end

V2=struct(...  % foreground matrix display structure
    'Foreground_matrix',[],...
    'F_lower',[],...
    'F_upper',[],...
    'Backgroud_F',[],...
    'Foregroud_F',[],...
    'Color_map',[],...
    'Color_bar',[]...
    );

handles.V=V;
handles.V2=V2;
handles.TMatrix=TMatrix;
handles.Mask=zeros(dimSize(1:min(3,numel(dimSize))),'int8');

% kinetic dimension profile
handles.KFlag=1;
handles.KCurve={}; % no curves
handles.KHandle=[]; % no curve handles
handles.KDim=[]; % no curve dimension info

% instant magnifier
handles.MHandle=[]; % no magnifier
handles.MMatrix=[]; % no magnified area
handles.MPad=zeros(10,10); % magnifier pad

% 3D slicer flag
handles.Slicer = 0;

% imcontrast flag
handles.Imcontrast = 0;

% wheel scroll flag
handles.Wheel = 1; % allow wheel scroll slice

% output handle
handles.output=hObject;

%-----------------------------------------------graphics
% initialize color group
set(handles.Matrix_name_edit,'String',currentMatrix);
set(handles.C_upper_slider,'Min',Min_D);
set(handles.C_upper_slider,'Max',Max_D);
set(handles.C_upper_slider,'Value',Max_D);
set(handles.C_upper_edit,'String',num2str(Max_D));
set(handles.C_lower_slider,'Min',Min_D);
set(handles.C_lower_slider,'Max',Max_D);
set(handles.C_lower_slider,'Value',Min_D);
set(handles.C_lower_edit,'String',num2str(Min_D));

% load button icon
MU_icon(handles.MatrixCalc_pushbutton,[handles.path handles.sep '..' handles.sep 'Resource' handles.sep 'Icon' handles.sep 'MatrixCalc.gif']);
MU_icon(handles.Upload_pushbutton,[handles.path handles.sep '..' handles.sep 'Resource' handles.sep 'Icon' handles.sep 'Upload.gif']);

% initialize function bench tabgroup
if funcFlag
    MU_update_func_control(handles)
    handles=guidata(hObject);
end

% initialize dimension tabgroup
if dimFlag
    MU_update_dim_control(handles, dimSize);
    handles=guidata(hObject);
end
%------------------------------------------------handles

varargout{1}=handles;

end