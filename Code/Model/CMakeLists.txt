file(GLOB MODEL_SOURCES ${CMAKE_CURRENT_LIST_DIR}/*.cpp)

add_library(Model SHARED ${MODEL_SOURCES})

find_package(Qt6 REQUIRED COMPONENTS
    Core
)

target_link_libraries(Model 
    PUBLIC 
        Qt6::Core
)

target_include_directories(Model
    PUBLIC 
        ${CMAKE_CURRENT_LIST_DIR}
)
