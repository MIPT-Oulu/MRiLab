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

function MU_funcLoadSeg(Temp,Event,handles)
handles = guidata(handles.MU_matrix_display);

[filename,pathname]=uigetfile({'*.mat','MAT-files (*.mat)'},'MultiSelect','off');
if filename==0
    return;
end
load([pathname filename]);
try
    if ~isequal(size(handles.Mask),size(Mask))
        error('Segmentation mask has different matrix size.');
    end
    handles.V.Segs=Segs;
    handles.Mask=Mask;
    handles=MU_update_image(handles.Matrix_display_axes,{handles.TMatrix,handles.Mask},handles,0);
catch me
    error_msg{1,1}='ERROR!!! Loading segmentation fails.';
    error_msg{2,1}=me.message;
    errordlg(error_msg);
    return;
end
guidata(handles.MU_matrix_display, handles);

end