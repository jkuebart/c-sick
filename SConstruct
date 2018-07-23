env = Environment(TARGET_ARCH = 'x86')
if "msvc" in env["TOOLS"]:
	#env.AppendUnique(CXXFLAGS=["/O2"])
	#env.AppendUnique(CXXFLAGS=["/DEBUG"])
	env.AppendUnique(CXXFLAGS=["/EHsc"])
elif "clangxx" in env["TOOLS"] or "g++" in env["TOOLS"]:
	env.AppendUnique(CCFLAGS=["-Wall", "-Wextra", "-g", "-pedantic", "-pthread"])
	env.AppendUnique(CFLAGS=["-std=gnu99"])
	env.AppendUnique(CXXFLAGS=["-std=c++14"])
	env.AppendUnique(LINKFLAGS=["-pthread"])

env.VariantDir('build', 'src')
env.AppendUnique(CPPDEFINES=["LUA_COMPAT_5_2"])
env.AppendUnique(CPPPATH=["src/lua/src"])

luasrc = Glob("build/lua/src/*.c", exclude="build/lua/src/lua*.c")
#env.Program("lua", ["build/lua/src/lua.c"] + luasrc)
#env.Program("luac", ["build/lua/src/luac.c"] + luasrc)
env.Program("program", ["build/main.cpp"] + luasrc)
