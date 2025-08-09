add_library(Model 
    SHARED
        ${CMAKE_CURRENT_SOURCE_DIR}/User/UserModel.cpp
    )

target_include_directories(Model
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/User
)

find_package(Qt6 REQUIRED COMPONENTS
    Core
)

target_link_libraries(Model
    PUBLIC
        Qt6::Core
        Service
)
