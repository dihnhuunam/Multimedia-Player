file(GLOB SERVICE_SOURCES ${CMAKE_CURRENT_LIST_DIR}/*.cpp)

add_library(Service SHARED ${SERVICE_SOURCES})

find_package(Qt6 REQUIRED COMPONENTS
    Core
)

target_link_libraries(Service 
    PUBLIC 
        Qt6::Core
)

target_include_directories(Service
    PUBLIC 
        ${CMAKE_CURRENT_LIST_DIR}
)
