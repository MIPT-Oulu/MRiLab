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

function DoToHDF5(Simuh)

% convert MRiLab output to HDF5 file which works with Gadgetron
global VCtl
global VSig
global VCoi
global VObj

vctl.protocolName               = VCtl.SeriesName;
vctl.systemVendor               = 'MRiLab';
vctl.systemModel                = '2013a';
vctl.systemFieldStrength_T      = single(VCtl.B0);
vctl.receiverChannels           = uint16(VCoi.RxCoilNum);
vctl.institutionName            = 'WIMR';
vctl.stationName                = 'L1122-E';
vctl.H1resonanceFrequency_Hz    = uint32(VCtl.B0 * VObj.Gyro/(2*pi));
vctl.ESMatrixSizeX              = uint16(VCtl.ResFreq);
vctl.ESMatrixSizeY              = uint16(VCtl.ResPhase);
vctl.ESMatrixSizeZ              = uint16(VCtl.SliceNum);
vctl.ESFOVX                     = single(VCtl.FOVFreq  * 1000);
vctl.ESFOVY                     = single(VCtl.FOVPhase * 1000);
vctl.ESFOVZ                     = single(VCtl.FOVSlice * 1000);
vctl.RSMatrixSizeX              = uint16(VCtl.ResFreq);
vctl.RSMatrixSizeY              = uint16(VCtl.ResPhase);
vctl.RSMatrixSizeZ              = uint16(VCtl.SliceNum);
vctl.RSFOVX                     = single(VCtl.FOVFreq  * 1000);
vctl.RSFOVY                     = single(VCtl.FOVPhase * 1000);
vctl.RSFOVZ                     = single(VCtl.FOVSlice * 1000);
vctl.trajectory                 = VCtl.TrajType;
vctl.TR                         = single(VCtl.TR);
vctl.TE                         = single(VCtl.TE);
vctl.BW                         = single(VCtl.BandWidth);
vctl.outputFile                 = [Simuh.OutputDir Simuh.Sep 'Series' num2str(Simuh.ScanSeriesInd) '.h5'];

Sx=single(sum(reshape(VSig.Sx, length(VSig.Sx)/VObj.TypeNum, VObj.TypeNum),2));
Sy=single(sum(reshape(VSig.Sy, length(VSig.Sy)/VObj.TypeNum, VObj.TypeNum),2));
Kx=single(VSig.Kx);
Ky=single(VSig.Ky);
Kz=single(VSig.Kz);
vsig.S                          = [Sx'; Sy'];
vsig.K                          = [Kx; Ky; Kz];
vsig.echoNumber                 = uint32(VCtl.TEPerTR);
vsig.firstPhaseNumber           = uint32(VCtl.FirstPhNum);
vsig.secondPhaseNumber          = uint32(VCtl.SecondPhNum);
vsig.readoutNumber              = uint32(length(VSig.Sx)/(VCtl.TEPerTR*VCtl.FirstPhNum*VCtl.SecondPhNum*VCoi.RxCoilNum*VObj.TypeNum));

% convert MRiLab output to HDF5 file
DoMatToHDF5(vsig,vctl);


end