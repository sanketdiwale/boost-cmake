_add_boost_lib(
  NAME regex
  SOURCES
    # ${BOOST_SOURCE}/libs/regex/src/c_regex_traits.cpp
    # ${BOOST_SOURCE}/libs/regex/src/cpp_regex_traits.cpp
    # ${BOOST_SOURCE}/libs/regex/src/cregex.cpp
    # ${BOOST_SOURCE}/libs/regex/src/fileiter.cpp
    # ${BOOST_SOURCE}/libs/regex/src/icu.cpp
    # ${BOOST_SOURCE}/libs/regex/src/instances.cpp
    ${BOOST_SOURCE}/libs/regex/src/posix_api.cpp
    ${BOOST_SOURCE}/libs/regex/src/regex.cpp
    ${BOOST_SOURCE}/libs/regex/src/regex_debug.cpp
    # ${BOOST_SOURCE}/libs/regex/src/regex_raw_buffer.cpp
    # ${BOOST_SOURCE}/libs/regex/src/regex_traits_defaults.cpp
    ${BOOST_SOURCE}/libs/regex/src/static_mutex.cpp
    # ${BOOST_SOURCE}/libs/regex/src/w32_regex_traits.cpp
    # ${BOOST_SOURCE}/libs/regex/src/wc_regex_traits.cpp
    ${BOOST_SOURCE}/libs/regex/src/wide_posix_api.cpp
    ${BOOST_SOURCE}/libs/regex/src/internals.hpp
    # ${BOOST_SOURCE}/libs/regex/src/winstances.cpp
    # ${BOOST_SOURCE}/libs/regex/src/usinstances.cpp
)
