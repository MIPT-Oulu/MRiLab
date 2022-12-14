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

function MU_funcNoise(Temp,Event,handles)
handles=guidata(handles.MU_matrix_display);

[Type,ok] = listdlg('ListString',{'Gaussian white noise','Salt & Pepper','Multiplicative noise (speckle)'}, ...
                         'SelectionMode','single',...
                         'PromptString','Noise Type',... 
                         'Name','Type');
if ok==0
    warndlg('Adding noise is cancelled.');
    return;
end

switch Type
    case 1 % gaussian
        f = inputdlg({'Mean:', 'Variance:'},'Gaussian White Noise',1,{'0' ,'1'});
        if isempty(f)
            warndlg('Adding noise is cancelled.');
            return;
        end
    case 2 % salt & pepper
        f = inputdlg({'Noise percent (%):'},'Salt & Pepper',1,{'5'});
        if isempty(f)
            warndlg('Adding noise is cancelled.');
            return;
        end
    case 3 % speckle
        f = inputdlg({'Noise variance:'},'Multiplicative Noise',1,{'0.04'});
        if isempty(f)
            warndlg('Adding noise is cancelled.');
            return;
        end
end

choice = questdlg('Apply to all slices?','All Slices','No','Yes','No');
if isempty(choice)
    warndlg('Adding noise is cancelled.');
    return;
end
% Handle response
switch choice
    case 'No'
        TMatrix = handles.BMatrix;
    case 'Yes'
        TMatrix = handles.TMatrix;
end

TMatrix = double(TMatrix); % convert to double

switch Type
    case 1
        TMatrix = TMatrix + str2double(f{1}) + sqrt(str2double(f{2})) * randn(size(TMatrix));
    case 2
        [row,col,layer] = size(TMatrix);
        maxT=max(TMatrix(:));
        minT=min(TMatrix(:));
        numPx = str2double(f{1}) * row * col *layer /100;
        Idx = randi(row * col * layer, [round(numPx), 1]);
        TMatrix(Idx(1:floor(end/2))) = maxT;
        TMatrix(Idx(ceil(end/2):end)) = minT;
    case 3
        TMatrix = TMatrix + ((2*sqrt(3)*sqrt(str2double(f{1})))*rand(size(TMatrix)) + (-sqrt(3)*sqrt(str2double(f{1})))) .* TMatrix;
end

TMatrix = cast(TMatrix, class(handles.BMatrix)); % convert back to whatever original

switch choice
    case 'No'
        handles.TMatrix(:,:,handles.V.Slice) = TMatrix;
    case 'Yes'
        handles.TMatrix = TMatrix;
end

MergeM=get(handles.Matrix_name_edit,'String');
set(handles.Matrix_name_edit,'String',[MergeM '_noi']);

% update current display matrix
handles=MU_update_image(handles.Matrix_display_axes,{handles.TMatrix,handles.Mask},handles,0);
guidata(handles.MU_matrix_display, handles);

end