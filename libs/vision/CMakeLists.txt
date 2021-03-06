# Lists of directories with source files:
#  See "DeclareMRPTLib.cmake" for explanations
# -------------------------------------------------
LIST(APPEND vision_EXTRA_SRCS		"${MRPT_SOURCE_DIR}/libs/vision/src/maps/*.cpp" "${MRPT_SOURCE_DIR}/libs/vision/include/mrpt/slam/*.h")
LIST(APPEND vision_EXTRA_SRCS_NAME 	"maps" "maps")

LIST(APPEND vision_EXTRA_SRCS		"${MRPT_SOURCE_DIR}/libs/vision/src/obs/*.cpp" "${MRPT_SOURCE_DIR}/libs/vision/include/mrpt/slam/CObservation*.h")
LIST(APPEND vision_EXTRA_SRCS_NAME 	"observations" "observations")

IF(CMAKE_MRPT_HAS_SIFT_HESS)
	LIST(APPEND vision_EXTRA_SRCS		
		"${MRPT_SOURCE_DIR}/libs/vision/src/sift-hess/imgfeatures.c" 
		"${MRPT_SOURCE_DIR}/libs/vision/src/sift-hess/sift.c" 
		"${MRPT_SOURCE_DIR}/libs/vision/src/sift-hess/utils.c" 
		"${MRPT_SOURCE_DIR}/libs/vision/include/mrpt/sift-hess/*.h")
	LIST(APPEND vision_EXTRA_SRCS_NAME 	"sift-hess" "sift-hess" "sift-hess" "sift-hess")
ENDIF(CMAKE_MRPT_HAS_SIFT_HESS)

LIST(APPEND vision_EXTRA_SRCS		
	"${MRPT_SOURCE_DIR}/libs/vision/src/faster/*.cpp" 
	"${MRPT_SOURCE_DIR}/libs/vision/src/faster/*.h" )
LIST(APPEND vision_EXTRA_SRCS_NAME 	"faster" "faster")

IF(CMAKE_MRPT_HAS_OPENCV)
	INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIR} ${OpenCV_INCLUDE_DIRS} ${OPENCV_INCLUDE_DIRS} ${OPENCV_INCLUDEDIR})
ENDIF(CMAKE_MRPT_HAS_OPENCV)

#---------------------------------------------
# Macro declared in "DeclareMRPTLib.cmake":
#---------------------------------------------
define_mrpt_lib(
	# Lib name
	vision 		
	# Dependencies:
	mrpt-obs	
	# Deps of deps:
	mrpt-opengl  
	mrpt-base
	#mrpt-gui  # used to camera preview, etc. (only for debugging!)
	mrpt-opengl  # needed by mrpt-gui
	)

IF(BUILD_mrpt-vision) 
	IF(CMAKE_MRPT_HAS_SIFT_HESS)
		IF (MRPT_ENABLE_PRECOMPILED_HDRS AND MSVC)
			# Ignore precompiled headers in sift-hess sources:
			set_source_files_properties(${sift-hess_FILES} PROPERTIES COMPILE_FLAGS "/Y- /wd4244")
		ENDIF (MRPT_ENABLE_PRECOMPILED_HDRS AND MSVC)

		# Avoid some annoying warnings:
		IF (CMAKE_COMPILER_IS_GNUCXX)
			set_source_files_properties(${sift-hess_FILES} PROPERTIES COMPILE_FLAGS "-Wno-unused-function")
		ENDIF (CMAKE_COMPILER_IS_GNUCXX)
	ENDIF(CMAKE_MRPT_HAS_SIFT_HESS)

	# Ignore precompiled headers in faster sources:
	IF (MRPT_ENABLE_PRECOMPILED_HDRS AND MSVC)
		set_source_files_properties(${faster_FILES} PROPERTIES COMPILE_FLAGS "/Y-")
	ENDIF (MRPT_ENABLE_PRECOMPILED_HDRS AND MSVC)

	IF(CMAKE_MRPT_HAS_OPENCV)
		target_link_libraries(mrpt-vision ${OpenCV_LIBRARIES})
	ENDIF(CMAKE_MRPT_HAS_OPENCV)

ENDIF(BUILD_mrpt-vision) 

