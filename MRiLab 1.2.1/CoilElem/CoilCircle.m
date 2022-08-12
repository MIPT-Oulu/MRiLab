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

function [B1x,B1y,B1z,Pos]=CoilCircle(p)
%create B1 field produced by Biot-Savart loop

global VCco

% Initialize parameters
CoilID=p.CoilID;
PosX=p.PosX;
PosY=p.PosY;
PosZ=p.PosZ;
Azimuth=p.Azimuth;
Elevation=p.Elevation;
Radius=p.Radius;
Segment=p.Segment;
Scale=p.Scale;
CurrentDir=p.CurrentDir;

% Divide segment
if CurrentDir==1 % clock-wise
    theta=linspace(0,2*pi,Segment+1);
elseif CurrentDir==-1 % counterclock-wise
    theta=linspace(0,-2*pi,Segment+1);
end

N=[cos(Elevation)*cos(Azimuth) cos(Elevation)*sin(Azimuth) sin(Elevation)];
N=N/norm(N);
v=null(N);
ang=atan2(dot(cross(v(:,1),v(:,2)),N),dot(cross(v(:,1),N),cross(v(:,2),N))); % determine angle direction
v(:,1)=(ang/abs(ang))*v(:,1); % match angle direction
points=repmat([PosX PosY PosZ]',1,size(theta,2))+Radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

% Save loops
VCco.loops(:,:,CoilID)=points;

% Calculate B1 field
pause(0.01);
[B1x,B1y,B1z]=CoilBiotSavart(points);
Pos=[PosX, PosY, PosZ];

% Compute scaled vectors of magnetic field direction
B1x = B1x*Scale;
B1y = B1y*Scale;
B1z = B1z*Scale;
   
end