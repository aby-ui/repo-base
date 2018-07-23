
local _require = LibStub:GetLibrary('pblua.require')
local require = _require.require

local _M = LibStub:NewLibrary("pblua", 1)

local mod = require"standardmod"
local name = 'pblua'


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

_M.load_proto_ast = load_proto_ast
