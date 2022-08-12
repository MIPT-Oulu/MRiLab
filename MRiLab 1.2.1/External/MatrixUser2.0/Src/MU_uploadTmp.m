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

% Append Current Temporary Matrix
function MU_uploadTmp(h)
handles = guidata(h.MU_matrix_display);
MatrixName=get(h.Matrix_name_edit,'String');
try
    if ~isempty(h.V.ROI)
        switch h.V.ROI.ROI_flag
            case {7,8,9}
                Flag = MU_load_matrix([MatrixName '_tmp'], h.Mask, 0);
            otherwise
                TMatrix=MU_Crop(handles);
                Flag = MU_load_matrix([MatrixName '_tmp'], TMatrix, 0);
        end
    else
        TMatrix=MU_Crop(handles);
        Flag = MU_load_matrix([MatrixName '_tmp'], TMatrix, 0);
    end
catch me
    error_msg{1,1}='ERROR!!! Saving current matrix aborted.';
    error_msg{2,1}=me.message;
    errordlg(error_msg);
    return;
end

if ~Flag
    errordlg('Uploading temporary matrix failed!');
end

end

function TMatrix=MU_Crop(handles)

if numel(handles.V.DimSize)>=3
    dim = inputdlg(['Please specify up to which dimension to save (2 ~ ' num2str(numel(handles.V.DimSize)) ').'],'Specify Dimension',1,{num2str(numel(handles.V.DimSize))});
    if isempty(dim)
        error('Saving matrix was cancelled.');
    end
    try
        if str2double(dim{1})<2 | str2double(dim{1})>numel(handles.V.DimSize)
            error('The input dimension is invalid.');
        end
        if str2double(dim{1}) == 2
            TMatrix=handles.TMatrix(:,:,handles.V.Slice);
        else
            if str2double(dim{1})+1>numel(handles.V.DimSize)
                dimFlag =[];
            else
                dimFlag=num2str(handles.V.DimPointer(str2double(dim{1})+1:end),',%u');
            end
            eval(['TMatrix=handles.TMatrix(:,:' repmat(',:', [1 str2double(dim{1})-2]) dimFlag ');']);
        end
    catch me
        error('The input dimension is invalid.');
    end
else
    TMatrix=handles.TMatrix(:,:);
end


end

