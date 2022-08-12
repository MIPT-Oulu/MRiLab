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

function DoTrajK(handles)

global VObj;
global VMag;
global VCtl;
global VSig;
global VCoi;

%preserve VObj VMag & VCoi
VTmpObj=VObj;
VTmpMag=VMag;
VTmpCoi=VCoi;

handles.Simuh=guidata(handles.Simuh.SimuPanel_figure);
DoDisableButton([],[],handles.Simuh);
%% Do K-Space Traj
try
    % Read tab parameters
    fieldname=fieldnames(handles.Attrh2);
    for i=1:length(fieldname)/2
        try
            eval(['TK.' fieldname{i*2} '=[' get(handles.Attrh2.(fieldname{i*2}),'String') '];']);
        catch me
            TAttr=get(handles.Attrh2.(fieldname{i*2}),'String');
            eval(['TK.' fieldname{i*2} '=''' TAttr{get(handles.Attrh2.(fieldname{i*2}),'Value')}  ''';']);
        end
    end
    
    % Prescan config
    DoPreScan(handles.Simuh);
    
    % Create SpinWatcher VOtk, VMtk & VCtk
    VOtk=VObj;
    VOtk.SpinNum=1;
    VOtk.TypeNum=1;
    VOtk.Rho=1;
    VOtk.T1=1;
    VOtk.T2=0.1;
    VOtk.T2Star=0.01;
    VOtk.XDim=1;
    VOtk.YDim=1;
    VOtk.ZDim=1;
    VOtk.Mx= 0;
    VOtk.My= 0;
    VOtk.Mz= 1;

    % Gradient Grid
    VMtk=VMag;
    VMtk.Gxgrid=0;
    VMtk.Gygrid=0;
    VMtk.Gzgrid=0;
    VMtk.dB0=0;
    VMtk.dWRnd=0;
    VMtk.FRange=1;

    % Coil
    VCtk=VCoi;
    VCtk.TxCoilmg=1;
    VCtk.TxCoilpe=0;
    VCtk.TxCoilNum=1;
    VCtk.RxCoilx=1;
    VCtk.RxCoily=0;
    VCtk.RxCoilNum=1;
    
    %% Spin execution
    VObj=VOtk;
    VMag=VMtk;
    VCoi=VCtk;
    
    % Generate Pulse line
    DoPulseGen(handles);
    
    % Simulation Process
    try
        VCtl.CS=double(VObj.ChemShift*VCtl.B0);
        VCtl.RunMode=int32(0); % Image scan
        VCtl.MaxThreadNum=int32(handles.Simuh.CPUInfo.NumThreads);
        DoDataTypeConv(handles.Simuh);
        DoScanAtCPU; % global (VSeq,VObj,VCtl,VMag,VCoi,VVar,VSig) are needed
    catch me
        error_msg{1,1}='ERROR!!! Scan process aborted.';
        error_msg{2,1}=me.message;
        errordlg(error_msg);
        %recover VObj
        VObj=VTmpObj;
        VMag=VTmpMag;
        VCoi=VTmpCoi;
        return;
    end
catch me
    error_msg{1,1}='ERROR!!! Spin execution process aborted.';
    error_msg{2,1}=me.message;
    errordlg(error_msg);
    %recover VObj
    VObj=VTmpObj;
    VMag=VTmpMag;
    VCoi=VTmpCoi;
    return;
end

Kx=VSig.Kx;
Ky=VSig.Ky;
Kz=VSig.Kz;

%recover VObj
VObj=VTmpObj;
VMag=VTmpMag;
VCoi=VTmpCoi;

pause(0.1);

switch TK.RenderMode
    case 'VTK'
        % VTK 3D rendering
        switch TK.RenderPoint
            case 'off'
                DoKSpaceTrajVTK([Kx(:)';Ky(:)';Kz(:)'],ones(size(Kx(:)'))*1,0);
            case 'on'
                DoKSpaceTrajVTK([Kx(:)';Ky(:)';Kz(:)'],ones(size(Kx(:)'))*1,1);
        end
    case 'Matlab'
        % Matlab 3D plot
        figure('Color','k');
        switch TK.RenderPoint
            case 'off'
                Ktraj=plot3(Kx(:),Ky(:),Kz(:),'w-');
                grid on;
            case 'on'
                Ktraj=quiver3(Kx(:),Ky(:),Kz(:),[diff(Kx(:));0],[diff(Ky(:));0],[diff(Kz(:));0],'w-');
                set(Ktraj,'AutoScale','off');
        end
        
                set(gca,'Color','k','xcolor','c','ycolor','c','zcolor','c');
        set(gca,'ydir','reverse');
        xlabel('Kx','Color','w');
        ylabel('Ky','Color','w');
        zlabel('Kz','Color','w');
        title('K-space Traj.','Color','w');
end

end