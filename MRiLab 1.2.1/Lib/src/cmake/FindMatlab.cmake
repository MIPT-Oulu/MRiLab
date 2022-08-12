#                                                _______
# _________________________________________     / _____ \      
#     .  .     |---- (OO)|       ___   |       | |     | |     
#    /\  /\    |__ |  || |      /   \  |___    |_|     |_|     
#   /  \/  \   |  \   || |      \___/  |   \   |S|     |N|     
#  /   ||   \  |   \_ || |____|     \  |___/  MRI Simulator    
# _________________________________________                  
# Numerical MRI Simulation Package
# Version 1.2  - https://sourceforge.net/projects/mrilab/
#
# The MRiLab is a numerical MRI simulation package. It has been developed to 
# simulate factors that affect MR signal formation, acquisition and image 
# reconstruction. The simulation package features highly interactive graphic 
# user interface for various simulation purposes. MRiLab provides several 
# toolboxes for MR researchers to analyze RF pulse, design MR sequence, 
# configure multiple transmitting and receiving coils, investigate B0 
# in-homogeneity and object motion sensitivity et.al. The main simulation 
# platform combined with these toolboxes can be applied for customizing 
# various virtual MR experiments which can serve as a prior stage for 
# prototyping and testing new MR technique and application.
#
# Author:
#   Fang Liu <leoliuf@gmail.com>
#   University of Wisconsin-Madison
#   April-6-2014
# _________________________________________________________________________
# Copyright (c) 2011-2014, Fang Liu <leoliuf@gmail.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are 
# met:
# 
#     * Redistributions of source code must retain the above copyright 
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in 
#       the documentation and/or other materials provided with the distribution
#       
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
# _________________________________________________________________________

# - this module looks for Matlab
# Defines:
#  MATLAB_INCLUDE_DIR: include path for mex.h
#  MATLAB_LIBRARIES:   required libraries: libmex, libmx
#  MATLAB_MEX_LIBRARY: path to libmex
#  MATLAB_MX_LIBRARY:  path to libmx

SET(MATLAB_FOUND 0)
IF( "$ENV{MATLAB_ROOT}" STREQUAL "" )
    MESSAGE(STATUS "MATLAB_ROOT environment variable not set." )
    MESSAGE(STATUS "In Linux this can be done in your user .bashrc file by appending the corresponding line, e.g:" )
    MESSAGE(STATUS "export MATLAB_ROOT=/usr/local/MATLAB/R2012b" )
    MESSAGE(STATUS "In Windows this can be done by adding system variable, e.g:" )
    MESSAGE(STATUS "MATLAB_ROOT=D:\\Program Files\\MATLAB\\R2011a" )
ELSE("$ENV{MATLAB_ROOT}" STREQUAL "" )

        FIND_PATH(MATLAB_INCLUDE_DIR mex.h
                  $ENV{MATLAB_ROOT}/extern/include)

        INCLUDE_DIRECTORIES(${MATLAB_INCLUDE_DIR})

        FIND_LIBRARY( MATLAB_MEX_LIBRARY
                      NAMES libmex mex
                      PATHS $ENV{MATLAB_ROOT}/bin $ENV{MATLAB_ROOT}/extern/lib 
                      PATH_SUFFIXES glnxa64 glnx86 win64/microsoft win32/microsoft)

        FIND_LIBRARY( MATLAB_MX_LIBRARY
                      NAMES libmx mx
                      PATHS $ENV{MATLAB_ROOT}/bin $ENV{MATLAB_ROOT}/extern/lib 
                      PATH_SUFFIXES glnxa64 glnx86 win64/microsoft win32/microsoft)

    MESSAGE (STATUS "MATLAB_ROOT: $ENV{MATLAB_ROOT}")

ENDIF("$ENV{MATLAB_ROOT}" STREQUAL "" )

# This is common to UNIX and Win32:
SET(MATLAB_LIBRARIES
  ${MATLAB_MEX_LIBRARY}
  ${MATLAB_MX_LIBRARY}
)

IF(MATLAB_INCLUDE_DIR AND MATLAB_LIBRARIES)
  SET(MATLAB_FOUND 1)
  MESSAGE(STATUS "Matlab mex will be used")
ENDIF(MATLAB_INCLUDE_DIR AND MATLAB_LIBRARIES)

MARK_AS_ADVANCED(
  MATLAB_LIBRARIES
  MATLAB_MEX_LIBRARY
  MATLAB_MX_LIBRARY
  MATLAB_INCLUDE_DIR
  MATLAB_FOUND
  MATLAB_ROOT
)
