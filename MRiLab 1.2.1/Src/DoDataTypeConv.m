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

function DoDataTypeConv(Simuh)
% Keep in mind when double data is converted to double, data precision is reduced,
% sometimes may cause wired rounding error, especially may happen in pulse
% generation section where two different entry time points mistakenly merge to one.
% To maintain better calculation accuracy, need to convert data to double
% type explicitly using double().

global VObj;
global VMag;
global VCoi;
global VMot;
global VCtl;
global VVar;
global VSig;
global VSeq;


% Signal Initialization
SignalNum=numel(find(VSeq.ADCLine==1));
VSig.Sx=double(zeros(1,SignalNum*VObj.TypeNum*VCoi.RxCoilNum));
VSig.Sy=double(zeros(1,SignalNum*VObj.TypeNum*VCoi.RxCoilNum));
VSig.Kz=double(zeros(1,SignalNum));
VSig.Ky=double(zeros(1,SignalNum));
VSig.Kx=double(zeros(1,SignalNum));
VSig.Mz=single(VSig.Mz);
VSig.My=single(VSig.My);
VSig.Mx=single(VSig.Mx);
VSig.Muts=double(VSig.Muts);
VSig.SignalNum=int32(SignalNum);

%% Data Type Conversion
VObj.Gyro=double(VObj.Gyro);
VObj.ChemShift=double(VObj.ChemShift);
VObj.Mz=single(VObj.Mz);
VObj.My=single(VObj.My);
VObj.Mx=single(VObj.Mx);
VObj.Rho=single(VObj.Rho);
VObj.T1=single(VObj.T1);
VObj.T2=single(VObj.T2);

if isfield(VCtl, 'MT_Flag')
    if strcmp(VCtl.MT_Flag, 'on')
        VObj.K=single(VObj.K);
    end
end

if isfield(VCtl, 'ME_Flag')
    if strcmp(VCtl.ME_Flag, 'on')
        VObj.K=single(VObj.K);
    end
end

VObj.SpinNum=int32(VObj.SpinNum);
VObj.TypeNum=int32(VObj.TypeNum);

VMag.FRange=double(VMag.FRange);
VMag.dB0=single(VMag.dB0);
VMag.dWRnd=single(VMag.dWRnd);
VMag.Gzgrid=single(VMag.Gzgrid);
VMag.Gygrid=single(VMag.Gygrid);
VMag.Gxgrid=single(VMag.Gxgrid);


VCoi.TxCoilmg=single(VCoi.TxCoilmg);
VCoi.TxCoilpe=single(VCoi.TxCoilpe);
VCoi.RxCoilx=single(VCoi.RxCoilx);
VCoi.RxCoily=single(VCoi.RxCoily);
VCoi.TxCoilNum=int32(VCoi.TxCoilNum);
VCoi.RxCoilNum=int32(VCoi.RxCoilNum);
VCoi.TxCoilDefault=double(VCoi.TxCoilDefault);
VCoi.RxCoilDefault=double(VCoi.RxCoilDefault);

VMot.t=double(VMot.t);
VMot.ind=double(VMot.ind);
VMot.Disp=double(VMot.Disp);
VMot.Axis=double(VMot.Axis);
VMot.Ang=double(VMot.Ang);

VCtl.CS=double(VCtl.CS);
VCtl.TRNum=int32(VCtl.TRNum);
VCtl.RunMode=int32(VCtl.RunMode);

VVar.t=double(VVar.t);
VVar.dt=double(VVar.dt);
VVar.rfAmp=double(VVar.rfAmp);
VVar.rfPhase=double(VVar.rfPhase);
VVar.rfFreq=double(VVar.rfFreq);
VVar.rfCoil=double(VVar.rfCoil);
VVar.rfRef=double(VVar.rfRef);
VVar.GzAmp=double(VVar.GzAmp);
VVar.GyAmp=double(VVar.GyAmp);
VVar.GxAmp=double(VVar.GxAmp);
VVar.ADC=double(VVar.ADC);
VVar.Ext=double(VVar.Ext);
VVar.Kz=double(VVar.Kz);
VVar.Ky=double(VVar.Ky);
VVar.Kx=double(VVar.Kx);
VVar.ObjLoc=double(VVar.ObjLoc);
VVar.ObjTurnLoc=double(VVar.ObjTurnLoc);
VVar.ObjMotInd=double(VVar.ObjMotInd);
VVar.ObjAng=double(VVar.ObjAng);
VVar.gpuFetch=double(VVar.gpuFetch);
VVar.utsi=int32(VVar.utsi);
VVar.rfi=int32(VVar.rfi);
VVar.Gzi=int32(VVar.Gzi);
VVar.Gyi=int32(VVar.Gyi);
VVar.Gxi=int32(VVar.Gxi);
VVar.ADCi=int32(VVar.ADCi);
VVar.Exti=int32(VVar.Exti);
VVar.SliceCount=int32(1);
VVar.PhaseCount=int32(1);
VVar.TRCount=int32(1);

VSeq.utsLine=double(VSeq.utsLine);
VSeq.tsLine=double(VSeq.tsLine);
VSeq.rfAmpLine=double(VSeq.rfAmpLine);
VSeq.rfPhaseLine=double(VSeq.rfPhaseLine);
VSeq.rfFreqLine=double(VSeq.rfFreqLine);
VSeq.rfCoilLine=double(VSeq.rfCoilLine);
VSeq.GzAmpLine=double(VSeq.GzAmpLine);
VSeq.GyAmpLine=double(VSeq.GyAmpLine);
VSeq.GxAmpLine=double(VSeq.GxAmpLine);
VSeq.ADCLine=double(VSeq.ADCLine);
VSeq.ExtLine=double(VSeq.ExtLine);
VSeq.flagsLine=double(VSeq.flagsLine);

end