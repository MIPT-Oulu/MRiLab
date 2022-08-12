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

function MU_funcProfile(Temp,Event,handles)
handles = guidata(handles.MU_matrix_display);

MU_enable('off',[],handles);
ROI_h=imline;
MU_enable('on',[],handles);
p=round(getPosition(ROI_h));
try
    BW=createMask(ROI_h);
catch me
    delete(ROI_h);
    errordlg(me.message);
    return;
end
p=[min(p(:,1)) min(p(:,2)) max(p(:,1))-min(p(:,1)) max(p(:,2))-min(p(:,2))];
TTMatrix=handles.TMatrix(p(2):p(2)+p(4),p(1):p(1)+p(3),handles.V.Slice);
TTMatrix=TTMatrix(double(BW(p(2):p(2)+p(4),p(1):p(1)+p(3)))~=0);
TTMatrix=double(TTMatrix);

[I,J] = ind2sub(size(BW(p(2):p(2)+p(4),p(1):p(1)+p(3))),find(BW(p(2):p(2)+p(4),p(1):p(1)+p(3))~=0));
Dist=sqrt((I-repmat(I(1),size(I))).^2+(J-repmat(J(1),size(J))).^2);

Plot_handle=MU_Plot;
set(Plot_handle,'Name','1D Profile','DeleteFcn',{@deletefig,ROI_h});
Plot_handles=guidata(Plot_handle);
ROI_Stat_h=Plot_handles.Plot_axes;
plot(ROI_Stat_h,Dist(:),TTMatrix);
grid(ROI_Stat_h,'on');
ylabel(ROI_Stat_h,'Voxel Value','FontSize',10);
xlabel(ROI_Stat_h,'Voxel Distance','FontSize',10);

handles.V.ROI=struct(...
                     'ROI_flag', 6,...
                     'ROI_mov',[],...  % ROI movement track
                     'ROI_Stat_h', ROI_Stat_h,...    
                     'ROI_h', ROI_h ...
                     );

addNewPositionCallback(ROI_h,@(p) MU_ROI_stat(p,ROI_h,[],handles));
fcn=makeConstrainToRectFcn('imline',[0.5 handles.V.Column+0.4],[0.5 handles.V.Row+0.4]);
setPositionConstraintFcn(ROI_h,fcn);

function deletefig(Temp,Event,ROI_h)
if ROI_h.isvalid == 1
    delete(ROI_h);
end
end


end