/*                                               _______
* _________________________________________     / _____ \      
*     .  .     |---- (OO)|       ___   |       | |     | |     
*    /\  /\    |__ |  || |      /   \  |___    |_|     |_|     
*   /  \/  \   |  \   || |      \___/  |   \   |S|     |N|     
*  /   ||   \  |   \_ || |____|     \  |___/  MRI Simulator    
* _________________________________________                  
* Numerical MRI Simulation Package
* Version 1.2  - https://sourceforge.net/projects/mrilab/
*
* The MRiLab is a numerical MRI simulation package. It has been developed to 
* simulate factors that affect MR signal formation, acquisition and image 
* reconstruction. The simulation package features highly interactive graphic 
* user interface for various simulation purposes. MRiLab provides several 
* toolboxes for MR researchers to analyze RF pulse, design MR sequence, 
* configure multiple transmitting and receiving coils, investigate B0 
* in-homogeneity and object motion sensitivity et.al. The main simulation 
* platform combined with these toolboxes can be applied for customizing 
* various virtual MR experiments which can serve as a prior stage for 
* prototyping and testing new MR technique and application.
*
* Author:
*   Fang Liu <leoliuf@gmail.com>
*   University of Wisconsin-Madison
*   April-6-2014
* _________________________________________________________________________
* Copyright (c) 2011-2014, Fang Liu <leoliuf@gmail.com>
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without 
* modification, are permitted provided that the following conditions are 
* met:
* 
*     * Redistributions of source code must retain the above copyright 
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright 
*       notice, this list of conditions and the following disclaimer in 
*       the documentation and/or other materials provided with the distribution
*       
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
* POSSIBILITY OF SUCH DAMAGE.
* _______________________________________________________________________*/


/*
 * DoMatToHDF5.cpp
 * Convert MRiLab data to ISMRMRD file format
 * Created on: June 19, 2013
 * Author: Fang Liu (leoliuf@gmail.com)
 */

#include <iostream>
#include "ismrmrd_hdf5.h"
#include "ismrmrd.hxx"
#include "mex.h"

/* Input Arguments */
#define vsig      prhs[0]
#define vctl      prhs[1]

