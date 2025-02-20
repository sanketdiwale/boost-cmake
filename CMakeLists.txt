cmake_minimum_required(VERSION 3.12)
project(Boost-CMake)

if(MSVC)
set_property(GLOBAL PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded") #"MultiThreaded$<$<CONFIG:Debug>:Debug>")
add_link_options(/verbose /NODEFAULTLIB:MSVCRT)
endif()

option(BOOST_DISABLE_TESTS "Do not build test targets, even if building standalone" OFF)
option(BOOST_NO_CXX11_SCOPED_ENUMS ON)
set(BOOST_NO_CXX11_SCOPED_ENUMS TRUE)
set(BOOST_URL "https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.bz2" CACHE STRING "Boost download URL")
set(BOOST_URL_SHA256 "71feeed900fbccca04a3b4f2f84a7c217186f28a940ed8b7ed4725986baf99fa" CACHE STRING "Boost download URL SHA256 checksum")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++20")
include(FetchContent)
FetchContent_Declare(
  Boost
  URL ${BOOST_URL}
  URL_HASH SHA256=${BOOST_URL_SHA256}
)
FetchContent_GetProperties(Boost)

if(NOT Boost_POPULATED)
  message(STATUS "Fetching Boost")
  FetchContent_Populate(Boost)
  message(STATUS "Fetching Boost - done")
  set(BOOST_SOURCE ${boost_SOURCE_DIR})
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)
include(CheckBoostVersion)

message(STATUS "Boost found: ${BOOST_VERSION} ${BOOST_SOURCE}")

include(StandaloneBuild)
include(PlatformDetect)
include(AddBoostLib)
include(AddBoostTest)

set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)

if(USE_ANDROID)
  # CMake 3.7.1 doesn't define the target triple for the ASM language,
  # resulting in all files compiled for the host architecture
  set(CMAKE_ASM_COMPILER_TARGET "${CMAKE_CXX_COMPILER_TARGET}")
endif()

set(BOOST_LIBS_REQUIRED
  # Header only libs
  header
)
set(BOOST_LIBS_OPTIONAL
  # Compiled libs
  atomic
  chrono
  container
  context
  coroutine
  date_time
  exception
  fiber
  filesystem
  graph
  iostreams
  locale
  log
  math
  mpi
  graph_parallel # depends on mpi, so needs to be put after it
  program_options
  #python # complex module
  random
  regex
  serialization
  system
  test
  thread
  timer
  type_erasure
  wave
  CACHE STRING "Boost libs to be compiled"
)

foreach(lib ${BOOST_LIBS_REQUIRED})
  include("libs/${lib}.cmake")
endforeach()

foreach(lib ${BOOST_LIBS_OPTIONAL})
  # In case only a subset of modules is available (eg. after using bcp)
  if(EXISTS "${BOOST_SOURCE}/libs/${lib}")
    include("libs/${lib}.cmake")
  endif()
endforeach()

# TODO: Move those to option() calls in the right file
if(NOT BOOST_STANDALONE)
  # Compilation options required by all platforms
  target_compile_definitions(Boost::boost INTERFACE
    $<$<CONFIG:Release>:BOOST_DISABLE_ASSERT>
    BOOST_SYSTEM_NO_DEPRECATED
    BOOST_THREAD_VERSION=4
    BOOST_THREAD_USES_CHRONO
    BOOST_THREAD_PROVIDES_EXECUTORS
    BOOST_THREAD_USES_DATETIME
  )
endif()

if(USE_ANDROID)
  # Android doesn't support thread local storage through compiler intrinsics
  target_compile_definitions(Boost::boost INTERFACE BOOST_ASIO_DISABLE_THREAD_KEYWORD_EXTENSION)
endif()
