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

%windows for setting parameters
function MU_setting_windows(flag,h) 

Matrix_names = evalin('base', 'who');
TMatrix=h.TMatrix;
    
switch flag
    %% Voxel Stats Window
    case 1
        figure('Resize','off','position',[100 120 560 550],'Name','Voxel Statistics','MenuBar','none');
        Hist=axes('position',[.1  .5  .8  .4]);
        if isfield(h,'ROIData')
            TTMatrix=h.ROIData;
        else
            TTMatrix=TMatrix(:,:,h.V.Slice);
        end
        
        uicontrol('Style', 'text', 'String', 'Upper Bound','Position', [60  220  80  15]);
        uicontrol('Style', 'text', 'String', 'Lower Bound','Position', [60  190  80  15]); 
        B_upper_v=uicontrol('Style', 'text', 'String', '','Position', [450  220  80  15]);
        B_lower_v=uicontrol('Style', 'text', 'String', '','Position', [450  190  80  15]); 
        B_upper=uicontrol('Style', 'slider',...
                          'Position', [160  220  280  15],...
                          'Min',min(min(TTMatrix)),...
                          'Max',max(max(TTMatrix)),...
                          'Value',max(max(TTMatrix)));

        B_lower=uicontrol('Style', 'slider',...
                          'Position', [160  190  280  15],...
                          'Min',min(min(TTMatrix)),...
                          'Max',max(max(TTMatrix)),...
                          'Value',min(min(TTMatrix)));

        uicontrol('Style', 'text', 'String', 'Max value','Position', [60  160  80  15]);
        Max_v=uicontrol('Style', 'text', 'String', '','Position', [160  160  80  15]);
        uicontrol('Style', 'text', 'String', 'Min value','Position', [60  130  80  15]);
        Min_v=uicontrol('Style', 'text', 'String', '','Position', [160  130  80  15]);
        uicontrol('Style', 'text', 'String', 'Mean value','Position', [60  100  80  15]);
        Mean_v=uicontrol('Style', 'text', 'String', '','Position', [160  100  80  15],'ForegroundColor','g');
        uicontrol('Style', 'text', 'String', 'Median value','Position', [60  70  80  15]);
        Median_v=uicontrol('Style', 'text', 'String', '','Position', [160  70  80  15],'ForegroundColor','r');
        uicontrol('Style', 'text', 'String', 'Standard Dev.','Position', [60  40  80  15]);
        SD_v=uicontrol('Style', 'text', 'String', '','Position', [160  40  80  15]);
        uicontrol('Style', 'text', 'String', 'Skewness','Position', [300  160  80  15]); 
        Skewness_v=uicontrol('Style', 'text', 'String', '','Position', [400  160  80  15]);
        uicontrol('Style', 'text', 'String', 'Kurtosis','Position', [300  130  80  15]);
        Kurtosis_v=uicontrol('Style', 'text', 'String', '','Position', [400  130  80  15]);
        uicontrol('Style', 'text', 'String', '90th Perc.','Position', [300  100  80  15]); 
        Nin_v=uicontrol('Style', 'text', 'String', '','Position', [400  100  80  15],'ForegroundColor','c');
        uicontrol('Style', 'text', 'String', '10th Perc.','Position', [300  70  80  15]); 
        Ten_v=uicontrol('Style', 'text', 'String', '','Position', [400  70  80  15],'ForegroundColor','m');
        uicontrol('Style', 'text', 'String', '*Note: voxels with value of 0 are not included for statistical calculation!!!','Position', [200  10  350  15]); 

        Hist_h=struct(...
                    'V',h.V,...
                    'Hist',Hist,...
                    'B_upper',B_upper,...
                    'B_lower',B_lower,...
                    'B_upper_v',B_upper_v,...
                    'B_lower_v',B_lower_v,...
                    'Max_v',Max_v,...
                    'Min_v',Min_v,...
                    'Mean_v',Mean_v,...
                    'Median_v',Median_v,...
                    'SD_v',SD_v,...
                    'Skewness_v',Skewness_v,...
                    'Kurtosis_v',Kurtosis_v,...
                    'Nin_v',Nin_v,...
                    'Ten_v',Ten_v);

        set(B_upper,'Callback',{@MU_dispHist,TTMatrix,Hist_h});
        set(B_lower,'Callback',{@MU_dispHist,TTMatrix,Hist_h});
        MU_dispHist([],[],TTMatrix,Hist_h);
    %% Set Montage Window
    case 2
        Cre_Mont=figure('Resize','off','position',[100 120 280 300],'Name','Creating Montage','MenuBar','none');

        uicontrol('Style', 'text', 'String', 'Chosen Slices','Position', [20  200  100  20]);
        uicontrol('Style', 'text', 'String', 'Montage Layout','Position', [20  120  100  20]);

        uicontrol('Style', 'text', 'String', 'Slice starts from','Position', [60  220  120  20]);
        Sli_from=uicontrol('Style', 'edit', 'String', '1','Position', [180  220  70  20]);
        uicontrol('Style', 'text', 'String', 'Slice ends to','Position', [60  180  120  20]);
        Sli_to=uicontrol('Style', 'edit', 'String', num2str(h.V.Layer),'Position', [180  180  70  20]);

        uicontrol('Style', 'text', 'String', 'Number of row','Position', [60  140  120  20]);
        Mont_row=uicontrol('Style', 'edit', 'String', '3','Position', [180  140  70  20]);
        uicontrol('Style', 'text', 'String', 'Number of column','Position', [60  100  120  20]);
        Mont_col=uicontrol('Style', 'edit', 'String', '4','Position', [180  100  70  20]);

        Mont_h=struct(...
                    'V',h.V,...
                    'Cre_Mont',Cre_Mont,...
                    'Sli_from',Sli_from,...
                    'Sli_to',Sli_to,...
                    'Mont_row',Mont_row,...
                    'Mont_col',Mont_col...
                     );

        uicontrol('Style', 'Pushbutton', 'String', 'Create Montage',...
                  'Position', [20  20  120  30],... 
                  'Callback',{@MU_dispMontage,TMatrix,Mont_h});
    %% Set Resolution Window
    case 3
        Set_Res=figure('Resize','off','position',[100 120 340 200],'Name','Change Resolution','MenuBar','none');
        
        uicontrol('Style', 'text', 'String', 'X-Resolution Factor :','Position', [60  170  120  15]);
        uicontrol('Style', 'text', 'String', 'Y-Resolution Factor :','Position', [60  140  120  15]);
        uicontrol('Style', 'text', 'String', 'Z-Resolution Factor :','Position', [60  110  120  15]);
        uicontrol('Style', 'text', 'String', 'Interpolation Method :','Position', [60  75  120  15]);
        Method=uicontrol('Style', 'popupmenu', 'String', {'linear';'nearest';'cubic'},'Position', [200  80  80  15]);
        Xf_v=uicontrol('Style', 'edit', 'String', '1','Position', [200  170  80  15]);
        Yf_v=uicontrol('Style', 'edit', 'String', '1','Position', [200  140  80  15]);
        Zf_v=uicontrol('Style', 'edit', 'String', '1','Position', [200  110  80  15]);
        Res=uicontrol('Style', 'pushbutton', 'String', 'Change Resolution','Position', [60  30  120  25]);

        Res_h=struct(...
                     'Set_Res', Set_Res,...
                     'main_h', h, ...
                     'Method', Method,...
                     'Xf_v', Xf_v,...
                     'Yf_v', Yf_v,...
                     'Zf_v', Zf_v ...
                     );
        set(Res,'Callback',{@MU_changeRes,Res_h});
    %% Upload Temporary Matrix (old method)
    case 4
        Upload_Tmp=figure('Resize','off','position',[100 120 340 100],'Name','Append Current Temporary Matrix','MenuBar','none');
        uicontrol('Style', 'text', 'String', 'Matrix Name :','Position', [60  60  80  20]);
        Matrix_name=uicontrol('Style', 'edit', 'String', [h.V.Current_matrix '_2'],'Position', [150  60  160  20]);
        
        Upload_h=struct(...
                      'main_h',h,...
                      'Matrix_name',Matrix_name,...
                      'Upload_Tmp',Upload_Tmp ...
                      );
        
        uicontrol('Style', 'pushbutton', 'String', 'Append','Position', [60  20  80  25],...
                  'Callback',{@MU_uploadTmp,Upload_h});
    %% Manual Lesion Segmentation
    case 5
    %% Image fusion
    case 6
        Img_Fuse=figure('Resize','off','position',[100 120 400 500],'Name',['Image superimposed to ' h.V.Current_matrix],'MenuBar','none');
        uicontrol('Style', 'text', 'String', 'Back Fraction','Position', [20  130  80  15]);
        uicontrol('Style', 'text', 'String', 'Fore Fraction','Position', [20  100  80  15]); 
        uicontrol('Style', 'text', 'String', 'Fore Upper','Position', [20  70  80  15]); 
        uicontrol('Style', 'text', 'String', 'Fore Lower','Position', [20  40  80  15]); 
        uicontrol('Style', 'text', 'String', 'Fore Colormap','Position', [20  160  80  15]); 
        coloraxis=axes('Position', [0.75  0.4  0.4  0.5],'Visible','off'); 
        Matrix_list=uicontrol('Style', 'listbox', 'String', '','Position', [20  200  250  250]);
        [tr,tc,tl,tt]=size(TMatrix); % Foregound need to have the same dimension as that of backgroud;
        ind=1;
        for i=1:max(size(Matrix_names))
            [r,c,l]=evalin('base', ['size(' Matrix_names{i} ');']);
            if sum(([tr tc tl]-[r c l]).^2)==0 & evalin('base', ['isreal(' Matrix_names{i} ');'])
                Allowed_Foreground{ind}=Matrix_names{i};
                ind=ind+1;
            end
        end
        if ind==1
            close(Img_Fuse);
            errordlg('No matrix can be fused with current matrix!');
            return;
        end
        set(Matrix_list,'String',Allowed_Foreground);
        BF_v=uicontrol('Style', 'text', 'String', '','Position', [310  130  80  15]);
        FF_v=uicontrol('Style', 'text', 'String', '','Position', [310  100  80  15]); 
        F_u=uicontrol('Style', 'text', 'String', '','Position', [310  70  80  15]); 
        F_l=uicontrol('Style', 'text', 'String', '','Position', [310  40  80  15]); 
        BF=uicontrol('Style', 'slider','Position', [120  130  180  15]);
        FF=uicontrol('Style', 'slider','Position', [120  100  180  15]);
        Fu=uicontrol('Style', 'slider','Position', [120  70  180  15]);
        Fl=uicontrol('Style', 'slider','Position', [120  40  180  15]);
                      
        Colormap=uicontrol('Style', 'popupmenu', 'String', {'Jet';...
                                                            'Hot';...
                                                            'HSV';...
                                                            'Cool';...
                                                            'Spring';...
                                                            'Summer';...
                                                            'Autumn';...
                                                            'Winter';...
                                                            'Bone';...
                                                            'Copper';...
                                                            'Pink';...
                                                            'Lines'},...
                                                            'Position', [120  160  100  15]);
        
        colorbar('location','WestOutside');
       
          Fuse_h=struct(...
                        'Img_Fuse',Img_Fuse,...
                        'main_h',h,...
                        'Matrix_list',Matrix_list,...
                        'BF',BF,...
                        'FF',FF,...
                        'Fu',Fu,...
                        'Fl',Fl,...
                        'BF_v',BF_v,...
                        'FF_v',FF_v,...
                        'F_u',F_u,...
                        'F_l',F_l,...
                        'Colormap',Colormap,...
                        'coloraxis',coloraxis);

        set(BF,'Callback',{@MU_imgFuse,Fuse_h,Allowed_Foreground},'Enable','off');
        set(FF,'Callback',{@MU_imgFuse,Fuse_h,Allowed_Foreground},'Enable','off');
        set(Fu,'Callback',{@MU_imgFuse,Fuse_h,Allowed_Foreground},'Enable','off');
        set(Fl,'Callback',{@MU_imgFuse,Fuse_h,Allowed_Foreground},'Enable','off');
        set(Colormap,'Callback',{@MU_imgFuse,Fuse_h,Allowed_Foreground},'Enable','off');
        set(Matrix_list,'Callback',{@MU_selimgFuse,Fuse_h,Allowed_Foreground});
        
end


end