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

function ExecFlag=DoUpdRateChk

global VSeq
global VCtl


ExecFlag = 1;
URTolerance = -abs(VCtl.MinUpdRate * 0.01);
% check update rate
% check rf
TxCoilID=unique(VSeq.rfCoilLine);
for i = 1: length(TxCoilID)
    Flags = VSeq.flagsLine(1,:);
    t = VSeq.tsLine(Flags~=0);
    t = t(VSeq.rfCoilLine == TxCoilID(i));
    dt =  diff(t);
    dt (dt < 0.5*eps) =[]; % avoid unique function rounding threshold (0.5*eps)
    if ~isempty(find((abs(dt)-VCtl.MinUpdRate)<URTolerance, 1))
        errordlg(['rf' num2str(TxCoilID(i)) ' sequence line exceeds minimum update rate!']);
        ExecFlag = 0;
    end
end

% check Gz
Flags = VSeq.flagsLine(2,:);
t = VSeq.tsLine(Flags~=0);
dt =  diff(t);
dt (dt < 0.5*eps) =[];
if ~isempty(find((abs(dt)-VCtl.MinUpdRate)<URTolerance, 1))
    errordlg('GzSS sequence line exceeds minimum update rate!');
    ExecFlag = 0;
end

% check Gy
Flags = VSeq.flagsLine(3,:);
t = VSeq.tsLine(Flags~=0);
dt =  diff(t);
dt (dt < 0.5*eps) =[];
if ~isempty(find((abs(dt)-VCtl.MinUpdRate)<URTolerance, 1))
    errordlg('GyP sequence line exceeds minimum update rate!');
    ExecFlag = 0;
end

% check Gx
Flags = VSeq.flagsLine(4,:);
t = VSeq.tsLine(Flags~=0);
dt =  diff(t);
dt (dt < 0.5*eps) =[];
if ~isempty(find((abs(dt)-VCtl.MinUpdRate)<URTolerance, 1))
    errordlg('GxR sequence line exceeds minimum update rate!');
    ExecFlag = 0;
end

end