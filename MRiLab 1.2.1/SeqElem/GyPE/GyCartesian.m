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

function [GAmp,GTime]=GyCartesian(p)

global VCtl;
global VObj;
global VVar;

t1Start=p.t1Start;
t1End=p.t1End;
t2Start=p.t2Start;
t2End=p.t2End;
tRamp=p.tRamp;
Gy1Sign=p.Gy1Sign;
Gy2Sign=p.Gy2Sign;
% GyOrder=p.GyOrder;
Duplicates=max(1,p.Duplicates);
DupSpacing=max(0,p.DupSpacing);

% if strcmp(GyOrder,'centric')
%     if VVar.PhaseCount==1
%        VVar.PhaseCountTmp = 0;
%     end
%     PhaseCount = (-1)^rem(VVar.PhaseCount-1,2)*(VVar.PhaseCount-1) + VVar.PhaseCountTmp;
%     VVar.PhaseCountTmp    = PhaseCount;
% elseif strcmp(GyOrder,'sequential')
%     PhaseCount = VVar.PhaseCount-VCtl.ResPhase/2-1;
% end

% phase encoding
GydG=1/((VObj.Gyro/(2*pi))*(t1End-t1Start)*VCtl.FOVPhase);
[GAmp1,GTime1]=StdTrap(t1Start-tRamp,     ...
                       t1End+tRamp,       ...
                       t1Start,                   ...
                       t1End,                     ...
                       (VVar.PhaseCount-VCtl.ResPhase/2-1)*GydG*Gy1Sign,2,2,2);
% rephasing
GydG=1/((VObj.Gyro/(2*pi))*(t2End-t2Start)*VCtl.FOVPhase);
[GAmp2,GTime2]=StdTrap(t2Start-tRamp,     ...
                       t2End+tRamp,       ...
                       t2Start,                   ...
                       t2End,                     ...
                       (VVar.PhaseCount-VCtl.ResPhase/2-1)*GydG*Gy2Sign,2,2,2);

GAmp=GAmp1;
GTime=GTime1;

if Gy2Sign~=0
    GAmp=[GAmp, GAmp2];
    GTime=[GTime, GTime2];
end

[GTime,m,n]=unique(GTime);
GAmp=GAmp(m);

% Create Duplicates
if Duplicates~=1 & DupSpacing ~=0
    GAmp=repmat(GAmp,[1 Duplicates]);
    TimeOffset = repmat(0:DupSpacing:(Duplicates-1)*DupSpacing,[length(GTime) 1]);
    GTime=repmat(GTime,[1 Duplicates]) + (TimeOffset(:))';
end

end
