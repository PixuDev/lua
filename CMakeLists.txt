file(GLOB LUA_SOURCES "*.c")

idf_component_register(
        SRCS ${LUA_SOURCES}
        INCLUDE_DIRS "."
)
