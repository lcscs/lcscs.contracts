add_contract(lcscs.bios lcscs.bios ${CMAKE_CURRENT_SOURCE_DIR}/src/lcscs.bios.cpp)

target_include_directories(lcscs.bios
   PUBLIC
   ${CMAKE_CURRENT_SOURCE_DIR}/include)

set_target_properties(lcscs.bios
   PROPERTIES
   RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/ricardian/lcscs.bios.contracts.md.in ${CMAKE_CURRENT_BINARY_DIR}/ricardian/lcscs.bios.contracts.md @ONLY )

target_compile_options( lcscs.bios PUBLIC -R${CMAKE_CURRENT_SOURCE_DIR}/ricardian -R${CMAKE_CURRENT_BINARY_DIR}/ricardian )
