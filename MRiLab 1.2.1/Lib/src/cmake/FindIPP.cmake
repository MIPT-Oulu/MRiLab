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

# - this module looks for IPP
# Defines:
#  IPP_INCLUDE_DIR: include path for ipp.h
#  IPP_LIBRARIES: required libraries

SET(IPP_FOUND 0)
IF( "$ENV{IPP_ROOT}" STREQUAL "" )
	MESSAGE(STATUS "IPP_ROOT environment variable not set." )
	MESSAGE(STATUS "In Linux this can be done in your user .bashrc file by appending the corresponding line, e.g:" )
	MESSAGE(STATUS "export IPP_ROOT=/opt/intel/composer_xe_2013/ipp" )
    MESSAGE(STATUS "In Windows this can be done by adding system variable, e.g:" )
    MESSAGE(STATUS "IPP_ROOT=C:\\Program Files\\Intel\\IPP\\6.1.6.056\\em64t" )
ELSE( "$ENV{IPP_ROOT}" STREQUAL "" )
    IF(WIN32)
        IF ($ENV{IPP_ROOT} MATCHES .*Composer.*)   #IPP 7.X

            FIND_PATH(IPP_INCLUDE_DIR ipp.h
                PATHS $ENV{IPP_ROOT}/include /usr/include /usr/local/include
                PATH_SUFFIXES ipp ipp/include)
            INCLUDE_DIRECTORIES(${IPP_INCLUDE_DIR})

            SET(IPP_LIB_PATH $ENV{IPP_ROOT}/lib/intel64/)
            FIND_LIBRARY( IPP_S_LIBRARY
                          NAMES "ipps_l"
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_VM_LIBRARY
                          NAMES "ippvm_l"
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_CORE_LIBRARY
                          NAMES "ippcore_l"
                          PATHS ${IPP_LIB_PATH})

            SET(IPP_LIBRARIES
              ${IPP_S_LIBRARY}
              ${IPP_VM_LIBRARY}
              ${IPP_CORE_LIBRARY}
            )

            MESSAGE (STATUS "IPP_ROOT (IPP 7): $ENV{IPP_ROOT}")

        ELSE ($ENV{IPP_ROOT} MATCHES .*Composer.*)    #IPP 6.X

            FIND_PATH(IPP_INCLUDE_DIR ipp.h
                      PATHS $ENV{IPP_ROOT}/include)

            INCLUDE_DIRECTORIES(${IPP_INCLUDE_DIR})

            SET(IPP_LIB_PATH $ENV{IPP_ROOT}/lib)

            FIND_LIBRARY( IPP_SE_LIBRARY
                          NAMES ippsemergedem64t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_S_LIBRARY
                          NAMES ippsmergedem64t_t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_VME_LIBRARY
                          NAMES ippvmemergedem64t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_VM_LIBRARY
                          NAMES ippvmmergedem64t_t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_IOMP5_LIBRARY
                          NAMES "libiomp5mt"
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_CORE_LIBRARY
                          NAMES ippcoreem64t_t
                          PATHS ${IPP_LIB_PATH})

            SET(IPP_LIBRARIES
              ${IPP_SE_LIBRARY}
              ${IPP_S_LIBRARY}
              ${IPP_VME_LIBRARY}
              ${IPP_VM_LIBRARY}
              ${IPP_IOMP5_LIBRARY}
              ${IPP_CORE_LIBRARY}
            )

            MESSAGE (STATUS "IPP_ROOT (IPP 6): $ENV{IPP_ROOT}")
        ENDIF ($ENV{IPP_ROOT} MATCHES .*Composer.*)

    ELSE(WIN32)

        IF ($ENV{IPP_ROOT} MATCHES .*composer.*)	#IPP 7.X

            FIND_PATH(IPP_INCLUDE_DIR ipp.h
                PATHS $ENV{IPP_ROOT}/include $ENV{IPP_ROOT}/../include /usr/include /usr/local/include
                PATH_SUFFIXES ipp ipp/include)
            INCLUDE_DIRECTORIES(${IPP_INCLUDE_DIR})

            SET(IPP_LIB_PATH $ENV{IPP_ROOT}/lib/intel64/)
            FIND_LIBRARY( IPP_S_LIBRARY
                          NAMES "ipps_l"
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_VM_LIBRARY
                          NAMES "ippvm_l"
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_CORE_LIBRARY
                          NAMES "ippcore_l"
                          PATHS ${IPP_LIB_PATH})

            SET(IPP_LIBRARIES
              ${IPP_S_LIBRARY}
              ${IPP_VM_LIBRARY}
              ${IPP_CORE_LIBRARY}
            )
            MESSAGE (STATUS "IPP_ROOT (IPP 7): $ENV{IPP_ROOT}")

        ELSE ($ENV{IPP_ROOT} MATCHES .*composer.*)    #IPP 6.X

            FIND_PATH(IPP_INCLUDE_DIR ipp.h
                    PATHS $ENV{IPP_ROOT}/include $ENV{IPP_ROOT}/../include /usr/include /usr/local/include
                    PATH_SUFFIXES ipp ipp/include)
            INCLUDE_DIRECTORIES(${IPP_INCLUDE_DIR})


            SET(IPP_LIB_PATH $ENV{IPP_ROOT}/lib)

            FIND_LIBRARY( IPP_SE_LIBRARY
                          NAMES ippsemergedem64t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_S_LIBRARY
                          NAMES ippsmergedem64t_t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_VME_LIBRARY
                          NAMES ippvmemergedem64t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_VM_LIBRARY
                          NAMES ippvmmergedem64t_t
                          PATHS ${IPP_LIB_PATH})

            FIND_LIBRARY( IPP_IOMP5_LIBRARY
                          NAMES "iomp5"
                          PATHS $ENV{IPP_ROOT}/sharedlib)

            FIND_LIBRARY( IPP_CORE_LIBRARY
                          NAMES ippcoreem64t_t
                          PATHS ${IPP_LIB_PATH})

            SET(IPP_LIBRARIES
              ${IPP_SE_LIBRARY}
              ${IPP_S_LIBRARY}
              ${IPP_VME_LIBRARY}
              ${IPP_VM_LIBRARY}
              ${IPP_IOMP5_LIBRARY}
              ${IPP_CORE_LIBRARY}
            )

            MESSAGE (STATUS "IPP_ROOT (IPP 6): $ENV{IPP_ROOT}")
        ENDIF ($ENV{IPP_ROOT} MATCHES .*composer.*)

    ENDIF(WIN32)

ENDIF( "$ENV{IPP_ROOT}" STREQUAL "" )

IF(IPP_INCLUDE_DIR AND IPP_LIBRARIES)
    SET(IPP_FOUND 1)
ENDIF(IPP_INCLUDE_DIR AND IPP_LIBRARIES)

INCLUDE( "FindPackageHandleStandardArgs" )
FIND_PACKAGE_HANDLE_STANDARD_ARGS("IPP" DEFAULT_MSG IPP_LIBRARIES IPP_INCLUDE_DIR)