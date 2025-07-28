file(GLOB VIEW_MODELS *.cpp)

add_library(view_model_source 
    SHARED 
        ${VIEW_MODELS}
)

target_include_directories(view_model_source 
    PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}
)
