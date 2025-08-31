add_library(Service 
    STATIC 
        ${CMAKE_CURRENT_SOURCE_DIR}/App/AppState.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/API/APIFactory.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/API/RESTful.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/Authentication/AuthService.cpp
)

target_include_directories(Service
    PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}/App
        ${CMAKE_CURRENT_SOURCE_DIR}/API
        ${CMAKE_CURRENT_SOURCE_DIR}/Data
        ${CMAKE_CURRENT_SOURCE_DIR}/Authentication

)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Network
)

target_link_libraries(Service 
    PUBLIC 
        Qt6::Core
        Qt6::Network
)

