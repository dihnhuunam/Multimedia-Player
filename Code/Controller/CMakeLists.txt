add_library(Controller 
    SHARED 
        ${CMAKE_CURRENT_SOURCE_DIR}/Authentication/AuthController.cpp
)

target_include_directories(Controller
    PUBLIC 
        ${CMAKE_CURRENT_LIST_DIR}/Authentication
)

find_package(Qt6 REQUIRED COMPONENTS
    Core
)

target_link_libraries(Controller 
    PUBLIC 
        Qt6::Core
        Model
        Service
)


