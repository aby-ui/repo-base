local ADDONNAME, ADDONSELF = ...

local require = ADDONSELF.luapb.require

local LUAPB_VER = 101000

local mod = require"standardmod"

local function new_backend(name, compile, encode, decode)
	local backend = {compile = compile, encode = encode, decode = decode, cache = {}}
	return backend
end

local backend = new_backend(name, mod.compile, mod.encode, mod.decode)

local function load_proto_ast(ast)

	-- compile AST tree into Message definitions
	local proto = backend.compile(ast)

	return proto
end

ADDONSELF.luapb.load_proto_ast = load_proto_ast

if ADDONNAME == "lua-pb" and LibStub then
	local _M = LibStub:NewLibrary("luapb", LUAPB_VER)
	_M.load_proto_ast = load_proto_ast
end
