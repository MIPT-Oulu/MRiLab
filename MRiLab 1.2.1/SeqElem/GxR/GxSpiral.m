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
%   University of Wisconsin–Madison
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

function [GAmp,GTime]=GxSpiral(p)

global VCtl;
global VObj;
global VVar;

tStart=p.tStart;
dt = p.dt;

% 2D spiral encoding
FOV = VCtl.FOVFreq; % choose FOVFreq as FOV
Res = VCtl.ResFreq; % choose ResFreq as effective resolution

KMax  = Res/ (2*FOV);
ThetaMax = KMax / VCtl.S_Lamda;
Beta = (VObj.Gyro/(2*pi))*(VCtl.S_SlewRate / VCtl.S_Lamda);
a2 = (9*Beta/4)^(1/3);
CLamda = VCtl.S_SlewRate/VCtl.S_SlewRate0;
Ts = ((3*VObj.Gyro*VCtl.S_Gradient)/(4*pi*VCtl.S_Lamda*a2^2))^3;

ThetaTs = (0.5 * Beta * Ts^2)/(CLamda + (Beta/(2 * a2)) * Ts^(4/3));
if ThetaTs < ThetaMax
    t1 = 0:dt:Ts;
    Theta1 = (0.5 * Beta * t1.^2)./(CLamda + (Beta/(2 * a2)) * t1.^(4/3));
    
    Tacq = t1(end) + ((pi*VCtl.S_Lamda)/(VObj.Gyro * VCtl.S_Gradient))*(ThetaMax^2 - Theta1(end)^2);
    t2 = t1(end):dt:Tacq;
    Theta2 = sqrt(Theta1(end)^2 + (VObj.Gyro / (pi * VCtl.S_Lamda))*VCtl.S_Gradient*(t2 - t1(end)));
    
    Theta = [Theta1(1:end-1) Theta2];
    t     = [t1(1:end-1)     t2];
    
else
    Tacq = ((2*pi*FOV)/(3*VCtl.S_ShotNum))*sqrt(pi/(VObj.Gyro*VCtl.S_SlewRate*VCtl.RFreq^3));
    t1 = 0:dt:Tacq;
    Theta1 = (0.5 * Beta * t1.^2)./(CLamda + (Beta/(2 * a2)) * t1.^(4/3));
    
    Theta = Theta1;
    t     = t1;
end

DTheta = [0 diff(Theta)./diff(t)];

GAmp = ((2*pi)/(VObj.Gyro))*VCtl.S_Lamda*DTheta.*(cos(Theta + (VVar.PhaseCount-1)*(2*pi/VCtl.S_ShotNum)) ...
                                         - Theta.*sin(Theta + (VVar.PhaseCount-1)*(2*pi/VCtl.S_ShotNum)));
GTime = tStart + VCtl.TEAnchorTime + t;

GTime = [GTime GTime(end) + max(VCtl.MinUpdRate,abs(GAmp(end)/VCtl.S_SlewRate))];
GAmp = [GAmp 0];
                   
[GTime,m,n]=unique(GTime);
GAmp=GAmp(m);


end
