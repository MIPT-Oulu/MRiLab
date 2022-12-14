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

function MU_funcExtract(Temp,Event,handles)
handles = guidata(handles.MU_matrix_display);

[Type,ok] = listdlg('ListString',{'Free-hand shape','Polygon shape','Circle shape'}, ...
                     'SelectionMode','single',...
                     'PromptString','Choose region shape',... 
                     'Name','Shape');
if ok==0
    warndlg('Extracting matrix is cancelled.');
    return;
end

MU_enable('off',[],handles);
switch Type
    case 1
        ROI_h=imfreehand;
    case 2
        ROI_h=impoly;
    case 3
        ROI_h=imellipse;
end
wait(ROI_h);
MU_enable('on',[],handles);

p=round(getPosition(ROI_h));

switch Type
    case 1
        p=[min(p(:,1)) min(p(:,2)) max(p(:,1))-min(p(:,1)) max(p(:,2))-min(p(:,2))];
    case 2
        p=[min(p(:,1)) min(p(:,2)) max(p(:,1))-min(p(:,1)) max(p(:,2))-min(p(:,2))];
end

if p(1)+p(3)>handles.V.Column | p(2)+p(4)>handles.V.Row | p(1)<1 | p(2)<1
    delete(ROI_h);     
    errordlg('Out of range subscript.');     
    return; 
end

BW=createMask(ROI_h);
BW=BW(p(2):p(2)+p(4),p(1):p(1)+p(3));

if numel(handles.V.DimSize)>=3
    dim = inputdlg(['Please specify up to which dimension to extract (2 ~ ' num2str(numel(handles.V.DimSize)) ').'],'Specify Dimension',1,{num2str(numel(handles.V.DimSize))});
    if isempty(dim)
        warndlg('Extracting was cancelled.');
        return;
    end
    try
        if str2double(dim{1})<2 | str2double(dim{1})>numel(handles.V.DimSize)
            errordlg('The input dimension is invalid.');
            return;
        end
        if str2double(dim{1}) == 2
            TMatrix=handles.TMatrix(p(2):p(2)+p(4),p(1):p(1)+p(3),handles.V.Slice);
            
        else
            if str2double(dim{1})+1>numel(handles.V.DimSize)
                dimFlag =[];
            else
                dimFlag=num2str(handles.V.DimPointer(str2double(dim{1})+1:end),',%u');
            end
            eval(['TMatrix=handles.TMatrix(p(2):p(2)+p(4),p(1):p(1)+p(3)' repmat(',:', [1 str2double(dim{1})-2]) dimFlag ');']);
            TSize=size(TMatrix);
            TSize(1)=1;
            TSize(2)=1;
            BW=repmat(BW,TSize);
        end
    catch me
        errordlg('The input dimension is invalid.');
        return;
    end
    
else
    TMatrix=handles.TMatrix(p(2):p(2)+p(4),p(1):p(1)+p(3));
end

MatrixName=get(handles.Matrix_name_edit,'String');
TMatrix = cast(double(TMatrix).*BW, class(TMatrix)); % convert back to whatever original
if ~MU_load_matrix([MatrixName '_ext'], TMatrix, 1)
    errordlg('Matrix extracting failed!');
end


end