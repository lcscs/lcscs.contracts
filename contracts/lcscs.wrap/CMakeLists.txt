add_contract(lcscs.wrap lcscs.wrap ${CMAKE_CURRENT_SOURCE_DIR}/src/lcscs.wrap.cpp)

target_include_directories(lcscs.wrap
   PUBLIC
   ${CMAKE_CURRENT_SOURCE_DIR}/include)

set_target_properties(lcscs.wrap
   PROPERTIES
   RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/ricardian/lcscs.wrap.contracts.md.in ${CMAKE_CURRENT_BINARY_DIR}/ricardian/lcscs.wrap.contracts.md @ONLY )

target_compile_options( lcscs.wrap PUBLIC -R${CMAKE_CURRENT_SOURCE_DIR}/ricardian -R${CMAKE_CURRENT_BINARY_DIR}/ricardian )
