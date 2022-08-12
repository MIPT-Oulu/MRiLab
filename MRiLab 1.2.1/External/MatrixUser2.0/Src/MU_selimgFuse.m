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


% Fuse Image
function MU_selimgFuse(Temp,Event,h,Allowed_Foreground)
h.main_h=guidata(h.main_h.MU_matrix_display);


selected_matrix= evalin('base', [Allowed_Foreground{get(h.Matrix_list,'Value')} ';']);
selected_matrix(isnan(selected_matrix))=0;
selected_matrix(isinf(selected_matrix))=0;
Max_v=max(max(max(selected_matrix)));
Min_v=min(min(min(selected_matrix)));

set(h.BF,'Enable','on');
set(h.FF,'Enable','on');
set(h.Fu,'Enable','on');
set(h.Fl,'Enable','on');
set(h.Colormap,'Enable','on');
set(h.Fu,'Min',Min_v,'Max',Max_v,'Value',Max_v);
set(h.Fl,'Min',Min_v,'Max',Max_v,'Value',Min_v);
set(h.BF,'Min',0,'Max',1,'Value',0.5);
set(h.FF,'Min',0,'Max',1,'Value',0.5);
set(h.F_u,'String',Max_v);
set(h.F_l,'String',Min_v);
set(h.BF_v,'String',0.5);
set(h.FF_v,'String',0.5);

contents=cellstr(get(h.Colormap,'String'));
color=contents{get(h.Colormap,'Value')};
caxis([get(h.Fl,'Value') get(h.Fu,'Value')])
cmap=colormap(color);

V2=struct(...
        'Foreground_matrix',Allowed_Foreground{get(h.Matrix_list,'Value')},...
        'F_lower',get(h.Fl,'Value'),...
        'F_upper',get(h.Fu,'Value'),...
        'Backgroud_F',get(h.BF,'Value'),...
        'Foregroud_F',get(h.FF,'Value'),...
        'Color_map',cmap,...
        'Color_bar',1 ...
        );
selected_matrix(selected_matrix>=get(h.Fu,'Value')& selected_matrix~=0 )=get(h.Fu,'Value');
selected_matrix(selected_matrix<=get(h.Fl,'Value')& selected_matrix~=0 )=get(h.Fl,'Value');
h.main_h.Mask=selected_matrix;
h.main_h.V2=V2;
h.main_h=MU_update_image(h.main_h.Matrix_display_axes,{h.main_h.TMatrix,h.main_h.Mask},h.main_h,0);
% MU_update_ass_image({h.main_h.Matrix_display_axes2,h.main_h.Matrix_display_axes3},{h.main_h.SMatrix,h.main_h.CMatrix},h.main_h);
set(h.main_h.C_upper_edit,'String',num2str(h.main_h.V.C_upper));
set(h.main_h.C_upper_slider,'Value',h.main_h.V.C_upper);
set(h.main_h.C_lower_edit,'String',num2str(h.main_h.V.C_lower));
set(h.main_h.C_lower_slider,'Value',h.main_h.V.C_lower);
guidata(h.main_h.MU_matrix_display, h.main_h);

end