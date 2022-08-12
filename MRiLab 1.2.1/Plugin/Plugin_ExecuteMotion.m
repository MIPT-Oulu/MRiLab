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

function Plugin_ExecuteMotion

global VObj
global VMot
global VVar
global VMag
global VCtl
% global Traj

%% Locate motion track, do nothing if no motion track
if length(VMot.t) == 1
    return;
end

time = double(VVar.t)+ (double(VVar.TRCount)-1) * VCtl.TR;
mot_t= double(VMot.t);
[C,I] = min(abs(mot_t-time)); % find time point in the motion track

%% Execute translation for object
if ~isempty(VMot.Disp)
    if VVar.ObjMotInd == VMot.ind(I)
        ObjTraj = VVar.ObjLoc - VVar.ObjTurnLoc;
        Displacement  = VMot.Disp(:,I) - ObjTraj;
    else
        Displacement  = VMot.Disp(:,I);
        VVar.ObjTurnLoc = VVar.ObjLoc ;
    end
    VVar.ObjLoc = VVar.ObjLoc + Displacement;
    step= round(Displacement./[VObj.XDimRes; VObj.YDimRes; VObj.ZDimRes]);
    
    if sum(step~=0)
        
        VObj.Mz=circshift(VObj.Mz,[step(2), step(1), step(3)]);
        VObj.My=circshift(VObj.My,[step(2), step(1), step(3)]);
        VObj.Mx=circshift(VObj.Mx,[step(2), step(1), step(3)]);
        VObj.Rho=circshift(VObj.Rho,[step(2), step(1), step(3)]);
        VObj.T1=circshift(VObj.T1,[step(2), step(1), step(3)]);
        VObj.T2=circshift(VObj.T2,[step(2), step(1), step(3)]);
        VMag.dWRnd=circshift(VMag.dWRnd,[step(2), step(1), step(3)]);
        
%         disp(['Phantom Motion: [ ' num2str(step') ' ]']);
        %             if isempty(Traj)
        %                 Traj=step';
        %             else
        %                 Traj(end+1,:)=step';
        %             end
        %
%                 figure; imagesc(VObj.Rho(:,:,1));
%         VVar.ObjLoc
    end
    
end

%% Execute rotation for object
if ~isempty(VMot.Ang)
    RotationAngle = VMot.Ang(1,I)-VVar.ObjAng;
    VVar.ObjAng = VMot.Ang(1,I);
    
    if RotationAngle~=0
        axis = VMot.Axis(:,I);
        [T, R]=rotate3DT(axis, RotationAngle);
        
        VObj.Mz =rotate3D(VObj.Mz, T, R);
        VObj.My =rotate3D(VObj.My, T, R);
        VObj.Mx =rotate3D(VObj.Mx, T, R);
        VObj.Rho =rotate3D(VObj.Rho, T, R);
        VObj.T1 =rotate3D(VObj.T1, T, R);
        VObj.T2 =rotate3D(VObj.T2, T, R);
        VMag.dWRnd =rotate3D(VMag.dWRnd, T, R);
        
        VObj.Mz(VObj.Mz < 0) = 0;
        VObj.My(VObj.My < 0) = 0;
        VObj.Mx(VObj.Mx < 0) = 0;
        VObj.Rho(VObj.Rho < 0) = 0;
        VObj.T1(VObj.T1 < 0) = 0;
        VObj.T2(VObj.T2 < 0) = 0;
        VMag.dWRnd(VMag.dWRnd < 0) = 0;

        VObj.Mz(VObj.Mz > VObj.MaxMz) = VObj.MaxMz;
        VObj.My(VObj.My > VObj.MaxMy) = VObj.MaxMy;
        VObj.Mx(VObj.Mx > VObj.MaxMx) = VObj.MaxMx;
        VObj.Rho(VObj.Rho > VObj.MaxRho) = VObj.MaxRho;
        VObj.T1(VObj.T1 > VObj.MaxT1) = VObj.MaxT1;
        VObj.T2(VObj.T2 > VObj.MaxT2) = VObj.MaxT2;
        VMag.dWRnd(VMag.dWRnd > VObj.MaxdWRnd) = VObj.MaxdWRnd;
        
        
%         VVar.ObjLoc
%                 figure; imagesc(VObj.Rho(:,:,1));
    end
    
end

VVar.ObjMotInd = VMot.ind(I);

end