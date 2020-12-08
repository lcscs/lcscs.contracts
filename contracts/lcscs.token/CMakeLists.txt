add_contract(lcscs.token lcscs.token ${CMAKE_CURRENT_SOURCE_DIR}/src/lcscs.token.cpp)

target_include_directories(lcscs.token
   PUBLIC
   ${CMAKE_CURRENT_SOURCE_DIR}/include)

set_target_properties(lcscs.token
   PROPERTIES
   RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/ricardian/lcscs.token.contracts.md.in ${CMAKE_CURRENT_BINARY_DIR}/ricardian/lcscs.token.contracts.md @ONLY )

target_compile_options( lcscs.token PUBLIC -R${CMAKE_CURRENT_SOURCE_DIR}/ricardian -R${CMAKE_CURRENT_BINARY_DIR}/ricardian )
