add_contract(lcscs.trace lcscs.trace
   ${CMAKE_CURRENT_SOURCE_DIR}/src/lcscs.trace.cpp
)

target_include_directories(lcscs.trace
   PUBLIC
   ${CMAKE_CURRENT_SOURCE_DIR}/include
   ${CMAKE_CURRENT_SOURCE_DIR}/../lcscs.token/include
   ${CMAKE_CURRENT_SOURCE_DIR}/../common/include)
   
set_target_properties(lcscs.trace
   PROPERTIES
   RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
