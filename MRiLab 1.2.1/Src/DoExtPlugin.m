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

function DoExtPlugin

% entry function for extended plugin based on Ext flag
global VVar
global VObj
global VMag
global VCoi
global VCtl

switch VVar.Ext
%% System Reserved Ext Flags (Positive)   
    case 0  % normal status
        % do nothing
    case 1 % reset K space location
        Plugin_ResetK;
    case 2 % reverse K space location
        Plugin_ReverseK;
    case 3 % lock K space location
        Plugin_LockK;
    case 4 % release K space location
        Plugin_ReleaseK;
    case 5 % calculate remaining scan time
        Plugin_Timer;
    case 6 % ideal spoiler, dephase Mxy
        Plugin_IdealSpoiler;
    case 7 % rfRef, demodulate signal phase referring to rf phase at ADC
        Plugin_rfRef;
    case 8 % trigger object motion
        Plugin_ExecuteMotion;
    case 9 % real time image recon
        Plugin_RTRecon;
%% User Defined Ext Flags (Negative)
% add user defined Ext flags here using case
% e.g.    case -5











end

%% Convert double to float
VObj.Mz=single(VObj.Mz);
VObj.My=single(VObj.My);
VObj.Mx=single(VObj.Mx);
VObj.Rho=single(VObj.Rho);
VObj.T1=single(VObj.T1);
VObj.T2=single(VObj.T2);
if isfield(VCtl, 'MT_Flag')
    if strcmp(VCtl.MT_Flag, 'on')
        VObj.K=single(VObj.K);
    end
end
if isfield(VCtl, 'ME_Flag')
    if strcmp(VCtl.ME_Flag, 'on')
        VObj.K=single(VObj.K);
    end
end
VMag.dB0=single(VMag.dB0);
VMag.dWRnd=single(VMag.dWRnd);
VMag.Gzgrid=single(VMag.Gzgrid);
VMag.Gygrid=single(VMag.Gygrid);
VMag.Gxgrid=single(VMag.Gxgrid);
VCoi.TxCoilmg=single(VCoi.TxCoilmg);
VCoi.TxCoilpe=single(VCoi.TxCoilpe);
VCoi.RxCoilx=single(VCoi.RxCoilx);
VCoi.RxCoily=single(VCoi.RxCoily);


end