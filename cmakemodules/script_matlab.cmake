# Check for Matlab (Only in Linux, there is no
#  Windows version yet...)
# ===================================================
SET(CMAKE_MRPT_HAS_MATLAB 0)

IF(NOT UNIX)
    MESSAGE(WARNING "MRPT-MEX wrapper has been tested only in Linux. No Windows support exists yet.")
    SET(BUILD_MATLAB 0)
ENDIF(NOT UNIX)

# Natural option to set ON the building of Matlab wrapper
# --------------------------------------------------------
IF(BUILD_MATLAB)

# Set sensible initial path for Matlab
IF(NOT MATLAB_ROOT)
        IF(WINDOWS) # In Windows
                SET(MATLAB_ROOT "C:")
        ELSE(WINDOWS) # In Linux
                SET(MATLAB_ROOT "/usr/local/MATLAB")
        ENDIF(WINDOWS)

        IF(IS_DIRECTORY ${MATLAB_ROOT}) # Search installed versions in default directory
                FILE(GLOB LIST_MATLAB_INSTALLS RELATIVE ${MATLAB_ROOT} ${MATLAB_ROOT}/*)
                # Use first subdirectory (usually newest version)
                LIST(SORT LIST_MATLAB_INSTALLS) # Sort alphabetically
                LIST(REVERSE LIST_MATLAB_INSTALLS) # Reverse order
                LIST(GET LIST_MATLAB_INSTALLS 0 MATLAB_VERSION) # Take first element (highest version)

                SET(MATLAB_ROOT "${MATLAB_ROOT}/${MATLAB_VERSION}")
        ENDIF(IS_DIRECTORY ${MATLAB_ROOT})

        SET(MATLAB_ROOT ${MATLAB_ROOT} CACHE PATH "Path to the MATLAB installation directory (e.g. /usr/local/MATLAB/R2012b, C:/... (TODO)")
        SET(MATLAB_VERSION ${MATLAB_VERSION} CACHE STRING "R...-like version to use from installed ones")
ENDIF(NOT MATLAB_ROOT)

# DISABLE_MATLAB
# ---------------------
OPTION(DISABLE_MATLAB "Force not using Matlab" "OFF")
MARK_AS_ADVANCED(DISABLE_MATLAB)
IF(NOT DISABLE_MATLAB)

# Use CMAKE module if Matlab's not been detected yet:
IF(NOT CMAKE_MRPT_HAS_MATLAB)
# TODO: This behaviour does not allow to update found libraries if MATLAB_ROOT is changed
        FIND_PACKAGE(Matlab)
        IF(MATLAB_FOUND)
                SET(CMAKE_MRPT_HAS_MATLAB 1)
                APPEND_MRPT_LIBS( ${MATLAB_LIBRARIES} )

                # MEXPLUS header-only lib to handle mxArray class:
                ADD_SUBDIRECTORY("${MRPT_SOURCE_DIR}/otherlibs/mexplus/")
        ENDIF(MATLAB_FOUND)
ENDIF(NOT CMAKE_MRPT_HAS_MATLAB)

# It seems it works with dynamic libraries too now!
## Set special options for Matlab wrapper compatibility
#IF(BUILD_SHARED_LIBS)
#        MESSAGE(SEND_ERROR
#"BUILD_SHARED_LIBS is activated.
#Static libraries are needed for MEX libraries due to TLS limitation in Matlab. Deactivate BUILD_SHARED_LIBRARIES.")
#ENDIF(BUILD_SHARED_LIBS)

## Since MEX libraries are dynamic but MRPT libraries need to be static, the static libraries must be Position Independent Code (PIC)
#SET(EXTRA_CPP_FLAGS "${EXTRA_CPP_FLAGS} -fPIC")

# Copy all .m files (classes, samples, helpers...) to the build directory
FILE(COPY ${CMAKE_SOURCE_DIR}/mex/+mrpt DESTINATION ${CMAKE_BINARY_DIR}/mex)
FILE(COPY ${CMAKE_SOURCE_DIR}/mex/samples DESTINATION ${CMAKE_BINARY_DIR}/mex)

ENDIF(NOT DISABLE_MATLAB)

ENDIF(BUILD_MATLAB)