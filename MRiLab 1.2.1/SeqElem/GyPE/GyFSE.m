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

function [GAmp,GTime]=GyFSE(p)

global VCtl;
global VVar;

tMiddle=p.tMiddle;
tGy1= p.tGy1;
tGy2= p.tGy2;
tOffset= p.tOffset;
Gy1Sign=p.Gy1Sign;
Gy2Sign=p.Gy2Sign;

% phase encoding
KyMax=(1/VCtl.RPhase)/2;
KydK=(2*KyMax)/VCtl.FSE_ETL;
p.Duplicates=1;
p.DupSpacing=0;

GAmp=[];
GTime=[];
TimeOffset = (tMiddle+VCtl.TEAnchorTime)-floor(VCtl.FSE_ETL/2)*VCtl.FSE_ESP;
for i = 1: VCtl.FSE_ETL
    % phase encoding
    p.tStart = TimeOffset + (i-1)*VCtl.FSE_ESP - tOffset;
    p.tEnd = p.tStart + tGy1;
    p.Area = (-(KyMax-(VVar.PhaseCount-1)*(KydK/VCtl.FSE_ShotNum)) + (i-1) * KydK) * Gy1Sign;
    [GAmpt,GTimet]=GyAreaTrapezoid(p); % unit m-1
    GAmp=[GAmp GAmpt];
    GTime=[GTime GTimet];
    
    % rephasing
    p.tStart = TimeOffset + (i-1)*VCtl.FSE_ESP + tOffset - tGy2;
    p.tEnd = p.tStart + tGy2;
    p.Area = (-(KyMax-(VVar.PhaseCount-1)*(KydK/VCtl.FSE_ShotNum)) + (i-1) * KydK) * Gy2Sign;
    [GAmpt,GTimet]=GyAreaTrapezoid(p);
    GAmp=[GAmp GAmpt];
    GTime=[GTime GTimet];
end

[GTime,m,n]=unique(GTime);
GAmp=GAmp(m);


end
