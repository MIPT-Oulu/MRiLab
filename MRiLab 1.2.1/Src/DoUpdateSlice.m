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

%update slice display in figures
function DoUpdateSlice(axes_handle,Matrix,V,Mode)

global VMco;
global VCco;
global VMmg;
global VMgd;

switch Mode
    case 'Coil'
        [az,el] = view(axes_handle);
        slice(axes_handle,VMco.xgrid,VMco.ygrid,VMco.zgrid,Matrix,V.xslice,V.yslice,V.zslice);
        xlabel('X axis');
        ylabel('Y axis');
        zlabel('Z axis');
        colormap(V.Colormap);
        Cbarh=colorbar;
        set(Cbarh,'YColor',[0 0 0],'XColor',[0 0 0]);
        set(axes_handle,'view',[az,el],'CLim',[V.C_lower V.C_upper]);
        hold(axes_handle,'on');
        scatter3(axes_handle,0,0,0,'filled','dr');
        
        if strcmp(V.CoilDisplay,'on')
            scatter3(axes_handle,V.Pos(:,1),V.Pos(:,2),V.Pos(:,3),'filled','k');
            text(V.Pos(:,1),V.Pos(:,2),V.Pos(:,3),num2cell(1:length(V.Pos(:,1))),'FontSize',18);
            if isfield(VCco,'loops')
                loops=permute(VCco.loops,[2 3 1]);
                plot3(loops(:,:,1),loops(:,:,2),loops(:,:,3),'k-','LineWidth',2);
            end
        end
        hold(axes_handle,'off');
        
        set(axes_handle,'XLim',[min(min(min(VMco.xgrid)))*1.5 max(max(max(VMco.xgrid)))*1.5]);
        set(axes_handle,'YLim',[min(min(min(VMco.ygrid)))*1.5 max(max(max(VMco.ygrid)))*1.5]);
        set(axes_handle,'ZLim',[min(min(min(VMco.zgrid)))*1.5 max(max(max(VMco.zgrid)))*1.5]);
        set(axes_handle,'YDir','reverse','ZDir','reverse');
        axis image;
        
    case 'Mag'
        
        [az,el] = view(axes_handle);
        slice(axes_handle,VMmg.xgrid,VMmg.ygrid,VMmg.zgrid,Matrix,V.xslice,V.yslice,V.zslice);
        xlabel('X axis');
        ylabel('Y axis');
        zlabel('Z axis');
        colormap(V.Colormap);
        Cbarh=colorbar;
        set(Cbarh,'YColor',[0 0 0],'XColor',[0 0 0]);
        set(axes_handle,'view',[az,el]);
        hold(axes_handle,'on');
        scatter3(axes_handle,0,0,0,'filled','dr');
        hold(axes_handle,'off');
        set(axes_handle,'XLim',[min(min(min(VMmg.xgrid)))*1 max(max(max(VMmg.xgrid)))*1]);
        set(axes_handle,'YLim',[min(min(min(VMmg.ygrid)))*1 max(max(max(VMmg.ygrid)))*1]);
        set(axes_handle,'ZLim',[min(min(min(VMmg.zgrid)))*1 max(max(max(VMmg.zgrid)))*1]);
        set(axes_handle,'YDir','reverse','ZDir','reverse');
        axis image;
        
     case 'Grad'
        
         [az,el] = view(axes_handle);

         switch V.DispMode
             case 'Both'
                 % display gradient
                 quiver3(axes_handle,VMgd.xgrid,VMgd.ygrid,VMgd.zgrid,Matrix(:,:,:,1),Matrix(:,:,:,2),Matrix(:,:,:,3));
                 hold(axes_handle,'on');
                 % display grid after transform
                 slice(axes_handle,VMgd.xgrid,VMgd.ygrid,VMgd.zgrid,Matrix(:,:,:,4),V.xslice,V.yslice,V.zslice);
                 colormap(V.Colormap);
                 Cbarh=colorbar;
                 set(Cbarh,'YColor',[0 0 0],'XColor',[0 0 0]);
                 
             case 'Gradient'
                 % display gradient
                 quiver3(axes_handle,VMgd.xgrid,VMgd.ygrid,VMgd.zgrid,Matrix(:,:,:,1),Matrix(:,:,:,2),Matrix(:,:,:,3));
                 hold(axes_handle,'on');
                 
             case 'Grid'
                 % display grid after transform
                 slice(axes_handle,VMgd.xgrid,VMgd.ygrid,VMgd.zgrid,Matrix(:,:,:,4),V.xslice,V.yslice,V.zslice);
                 hold(axes_handle,'on');
                 colormap(V.Colormap);
                 Cbarh=colorbar;
                 set(Cbarh,'YColor',[0 0 0],'XColor',[0 0 0]);
         end
         
         scatter3(axes_handle,0,0,0,'filled','dr');
         hold(axes_handle,'off');
         
         xlabel('X axis');
         ylabel('Y axis');
         zlabel('Z axis');
         set(axes_handle,'view',[az,el]);
         set(axes_handle,'XLim',[min(min(min(VMgd.xgrid)))*1 max(max(max(VMgd.xgrid)))*1]);
         set(axes_handle,'YLim',[min(min(min(VMgd.ygrid)))*1 max(max(max(VMgd.ygrid)))*1]);
         set(axes_handle,'ZLim',[min(min(min(VMgd.zgrid)))*1 max(max(max(VMgd.zgrid)))*1]);
         set(axes_handle,'YDir','reverse','ZDir','reverse');
         axis image;
        
end


end