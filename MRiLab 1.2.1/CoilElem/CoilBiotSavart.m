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

function [B1x,B1y,B1z]=CoilBiotSavart(points)
%create B1 field produced by Biot-Savart rule

global VMco

x=points(1,:);
y=points(2,:);
z=points(3,:);

% Initialize display grid
xgrid=VMco.xgrid;
ygrid=VMco.ygrid;
zgrid=VMco.zgrid;

% Initialize constant
mu0 = 4*pi*1e-7;       % Permeability of free space (T*m/A)
I_current = 1;       % Current in the loop (A)
Constant = mu0/(4*pi) * I_current;   % Useful constant

% Initialize B to zero
B1x = zeros(size(xgrid));
B1y = zeros(size(xgrid));
B1z = zeros(size(xgrid));

for i=1:length(x)-1
    
    % Compute components of segment vector dl
    dlx = x(i+1)-x(i);
    dly = y(i+1)-y(i);
    dlz = z(i+1)-z(i);
    
    % Compute the location of the midpoint of a segment
    xc = (x(i+1)+x(i))/2;
    yc = (y(i+1)+y(i))/2;
    zc = (z(i+1)+z(i))/2;
    
    %% segment on loop and observation point)
    rx = xgrid - xc;
    ry = ygrid - yc;
    rz = zgrid - zc;
    
    % Compute r^3 from r vector
    r3 = sqrt(rx.^2 + ry.^2 + rz.^2).^3;
    
    % Compute cross product dl X r
    dlXr_x = dly.*rz - dlz.*ry;
    dlXr_y = dlz.*rx - dlx.*rz;
    dlXr_z = dlx.*ry - dly.*rx;
    
    % Increment sum of magnetic field
    B1x = B1x + Constant.*dlXr_x./r3;
    B1y = B1y + Constant.*dlXr_y./r3;
    B1z = B1z + Constant.*dlXr_z./r3;
    
    
end

end