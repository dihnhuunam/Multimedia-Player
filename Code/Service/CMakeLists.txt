add_library(Service 
    SHARED 
        ${CMAKE_CURRENT_SOURCE_DIR}/AppState.cpp
)

find_package(Qt6 REQUIRED COMPONENTS
    Core
)

target_link_libraries(Service 
    PUBLIC 
        Qt6::Core
)

target_include_directories(Service
    PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}
)
