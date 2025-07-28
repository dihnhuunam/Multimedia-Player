file(GLOB MODELS *.cpp)

add_library(model_lib 
    SHARED 
        ${MODELS}
)

target_include_directories(model_lib    
    PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}
)

