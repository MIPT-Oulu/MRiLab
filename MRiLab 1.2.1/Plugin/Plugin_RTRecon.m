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

function Plugin_RTRecon

global VCtl
global VImg
global VSig

if ~isfield(VCtl, 'RTR_Flag')
    return;
end

if ~strcmp(VCtl.RTR_Flag, 'on')
    return;
end

Simuh=guidata(VCtl.h.TimeWait_text);
DoUpdateInfo(Simuh,'Real time reconstructing images...');
try 
    %%  Do image reconstruction
    ExecFlag=DoImgRecon(Simuh);
    if ExecFlag==0
        error('Real time image recon is incomplete!');
    end
    DoUpdateInfo(Simuh,'Real time image recon is complete.');

    %% Output K-space plot
    if strcmp(VCtl.PlotK_Flag, 'on')
        [az,el] = view(Simuh.Coronal_axes);
        axes(Simuh.Coronal_axes);
        cla(Simuh.Coronal_axes);
        plot3(VSig.Kx(:),VSig.Ky(:),VSig.Kz(:),'w-');
        grid on;
        set(gca,'Color','k','xcolor','c','ycolor','c','zcolor','c');
        set(gca,'ydir','reverse');
        xlabel('Kx','Color','w');
        ylabel('Ky','Color','w');
        zlabel('Kz','Color','w');
        axis tight;
        box on;
        set(Simuh.Coronal_axes,'view',[az,el]);
        set(Simuh.CZ_text,'Visible','off');
        set(Simuh.CX_text,'Visible','off');
        set(Simuh.Left_text,'Visible','off');
        set(Simuh.Right_text,'Visible','off');
        set(Simuh.Axial_slider,'Visible','off');
        set(Simuh.Sagittal_slider,'Visible','off');
        set(Simuh.Coronal_slider,'Visible','off');
        set(Simuh.AxialFOV,'Visible','off');
        set(Simuh.SagittalFOV,'Visible','off');
        set(Simuh.Coronal_uipanel,'Title','Real Time K-space');
    end
    
    %%  Output image display
    Slice=round(get(Simuh.Preview_slider,'Value'));
    if Slice==0
       set(Simuh.Preview_slider,'Value',1);
    end
    
    Img = sum(VImg.Mag, 4); % show SumofMagn
    Simuh.Img = Img(:,:,:,1); % show first echo
    Simuh.IV=struct(...
        'Slice', min(max(1,Slice), VCtl.SliceNum),...
        'C_lower',min(min(min(Simuh.Img))),...
        'C_upper',max(max(max(Simuh.Img))),...
        'Axes','off',...
        'Grid','off',...
        'Color_map','Gray'...
        );
    DoUpdateImage(Simuh.Preview_axes,Simuh.Img,Simuh.IV);
    set(Simuh.Preview_uipanel,'Title',['Preview : Series' num2str(Simuh.ScanSeriesInd) '...']);
    [row,col,layer]=size(Simuh.Img);
    if layer==1
        set(Simuh.Preview_slider,'Enable','off');
    else
        set(Simuh.Preview_slider,'Enable','on');
        set(Simuh.Preview_slider,'Min',1,'Max',layer,'SliderStep',[1/layer, 4/layer]);
    end
    
    %% Update handles
    guidata(Simuh.SimuPanel_figure, Simuh);
    pause(VCtl.DelayTime);
catch me
    DoUpdateInfo(Simuh,'Real time image recon is incomplete!');
end

end