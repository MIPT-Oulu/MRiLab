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

function DoFSERecon(Simuh)

global VSig;
global VCtl;
global VObj;
global VCoi;
global VImg;


SX=reshape(VSig.Sx,VCtl.ResFreq * VCtl.FSE_ETL,VCtl.FSE_ShotNum,VCtl.SliceNum,VCoi.RxCoilNum,VObj.TypeNum); % matlab col priority
SY=reshape(VSig.Sy,VCtl.ResFreq * VCtl.FSE_ETL,VCtl.FSE_ShotNum,VCtl.SliceNum,VCoi.RxCoilNum,VObj.TypeNum);

SX=sum(SX, 5); % sum signal from all spin types
SY=sum(SY, 5);
%% FSE k-space recon
% sort k-space & row flipping
Sx=zeros(VCtl.ResFreq,VCtl.FSE_ETL*VCtl.FSE_ShotNum,VCtl.SliceNum,VCoi.RxCoilNum);
Sy=zeros(VCtl.ResFreq,VCtl.FSE_ETL*VCtl.FSE_ShotNum,VCtl.SliceNum,VCoi.RxCoilNum);
for e = 1: VCtl.FSE_ETL
    Sx(:,(e-1)*VCtl.FSE_ShotNum+1: e*VCtl.FSE_ShotNum, :,:) = reshape(SX((e-1)*VCtl.ResFreq+1: e*VCtl.ResFreq, :,:,:), [VCtl.ResFreq ,VCtl.FSE_ShotNum ,VCtl.SliceNum,VCoi.RxCoilNum]);
    Sy(:,(e-1)*VCtl.FSE_ShotNum+1: e*VCtl.FSE_ShotNum, :,:) = reshape(SY((e-1)*VCtl.ResFreq+1: e*VCtl.ResFreq, :,:,:), [VCtl.ResFreq ,VCtl.FSE_ShotNum ,VCtl.SliceNum,VCoi.RxCoilNum]);
end

% default -KxMax -> KxMax, -KyMax -> KyMax
% remove the most positive Kx point for making even number of Kx sample points (used for Matlab default fft)
Sx(end,:,:,:)=[];
Sy(end,:,:,:)=[];
ResFreq = VCtl.ResFreq - 1;

if isfield(VCtl,'ZF_Kx') % Zero Filling of k-space for increasing matrix size, no increae of resolution
    Sx2=zeros(str2double(VCtl.ZF_Kx),str2double(VCtl.ZF_Ky),str2double(VCtl.ZF_Kz(2:end))*VCtl.SliceNum,VCoi.RxCoilNum);
    Sy2=zeros(str2double(VCtl.ZF_Kx),str2double(VCtl.ZF_Ky),str2double(VCtl.ZF_Kz(2:end))*VCtl.SliceNum,VCoi.RxCoilNum);
    for i = 1:VCoi.RxCoilNum
        Sx2(str2double(VCtl.ZF_Kx)/2-ResFreq/2+1:str2double(VCtl.ZF_Kx)/2-ResFreq/2+1+ResFreq-1, ...
            str2double(VCtl.ZF_Ky)/2-(VCtl.FSE_ETL*VCtl.FSE_ShotNum)/2+1:str2double(VCtl.ZF_Ky)/2-(VCtl.FSE_ETL*VCtl.FSE_ShotNum)/2+1+(VCtl.FSE_ETL*VCtl.FSE_ShotNum)-1, ...
            str2double(VCtl.ZF_Kz(2:end))*floor(VCtl.SliceNum/2)-floor(VCtl.SliceNum/2)+1:str2double(VCtl.ZF_Kz(2:end))*floor(VCtl.SliceNum/2)-floor(VCtl.SliceNum/2)+1+VCtl.SliceNum-1,i)=Sx(:,:,:,i);
        Sy2(str2double(VCtl.ZF_Kx)/2-ResFreq/2+1:str2double(VCtl.ZF_Kx)/2-ResFreq/2+1+ResFreq-1, ...
            str2double(VCtl.ZF_Ky)/2-(VCtl.FSE_ETL*VCtl.FSE_ShotNum)/2+1:str2double(VCtl.ZF_Ky)/2-(VCtl.FSE_ETL*VCtl.FSE_ShotNum)/2+1+(VCtl.FSE_ETL*VCtl.FSE_ShotNum)-1, ...
            str2double(VCtl.ZF_Kz(2:end))*floor(VCtl.SliceNum/2)-floor(VCtl.SliceNum/2)+1:str2double(VCtl.ZF_Kz(2:end))*floor(VCtl.SliceNum/2)-floor(VCtl.SliceNum/2)+1+VCtl.SliceNum-1,i)=Sy(:,:,:,i);
    end
    Sx=Sx2;
    Sy=Sy2;
    clear Sx2 Sy2;
end
Sx=permute(Sx,[2 1 3 4]);
Sy=permute(Sy,[2 1 3 4]);

% match XYZ orientation
SP=get(Simuh.Attrh1.ScanPlane,'String');
FD=get(Simuh.Attrh1.FreqDir,'String');
switch SP{get(Simuh.Attrh1.ScanPlane,'Value')}
    case 'Axial'
        if strcmp(FD{get(Simuh.Attrh1.FreqDir,'Value')},'S/I')
            set(Simuh.Attrh1.FreqDir,'Value',1);
        end
        if  strcmp(FD{get(Simuh.Attrh1.FreqDir,'Value')},'A/P')
            Sx=permute(Sx,[2 1 3 4]);
            Sy=permute(Sy,[2 1 3 4]);
        else
            Sx=permute(Sx,[1 2 3 4]);
            Sy=permute(Sy,[1 2 3 4]);
        end
    case 'Sagittal'
        if strcmp(FD{get(Simuh.Attrh1.FreqDir,'Value')},'L/R')
            set(Simuh.Attrh1.FreqDir,'Value',3);
        end
        if  strcmp(FD{get(Simuh.Attrh1.FreqDir,'Value')},'S/I')
            Sx=permute(Sx,[2 1 3 4]);
            Sy=permute(Sy,[2 1 3 4]);
        else
            Sx=permute(Sx,[1 2 3 4]);
            Sy=permute(Sy,[1 2 3 4]);
        end
    case 'Coronal'
        if strcmp(FD{get(Simuh.Attrh1.FreqDir,'Value')},'A/P')
            set(Simuh.Attrh1.FreqDir,'Value',2);
        end
        if  strcmp(FD{get(Simuh.Attrh1.FreqDir,'Value')},'L/R')
            Sx=permute(Sx,[1 2 3 4]);
            Sy=permute(Sy,[1 2 3 4]);
        else
            Sx=permute(Sx,[2 1 3 4]);
            Sy=permute(Sy,[2 1 3 4]);
        end
end

S=Sx+1i*Sy;
for i = 1: VCoi.RxCoilNum
    VImg.Real(:,:,:,i)=real(fftshift(ifftn(fftshift(S(:,:,:,i)))));
    VImg.Imag(:,:,:,i)=imag(fftshift(ifftn(fftshift(S(:,:,:,i)))));
    VImg.Mag(:,:,:,i)=abs(VImg.Real(:,:,:,i)+1i*VImg.Imag(:,:,:,i));
    VImg.Phase(:,:,:,i)=angle(VImg.Real(:,:,:,i)+1i*VImg.Imag(:,:,:,i));
end
VImg.Sx(:,:,:,:)=Sx;
VImg.Sy(:,:,:,:)=Sy;

guidata(Simuh.SimuPanel_figure, Simuh);


end