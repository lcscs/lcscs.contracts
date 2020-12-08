add_contract(lcscs.msig lcscs.msig ${CMAKE_CURRENT_SOURCE_DIR}/src/lcscs.msig.cpp)

target_include_directories(lcscs.msig
   PUBLIC
   ${CMAKE_CURRENT_SOURCE_DIR}/include)

set_target_properties(lcscs.msig
   PROPERTIES
   RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/ricardian/lcscs.msig.contracts.md.in ${CMAKE_CURRENT_BINARY_DIR}/ricardian/lcscs.msig.contracts.md @ONLY )

target_compile_options( lcscs.msig PUBLIC -R${CMAKE_CURRENT_SOURCE_DIR}/ricardian -R${CMAKE_CURRENT_BINARY_DIR}/ricardian )
