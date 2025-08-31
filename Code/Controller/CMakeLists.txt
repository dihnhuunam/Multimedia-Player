add_library(Controller 
    STATIC 
        ${CMAKE_CURRENT_SOURCE_DIR}/Authentication/AuthController.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/Profile/ProfileController.cpp
)

target_include_directories(Controller
    PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}/Authentication
        ${CMAKE_CURRENT_SOURCE_DIR}/Profile
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


