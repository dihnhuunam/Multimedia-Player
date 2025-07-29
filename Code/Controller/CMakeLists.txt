file(GLOB CONTROLLER_SOURCES ${CMAKE_CURRENT_LIST_DIR}/*.cpp)

add_library(Controller SHARED ${CONTROLLER_SOURCES})

find_package(Qt6 REQUIRED COMPONENTS
    Core
)

target_link_libraries(Controller 
    PUBLIC 
        Qt6::Core
        Model 
)

target_include_directories(Controller
    PUBLIC 
        ${CMAKE_CURRENT_LIST_DIR}
)
