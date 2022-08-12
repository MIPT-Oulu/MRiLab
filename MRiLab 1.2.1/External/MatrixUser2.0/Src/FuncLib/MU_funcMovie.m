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

function MU_funcMovie(Temp,Event,handles)
handles=guidata(handles.MU_matrix_display);

if length(handles.V.DimSize)==2
    warndlg('At least 3D matrix is needed for generating movie.');
    return;
end

dimFlag = ['[:' repmat(',:', [1 length(handles.V.DimSize)-1]) ']'];
dim = inputdlg(['Please specify dimension flag for generating movie. Use '':'' to include all content in the dimension; Use ''start:end'' to include parts of the content in the dimension.'],'Specify Dimension Flag',1,{dimFlag});
if isempty(dim)
    warndlg('Making movie was cancelled.');
    return;
end

movie = inputdlg({'Please specify the frame rate (fps).', 'Please specify the movie quality (lowest 0 - 100 highest)'},'About Movie',1,{'30' ,'75'});
if isempty(movie)
    warndlg('Making movie was cancelled.');
    return;
end

MergeM=get(handles.Matrix_name_edit,'String');
name = inputdlg(['Please input an name for the movie file.'],'Specify File Name',1,{[MergeM '_mov']});
if isempty(dim)
    warndlg('Making movie was cancelled.');
    return;
end

pause(0.1);
try 
    eval(['TMatrix=handles.TMatrix(' dim{1}(2:end-1) ');']);
    TSize=size(TMatrix);
    TMatrix=TMatrix(:,:,:);
    dimSize=size(TMatrix);
    TMatrix=reshape(TMatrix,[dimSize(1) dimSize(2) 1 dimSize(3)]);
    
    if isempty(handles.V2.Foreground_matrix) % no overlay
        
        Colormap = colormap(handles.Matrix_display_axes);
        TMatrix=double(TMatrix);
        TMatrix(TMatrix<=handles.V.C_lower) = handles.V.C_lower;
        TMatrix(TMatrix>=handles.V.C_upper) = handles.V.C_upper;
        TMatrix=TMatrix-min(TMatrix(:));
        TMatrix=(TMatrix./max(TMatrix(:)))*length(Colormap(:,1)-1)+1;
        
        M=immovie(TMatrix,Colormap);
        
    else % if overlay
        BImage=double(repmat(TMatrix,[1 1 3 1]))* handles.V2.Backgroud_F;
        BImage=max(double(handles.V.C_lower),min(BImage,double(handles.V.C_upper))); % Make sure BImage is in the range of Color Bound
        BImage=(BImage-min(BImage(:)))./double((handles.V.C_upper-handles.V.C_lower));
        
        eval(['mask=double(handles.Mask(' dim{1}(2:end-1) '));']); % multi-dimensional mask??????
        TSize2=size(mask);
        if length(TSize)>length(TSize2) & length(TSize2)==2
            mask=repmat(mask,[1,1,prod(TSize(3:end))]);
        elseif length(TSize)>length(TSize2) & length(TSize2)==3
            mask=repmat(mask,[1,1,1,prod(TSize(4:end))]);
        end
        mask=mask(:,:,:);
        FMatrix=((mask-handles.V2.F_lower)/(handles.V2.F_upper-handles.V2.F_lower))*64;
        FMatrix(mask==0)=1;
        FImage=ind2rgb(ceil(FMatrix(:)),handles.V2.Color_map)* handles.V2.Foregroud_F;
        FImage=reshape(FImage,[size(FMatrix) 3]);
        FImage(repmat(mask,[1 1 1 3])==0)=0;
        FImage=permute(FImage,[1 2 4 3]);
        RGBImage=BImage+FImage;
        RGBImage=max(0,min(RGBImage,1)); % Make sure RGBImage is in the range of 0 and 1
        
        M=immovie(RGBImage);
    end
    
    writerObj=VideoWriter(name{1});
    writerObj.FrameRate=str2double(movie{1});
    writerObj.Quality=str2double(movie{2});
    open(writerObj);
    writeVideo(writerObj,M);
    msgbox(['Movie file ' char(39) writerObj.Filename char(39) ' has been generated at ' char(39) writerObj.Path char(39) '.'],'Movie File');
    close(writerObj);
catch me
    error_msg{1,1}='Making movie failed! Error occured during movie generation process.';
    error_msg{2,1}=me.message;
    errordlg(error_msg);
    return;
end

% update current display matrix
handles=MU_update_image(handles.Matrix_display_axes,{handles.TMatrix,handles.Mask},handles,0);
guidata(handles.MU_matrix_display, handles);

end