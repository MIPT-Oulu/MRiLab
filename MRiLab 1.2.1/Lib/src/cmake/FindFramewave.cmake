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

# - this module looks for Framewave
# Defines:
#  FW_INCLUDE_DIR: include path for fwBase.h, fwSignal.h
#  FW_LIBRARIES:   required libraries: fwBase,fwSignal, etc
#  FW_BASE_LIBRARY: path to libfwBase
#  FW_SIGNAL_LIBRARY:  path to libfwSignal

SET(FW_FOUND 0)
IF( "$ENV{FRAMEWAVE_ROOT}" STREQUAL "" )
    MESSAGE(STATUS "FRAMEWAVE_ROOT environment variable not set." )
    MESSAGE(STATUS "In Linux this can be done in your user .bashrc file by appending the corresponding line, e.g:" )
    MESSAGE(STATUS "export FRAMEWAVE_ROOT=/usr/local/framewave/build" )
    MESSAGE(STATUS "In Windows this can be done by adding system variable, e.g:" )
    MESSAGE(STATUS "FRAMEWAVE_ROOT=C:\\Program Files\\FRAMEWAVE_1.3.1_SRC\\Framewave\\build" )
ELSE("$ENV{FRAMEWAVE_ROOT}" STREQUAL "" )

    FIND_PATH(FW_INCLUDE_DIR fwBase.h fwSignal.h
        HINTS $ENV{FRAMEWAVE_ROOT}/include
        PATHS /usr/local /usr/include /usr/local/include
        PATH_SUFFIXES framewave framewave/include include)

    INCLUDE_DIRECTORIES(${FW_INCLUDE_DIR})

    FIND_LIBRARY( FW_BASE_LIBRARY
                  NAMES "fwBase"
                  PATHS $ENV{FRAMEWAVE_ROOT}/bin /usr/local/lib /usr/lib
                  PATH_SUFFIXES release_shared_64 debug_shared_64)

    FIND_LIBRARY( FW_SIGNAL_LIBRARY
                  NAMES "fwSignal"
                  PATHS $ENV{FRAMEWAVE_ROOT}/bin /usr/local/lib /usr/lib
                  PATH_SUFFIXES release_shared_64 debug_shared_64)

    MESSAGE (STATUS "FRAMEWAVE_ROOT: $ENV{FRAMEWAVE_ROOT}")

ENDIF("$ENV{FRAMEWAVE_ROOT}" STREQUAL "" )

SET(FW_LIBRARIES
  ${FW_BASE_LIBRARY}
  ${FW_SIGNAL_LIBRARY}
)

IF(FW_INCLUDE_DIR AND FW_LIBRARIES)
  SET(FW_FOUND 1)
ENDIF(FW_INCLUDE_DIR AND FW_LIBRARIES)

INCLUDE( "FindPackageHandleStandardArgs" )
FIND_PACKAGE_HANDLE_STANDARD_ARGS("Framewave" DEFAULT_MSG FW_LIBRARIES FW_INCLUDE_DIR)