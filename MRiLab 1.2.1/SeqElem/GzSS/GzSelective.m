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

function [GAmp,GTime]=GzSelective(p)

global VCtl;

t2Start=p.t2Start;
t2End=p.t2End;
tRamp=p.tRamp;
Gz1Sign=p.Gz1Sign;
Gz2Sign=p.Gz2Sign;
Gz3Sign=p.Gz3Sign;
GzAmp=p.GzAmp;
Duplicates=max(1,p.Duplicates);
DupSpacing=max(0,p.DupSpacing);

% prephasing
[GAmp1,GTime1]=StdTrap(0,         ...
                       (t2End-t2Start)/2+2*tRamp,       ...
                       tRamp,                       ...
                       (t2End-t2Start)/2+tRamp,                     ...
                       Gz1Sign*GzAmp,2,2,2);

% slice selection
[GAmp2,GTime2]=StdTrap(t2Start-tRamp,    ...
                       t2End+tRamp,      ...
                       t2Start,   ...
                       t2End,     ...
                       Gz2Sign*GzAmp,2,2,2);
% phase rewinding
[GAmp3,GTime3]=StdTrap(0,         ...
                       (t2End-t2Start)/2+2*tRamp,       ...
                       tRamp,                       ...
                       (t2End-t2Start)/2+tRamp,                     ...
                       Gz3Sign*GzAmp,2,2,2);
                   
GAmp=GAmp2;
GTime=GTime2;

if Gz1Sign~=0
    GAmp=[GAmp1, GAmp];
    GTime=[t2Start-tRamp-GTime1(end)+GTime1, GTime];
end

if Gz3Sign~=0
    GAmp=[GAmp, GAmp3];
    GTime=[GTime, t2End+tRamp+GTime3];
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