/* MAIN APPLICATION */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* Pointers for VSig */
    float *S, *K;
    unsigned int *echoNumber, *firstPhaseNumber, *secondPhaseNumber, *readoutNumber;
    /* Pointers for VCtl */
    char *protocolName, *systemVendor, *systemModel, *institutionName, *stationName, *trajectory, *outputFile;
    unsigned short *receiverChannels, *ESMatrixSizeX, *ESMatrixSizeY, *ESMatrixSizeZ, *RSMatrixSizeX, *RSMatrixSizeY, *RSMatrixSizeZ;
    long *H1resonanceFrequency_Hz;
    float *ESFOVX, *ESFOVY, *ESFOVZ, *RSFOVX, *RSFOVY, *RSFOVZ, *TR, *TE, *BW, *systemFieldStrength_T;
    
    unsigned int ScanCounter;
            
    /* assign pointers */
    S                           = (float*) mxGetData(mxGetField(vsig, 0, "S"));
    K                           = (float*) mxGetData(mxGetField(vsig, 0, "K"));
    echoNumber                  = (unsigned int*) mxGetData(mxGetField(vsig, 0, "echoNumber"));
    firstPhaseNumber            = (unsigned int*) mxGetData(mxGetField(vsig, 0, "firstPhaseNumber"));
    secondPhaseNumber           = (unsigned int*) mxGetData(mxGetField(vsig, 0, "secondPhaseNumber"));
    readoutNumber               = (unsigned int*) mxGetData(mxGetField(vsig, 0, "readoutNumber"));
      
    protocolName                = (char*) mxArrayToString(mxGetField(vctl, 0, "protocolName"));
    systemVendor                = (char*) mxArrayToString(mxGetField(vctl, 0, "systemVendor"));
    systemModel                 = (char*) mxArrayToString(mxGetField(vctl, 0, "systemModel"));
    institutionName             = (char*) mxArrayToString(mxGetField(vctl, 0, "institutionName"));
    stationName                 = (char*) mxArrayToString(mxGetField(vctl, 0, "stationName"));
    trajectory                  = (char*) mxArrayToString(mxGetField(vctl, 0, "trajectory"));
    outputFile                  = (char*) mxArrayToString(mxGetField(vctl, 0, "outputFile"));
    receiverChannels            = (unsigned short*) mxGetData(mxGetField(vctl, 0, "receiverChannels"));
    ESMatrixSizeX               = (unsigned short*) mxGetData(mxGetField(vctl, 0, "ESMatrixSizeX"));
    ESMatrixSizeY               = (unsigned short*) mxGetData(mxGetField(vctl, 0, "ESMatrixSizeY"));
    ESMatrixSizeZ               = (unsigned short*) mxGetData(mxGetField(vctl, 0, "ESMatrixSizeZ"));
    RSMatrixSizeX               = (unsigned short*) mxGetData(mxGetField(vctl, 0, "RSMatrixSizeX"));
    RSMatrixSizeY               = (unsigned short*) mxGetData(mxGetField(vctl, 0, "RSMatrixSizeY"));
    RSMatrixSizeZ               = (unsigned short*) mxGetData(mxGetField(vctl, 0, "RSMatrixSizeZ"));
    H1resonanceFrequency_Hz     = (long*) mxGetData(mxGetField(vctl, 0, "H1resonanceFrequency_Hz"));
    ESFOVX                      = (float*) mxGetData(mxGetField(vctl, 0, "ESFOVX"));
    ESFOVY                      = (float*) mxGetData(mxGetField(vctl, 0, "ESFOVY"));
    ESFOVZ                      = (float*) mxGetData(mxGetField(vctl, 0, "ESFOVZ"));
    RSFOVX                      = (float*) mxGetData(mxGetField(vctl, 0, "RSFOVX"));
    RSFOVY                      = (float*) mxGetData(mxGetField(vctl, 0, "RSFOVY"));
    RSFOVZ                      = (float*) mxGetData(mxGetField(vctl, 0, "RSFOVZ"));
    systemFieldStrength_T       = (float*) mxGetData(mxGetField(vctl, 0, "systemFieldStrength_T"));
    TR                          = (float*) mxGetData(mxGetField(vctl, 0, "TR"));
    TE                          = (float*) mxGetData(mxGetField(vctl, 0, "TE"));
    BW                          = (float*) mxGetData(mxGetField(vctl, 0, "BW"));        

	std::cout << "ISMRMRD dataset creation starts." << std::endl;
    
    /********************* Create data file*****************************/
	ISMRMRD::IsmrmrdDataset d(outputFile,"dataset");

    /****Create a header, we will use the C++ class generated by XSD****/
	ISMRMRD::experimentalConditionsType exp(*H1resonanceFrequency_Hz);
	ISMRMRD::ismrmrdHeader h(exp);
    
    //Create an measurementInformation section
//     ISMRMRD::measurementInformationType mi;
//     h.measurementInformation(mi);
    
    //Create an acquisitionSystemInformation section
    ISMRMRD::acquisitionSystemInformationType asi;
    asi.systemVendor(systemVendor);
    asi.systemModel(systemModel);
    asi.systemFieldStrength_T(*systemFieldStrength_T);     
    asi.receiverChannels(*receiverChannels);     
    asi.institutionName(institutionName);
    asi.stationName(stationName);        
    h.acquisitionSystemInformation(asi);

	//Create an encoding section
	ISMRMRD::encodingSpaceType es(ISMRMRD::matrixSize(*ESMatrixSizeX,*ESMatrixSizeY,*ESMatrixSizeZ),ISMRMRD::fieldOfView_mm(*ESFOVX,*ESFOVY,*ESFOVZ));
    ISMRMRD::encodingSpaceType rs(ISMRMRD::matrixSize(*RSMatrixSizeX,*RSMatrixSizeY,*RSMatrixSizeZ),ISMRMRD::fieldOfView_mm(*RSFOVX,*RSFOVY,*RSFOVZ));
	ISMRMRD::encodingLimitsType el;
	el.kspace_encoding_step_1(ISMRMRD::limitType(0,*ESMatrixSizeY-1,(*ESMatrixSizeY>>1)));
    el.slice(ISMRMRD::limitType(0,*ESMatrixSizeZ-1,(*ESMatrixSizeZ>>1)));
    el.contrast(ISMRMRD::limitType(0,*echoNumber-1,(*echoNumber>>1)));
	ISMRMRD::encoding e(es,rs,el,trajectory);
    ISMRMRD::trajectoryDescriptionType td("FangLiuTest");
    td.comment("Test interface for convering MRiLab output to ISMRMRD");
    e.trajectoryDescription(td);
	h.encoding().push_back(e);
    
    //Create an sequenceParameters section
    ISMRMRD::sequenceParametersType sequence;
    sequence.TR().push_back(*TR);
    sequence.TE().push_back(*TE);
    h.sequenceParameters(sequence);
    
	//Create an  parallelImaging section
