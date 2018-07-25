
#pragma once

#include <string>
#include "lua/src/lua.hpp"

using namespace std;

// utilities for lua stack manipulation
struct LuaStackPtr{
	LuaStackPtr(const int idx_):idx(idx_){}
	const int idx;
};

struct StringPtr{
	StringPtr(const char* c_, const size_t len_):c(c_),len(len_){}
	const char* c;
	const size_t len;
};

void lua_push(lua_State *L, const int value){
	lua_pushinteger(L, value);
}
void lua_push(lua_State *L, const string value){
	lua_pushstring(L, value.c_str());
}
void lua_push(lua_State *L, const char *value){
	lua_pushstring(L, value);
}
void lua_push(lua_State *L, const StringPtr value){
	lua_pushlstring(L, value.c, value.len);
}
void lua_push(lua_State *L, const LuaStackPtr value){
	lua_pushvalue(L, value.idx);
}

void lua_closefield(lua_State *L){
	lua_settable(L, -3);
}

template<typename TKey, typename TVal>
void lua_pushfield(lua_State *L, const TKey key, const TVal value){
	lua_push(L, key);
	lua_push(L, value);
	lua_closefield(L);
}

template<typename TKey>
void lua_opensubtable(lua_State *L, const TKey key){
	lua_push(L, key);
	lua_newtable(L);
}

