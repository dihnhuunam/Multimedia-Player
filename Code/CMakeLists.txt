cmake_minimum_required(VERSION 3.16)

project(Multimedia-Player)

set(CXX_STANDARD 14)
set(CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# add_subdirectory(Model)
# add_subdirectory(ViewModel)
add_executable(${PROJECT_NAME} 
    main.cpp
    resources.qrc
)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Gui
)

target_link_libraries(${PROJECT_NAME} 
    PUBLIC 
        Qt6::Quick
        Qt6::Gui
)
