cmake_minimum_required(VERSION 3.16)

project(Multimedia-Player)

set(CXX_STANDARD 14)
set(CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

add_executable(${PROJECT_NAME} 
    main.cpp
    resources.qrc
)

add_subdirectory(Model)
add_subdirectory(API)
add_subdirectory(Service)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Gui
    Qml
)

target_link_libraries(${PROJECT_NAME} 
    PUBLIC 
        Qt6::Quick
        Qt6::Gui
        Qt6::Qml
        API
        Model 
        Service
        # Controller
)

if(WIN32)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:Model>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:API>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:Service>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
        # COMMAND ${CMAKE_COMMAND} -E copy_if_different
        #     $<TARGET_FILE:Controller>
        #     $<TARGET_FILE_DIR:${PROJECT_NAME}>
    )
endif()