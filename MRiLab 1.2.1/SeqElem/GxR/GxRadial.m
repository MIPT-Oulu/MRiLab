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

function [GAmp,GTime]=GxRadial(p)

global VCtl;
global VObj;
global VVar;

t1Start=p.t1Start;
t2Middle=p.t2Middle;
t3Start=p.t3Start;
tRamp=p.tRamp;
Gx1Sign=p.Gx1Sign;
Gx2Sign=p.Gx2Sign;
Gx3Sign=p.Gx3Sign;

% 2D radial encoding
FOV = VCtl.FOVFreq; % choose FOVFreq as real FOV
Res = VCtl.ResFreq; % choose ResFreq as real resolution

switch VCtl.R_AngPattern
    case 'Linear'
       eval(['R_AngRange=' VCtl.R_AngRange ';']);
       AngInc = R_AngRange / VCtl.R_SpokeNum;
    case 'Golden'
       AngInc = 111.246 * (pi/180); % Golden-angle sample
end

GxAmp=(1/FOV)/((VObj.Gyro/(2*pi))*(1/VCtl.BandWidth));
tHalf=1/(2*(VObj.Gyro/(2*pi))*GxAmp*(FOV/Res));
[GAmp1,GTime1]=StdTrap(t1Start-tRamp,          ...
                       t1Start+tHalf+tRamp,    ...
                       t1Start,                          ...
                       t1Start+tHalf,                    ...
                       GxAmp*cos(AngInc * (VVar.PhaseCount - 1))*Gx1Sign,2,2,2);
[GAmp2,GTime2]=StdTrap(t2Middle+VCtl.TEAnchorTime-tHalf-tRamp, ...
                       t2Middle+VCtl.TEAnchorTime+tHalf+tRamp, ...
                       t2Middle+VCtl.TEAnchorTime-tHalf,               ...
                       t2Middle+VCtl.TEAnchorTime+tHalf,               ...
                       GxAmp*cos(AngInc * (VVar.PhaseCount - 1))*Gx2Sign,2,2,2);
[GAmp3,GTime3]=StdTrap(t3Start-tRamp,            ...
                       t3Start+tHalf+tRamp,      ...
                       t3Start,                          ...
                       t3Start+tHalf,                    ...
                       GxAmp*cos(AngInc * (VVar.PhaseCount - 1))*Gx3Sign,2,2,2);
                   
GAmp=GAmp2;
GTime=GTime2;

if Gx1Sign~=0
    GAmp=[GAmp1, GAmp];
    GTime=[GTime1, GTime];
end

if Gx3Sign~=0
    GAmp=[GAmp, GAmp3];
    GTime=[GTime, GTime3];
end

[GTime,m,n]=unique(GTime);
GAmp=GAmp(m);


end
