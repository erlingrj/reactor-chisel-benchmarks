find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(${LF_TARGET_MAIN} ${OpenCV_LIBS})