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

function DoPostScan(Simuh)

global VCtl
global VImg
global VCoi

DoUpdateInfo(Simuh,'Scan is complete!');
set(Simuh.TimeWait_text,'String', ['Est. Time Left :  ' '~' ' : ' '~' ' : ' '~']);

%% Signal Post-Processing
%  Add noise
DoAddNoise;

%% Image reconstruction
if strcmp(VCtl.AutoRecon,'on')
    
    %  Do image reconstruction
    DoUpdateInfo(Simuh,'Reconstructing images...');
    ExecFlag=DoImgRecon(Simuh);
    if ExecFlag==0
        error('Image recon is incomplete!');
    end
    DoUpdateInfo(Simuh,'Image recon is complete.');
    
    %  Enable channel selection
    channel = {'SumofMagn';'SumofCplx'};
    for i = 1:VCoi.RxCoilNum
        channel{i+2} = i;
    end
    set(Simuh.Channel_popupmenu,'String',channel);
    set(Simuh.Channel_popupmenu,'Enable','on');
    
    %  Enable echo selection
    echo = {};
    for i = 1:size(VImg.Mag,5)
        echo{i} = i;
    end
    set(Simuh.Echo_popupmenu,'String',echo);
    set(Simuh.Echo_popupmenu,'Enable','on');
    
    %  Output image display
    set(Simuh.Channel_popupmenu,'Value', 1);
    set(Simuh.Echo_popupmenu,'Value', 1);
    Simuh=guidata(Simuh.SimuPanel_figure);
    Img = sum(VImg.Mag, 4); % show SumofMagn
    Simuh.Img = Img(:,:,:,1); % show first echo
    Simuh.IV=struct(...
        'Slice',ceil(VCtl.SliceNum/2),...
        'C_lower',min(min(min(Simuh.Img))),...
        'C_upper',max(max(max(Simuh.Img))),...
        'Axes','off',...
        'Grid','off',...
        'Color_map','Gray'...
        );
    DoUpdateImage(Simuh.Preview_axes,Simuh.Img,Simuh.IV);
    set(Simuh.Preview_uipanel,'Title',['Preview : Series' num2str(Simuh.ScanSeriesInd)]);
    [row,col,layer]=size(Simuh.Img);
    if layer==1
        set(Simuh.Preview_slider,'Enable','off');
    else
        set(Simuh.Preview_slider,'Enable','on');
        set(Simuh.Preview_slider,'Min',1,'Max',layer,'SliderStep',[1/layer, 4/layer],'Value',ceil(layer/2));
    end
    guidata(Simuh.SimuPanel_figure, Simuh);
    
    % Saving output
    DoUpdateInfo(Simuh,'Saving recon images & data & info...');
    DoSaveOutput(Simuh);
    DoUpdateInfo(Simuh,'Image data saving is complete!');
    
else
    % Saving output
    TmpVImg = VImg;
    VImg = []; % clear VImg
    DoUpdateInfo(Simuh,'Saving signal data & info...');
    DoSaveOutput(Simuh);
    DoUpdateInfo(Simuh,'Signal data saving is complete!');
    VImg = TmpVImg;
    
end

end