//     ISMRMRD::parallelImagingType parallel(ISMRMRD::accelerationFactorType(2,1));
//     parallel.calibrationMode(ISMRMRD::calibrationModeType::embedded);
//     parallel.interleavingDimension(ISMRMRD::interleavingDimensionType::phase);
//     h.parallelImaging(parallel);

    //Add user defined parameters
//     ISMRMRD::userParameterLongType upl("",1);
//     xsd::cxx::tree::sequence<ISMRMRD::userParameterLongType> upl_seq(2,upl);
//     
//     ISMRMRD::userParameterLongType shim("shim",1);
//     ISMRMRD::userParameterLongType grid("grid",1);
//     upl_seq[0] = shim;
//     upl_seq[1] = grid;
//     
//     ISMRMRD::userParameters up;
//     up.userParameterLong(upl_seq);
//     h.userParameters(up);
    
	//Serialize the header
	xml_schema::namespace_infomap map;
	map[""].name = "http://www.ismrm.org/ISMRMRD";
	map[""].schema = "ismrmrd.xsd";
	std::stringstream str;
	ISMRMRD::ismrmrdHeader_(str, h, map);
	std::string xml_header = str.str();

	//Write the header to the data file.
	d.writeHeader(xml_header);
    
	/******************Append the data to the file**********************/
	ISMRMRD::Acquisition acq;
    
	std::valarray<float> k;
	k.resize(2*(*readoutNumber));

    ScanCounter = 1;
    for (unsigned int e = 0; e < *echoNumber; e++){
        for (unsigned int s = 0; s < *secondPhaseNumber; s++){
            for (unsigned int f = 0; f < *firstPhaseNumber; f++){
                acq.setVersion(1);
                acq.setFlags(0);
                //Set some flags
                if (f == 0) {
                    acq.setFlag(ISMRMRD::FlagBit(ISMRMRD::ACQ_FIRST_IN_SLICE));
                }
                if (f == (*firstPhaseNumber-1)) {
                    acq.setFlag(ISMRMRD::FlagBit(ISMRMRD::ACQ_LAST_IN_SLICE));
                }
                
                acq.setScanCounter(ScanCounter);
                acq.setNumberOfSamples((unsigned short) *readoutNumber);
                acq.setAvailableChannels(*receiverChannels);
                acq.setActiveChannels(*receiverChannels);
//                     acq.head_.channel_mask
                acq.setDiscardPre(0);
                acq.setDiscardPost(0);
                acq.setCenterSample((unsigned short) (*readoutNumber>>1));
                acq.setTrajectoryDimensions(3);
                acq.setSampleTimeUs((1/(*BW)) * 1000000);
                
                acq.getIdx().kspace_encode_step_1  = (unsigned short) f;
                acq.getIdx().slice                 = (unsigned short) s;
                acq.getIdx().contrast              = (unsigned short) e;
                
                for (unsigned int c = 0; c < *receiverChannels; c++){ // copy data
                    memcpy(&acq[0],S
                            + e*(*readoutNumber * 2)
                            + f*((*readoutNumber * 2) * (*echoNumber))
                            + s*((*firstPhaseNumber) * (*readoutNumber * 2) * (*echoNumber))
                            + c*((*secondPhaseNumber) * (*firstPhaseNumber) * (*readoutNumber * 2) * (*echoNumber))
                            ,sizeof(float)*((*readoutNumber)*2));
                }
                
                memcpy(&k[0],K // copy K traj
                        + e*(*readoutNumber * 3)
                        + f*((*readoutNumber * 3) * (*echoNumber))
                        + s*((*firstPhaseNumber) * (*readoutNumber * 3) * (*echoNumber))
                        ,sizeof(float)*((*readoutNumber)*2));
                
                acq.setTraj(k);
                
                d.appendAcquisition(&acq);
                
                ScanCounter++;
                
            }
        }
    }
    std::cout << "ISMRMRD dataset creation succeeds." << std::endl;
	return;
}
