add_library(API 
    SHARED
        ${CMAKE_CURRENT_SOURCE_DIR}/RESTful.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/APIFactory.cpp
)

target_include_directories(API
    PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}
)


find_package(Qt6 REQUIRED COMPONENTS
    Core
    Network
)

target_link_libraries(API 
    PUBLIC 
        Qt6::Core
        Qt6::Network
)

