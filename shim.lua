local _ = {}

local push = table.insert

-- is

local function isTable(val)
	return 'table' == type(val)
end

local function isNumber(val)
	return 'number' == type(val)
end

local function isString(val)
	return 'string' == type(val)
end

local function isFunction(val)
	return 'function' == type(val)
end

local function isBoolean(val)
	return 'boolean' == type(val)
end

local function isNil(val)
	return nil == val
end

_.isTable = isTable
_.isNumber = isNumber
_.isString = isString
_.isFunction = isFunction
_.isBoolean = isBoolean
_.isNil = isNil

local function hasNgx()
	-- https://github.com/openresty/lua-nginx-module
	if not isNil(ngx) then
		return true
	end
	return false
end

_.hasNgx = hasNgx()


-- list start

-- Basic Util

-- basic each
local function each(arr, fn)
	if isTable(arr) then
		local len = #arr
		for i = 1, len do
			if false == fn(arr[i], i, arr) then
				return
			end
		end
	end
end

-- basic for in
local function forIn(obj, fn)
	if isTable(obj) then
		for key, val in pairs(obj) do
			if false == fn(val, key, obj) then
				return
			end
		end
	end
end

local function tostr(val)
	if not isString(val) then
		if nil ~= val then
			val = tostring(val)
		end
	end
	return val or ''
end

local function findIndex(arr, fn)
	local ret
	each(arr, function(val, i, arr)
		if fn(val, i, arr) then
			ret = i
			return false
		end
	end)
	return ret
end

_._each = each
_.forIn = forIn
_.toString = tostr
_.findIndex = findIndex

-- Iteration

function _.len(list)
	if isString(list) or isTable(list) then
		return #list
	end
	return 0
end

function _.slice(list, first, last)
	-- return [first, last)
	local ret = {}
	local len = _.len(list)
	if len >= 0 then
		first = first or 0 + 1
		last = last or len + 1
		if isString(list) then
			ret = list:sub(first, last - 1)
		elseif isTable(list) then
			for i = first, last - 1 do
				push(ret, list[i])
			end
		end
	end
	return ret
end

function _.isArray(t)
	if isTable(t) then
		local i = 0
		for _ in pairs(t) do
			i = i + 1
			if t[i] == nil then
				return false
			end
		end
		return true
	end
	return false
end

function _.negate(fn)
	return function(...)
		return not fn(...)
	end
end

function _.each(arr, fn)
	each(arr, function(...)
		fn(...)
	end)
	return arr
end

function _.every(arr, fn)
	return nil == findIndex(arr, _.negate(fn))
end

function _.some(arr, fn)
	return nil ~= findIndex(arr, fn)
end

function _.find(arr, fn)
	local i = findIndex(arr, fn)
	if i then
		return arr[i]
	end
end

function _.map(arr, fn)
	local ret = {}
	each(arr, function(x, i, arr)
		ret[i] = fn(x, i, arr)
	end)
	return ret
end

function _.isEqual(a, b)
	-- won't compare metatable
	if a == b then return true end
	if isTable(a) and isTable(b) then
		for k, v in pairs(a) do
			if not _.isEqual(a[k], b[k]) then
				return false
			end
		end
		for k in pairs(b) do
			if a[k] == nil then
				return false
			end
		end
		return true
	else
		return a == b
	end
end

_.isDeepEqual = _.isEqual

function _.includes(val, sub)
	return nil ~= _.indexOf(val, sub)
end

function _.sub(s, i, j)
	-- TODO add list support
	return string.sub(tostr(s), i, j)
end

function _.flatten(arrs)
	local ret = {}
	each(arrs, function(arr)
		if isTable(arr) then
			each(arr, function(x)
				push(ret, x)
			end)
		else
			push(ret, arr)
		end
	end)
	return ret
end

function _.push(arr, ...)
	if not isTable(arr) then return arr end
	each({...}, function(x, i)
		push(arr, x)
	end)
	return arr
end

function _.uniq(arr)
	local ret = {}
	each(arr, function(x)
		if not _.includes(ret, x) then
			push(ret, x)
		end
	end)
	return ret
end

function _.compact(arr)
	return _.filter(arr, _.identity)
end

function _.identity(val)
	return val
end

function _.union(...)
	return _.uniq(_.flatten({...}))
end

function _.extend(dst, ...)
	if isTable(dst) then
		local src = {...}
		each(src, function(obj)
			forIn(obj, function(val, key)
				dst[key] = val
			end)
		end)
	end
	return dst
end

function _.sort(t, fn)
	if isTable(t) then
		table.sort(t, fn)
	end
	return t
end

function _.filter(arr, fn)
	local ret = {}
	each(arr, function(x)
		if fn(x) then
			push(ret, x)
		end
	end)
	return ret
end

function _.indexOf(arr, sub, from, isPlain)
	-- deprecated from
	if isString(arr) then
		sub = tostr(sub)
		if '' ~= sub then
			return string.find(arr, sub, from, isPlain)
		end
	end
	return findIndex(arr, function(item)
		return item == sub
	end)
end

function _.lastIndexOf(arr, val, from, isPlain)
	local tp = type(arr)
	if tp == 'string' then
		return string.find(arr, val .. '$', from, isPlain)
	end
	if tp == 'table' then
		local i = #arr
		while i ~= 0 do
			if arr[i] == val then
				return i
			end
			i = i - 1
		end
	end
end

function _.join(arr, sep)
	return table.concat(_.map(arr, tostr), tostr(sep))
end

function _.empty(x)
	local tp = type(x)
	if 'string' == tp then
		return 0 == #x
	elseif 'table' == tp then
		local len = 0
		for k, v in pairs(x) do
			len = len + 1
		end
		return len == 0
	end
	return true
end

function _.difference(arr, other)
	local ret = {}
	each(arr, function(x)
		if not _.includes(other, x) then
			push(ret, x)
		end
	end)
	return ret
end

function _.without(arr, ...)
	return _.difference(arr, {...})
end

function _.reduce(arr, fn, prev)
	each(arr, function(x, i)
		prev = fn(prev, x, i, arr)
	end)
	return prev
end

function _.keys(obj)
	local ret = {}
	forIn(obj, function(val, key)
		push(ret, key)
	end)
	return ret
end

function _.values(obj)
	local ret = {}
	forIn(obj, function(val)
		push(ret, val)
	end)
	return ret
end

function _.mapKeys(obj, fn)
	local ret = {}
	forIn(obj, function(val, key)
		local newKey = fn(val, key, obj)
		if newKey then ret[newKey] = val end
	end)
	return ret
end

function _.mapValues(obj, fn)
	local ret = {}
	forIn(obj, function(val, key)
		ret[key] = fn(val, key, obj)
	end)
	return ret
end

local function toPath(arr)
	local path = {}
	if isTable(arr) then
		path = arr
	elseif isString(arr) then
		-- 不支持括号 path
		path = _.split(arr, '.', true)
	end
	return path
end

function _.get(obj, path)
	path = toPath(path)
	if #path > 0 then
		local flag = _.every(path, function(key)
			if isTable(obj) and nil ~= obj[key] then
				obj = obj[key]
				return true
			end
		end)
		if flag then return obj end
	end
end

function _.has(obj, path)
	-- TODO
end

function _.set(obj, path)
	-- TODO
end

function _.invert(obj)
	local ret = {}
	forIn(obj, function(val, key)
		ret[val] = key
	end)
	return ret
end

function _.only(obj, keys)
	obj = obj or {}
	if isString(keys) then
		keys = _.split(keys, ' +')
	end
	return _.reduce(keys, function(ret, key)
		if nil ~= obj[key] then
			ret[key] = obj[key]
		end
		return ret
	end, {})
end

function _.invoke(arr, fn)
	return _.map(arr, function(x)
		if isFunction(fn) then
			return fn(x)
		end
	end)
end

-- list end

-- string start

function _.split(str, sep, isPlain)
	str = tostr(str)
	local from = 1
	local ret = {}
	local len = #str
	while true do
		local i, j = str:find(sep, from, isPlain)
		if i then
			if i > len then break end
			if j < i then
				-- sep == ''
				j = i
				i = i + 1
			end
			push(ret, str:sub(from, i - 1))
			from = j + 1
		else
			push(ret, str:sub(from, len))
			break
		end
	end
	return ret
end

function _.trim(s, where)
	s = tostr(s)
	local i = 1
	local j = #s
	if 'left' ~= where then
		-- match right space
		local a, b = _.lastIndexOf(s, '%s+')
		if b == j then
			j = a - 1
		end
	end
	if 'right' ~= where then
		-- match left space
		local a, b = _.indexOf(s, '%s+')
		if a == 1 then
			i = b + 1
		end
	end
	return _.sub(s, i, j)
end

function _.startsWith(str, val)
	-- never support pattern
	return 0 + 1 == _.indexOf(str, val, 1, true)
end

function _.endsWith(str, val)
	return val == _.slice(str, _.len(str) - _.len(val) + 1)
end

-- string end

-- function start

function _.before(n, fn)
	return function(...)
		if n > 1 then
			n = n - 1
			return fn(...)
		end
	end
end

function _.once(fn)
	return _.before(2, fn)
end

-- function end

-- other start

function _.now()
	local now
	if _.hasNgx then
		now = ngx.now()
	else
		now = os.time()
	end
	return now * 1000 -- return ms
end

function _.chain(val)
	return _(val):chain()
end

function _.assertEqual(actual, expect, level)
	level = level or 2
	if not _.isEqual(actual, expect) then
		local msg = 'AssertionError: ' .. _.dump(actual) .. ' == ' .. _.dump(expect)
		error(msg, level)
	end
end

function _.ok(...)
	local arr = {...}
	each(arr, function(x)
		if isTable(x) then
			_.assertEqual(x[1], x[2], 5)
		else
			_.assertEqual(x, true, 5)
		end
	end)
end

function call(_, val)
	local ret = {
		wrap = val
	}
	setmetatable(ret, {
		__index = function(ret, k)
			if k == 'chain' then
				return function()
					ret._chain = true
					return ret
				end
			elseif k == 'value' then
				return function()
					return ret.wrap
				end
			elseif type(_[k]) == 'function' then
				return function(ret, ...)
					local v = _[k](ret.wrap, ...)
					if ret._chain then
						ret.wrap = v
						return ret
					else
						return v
					end
				end
			end
		end
	})
	return ret
end

local _dump, _dumpTable

function _dumpTable(o, lastIndent)
	if type(lastIndent) ~= 'string' then
		lastIndent = ''
	end
	local indent = '	' .. lastIndent
	if #indent > 4 * 7 then
		return '[Nested]' -- may be nested, default is 7
	end
	local ret = '{\n'
	local arr = {}
	for k, v in pairs(o) do
		push(arr, indent .. _dump(k) .. ': ' .. _dump(v, indent))
	end
	ret = ret .. table.concat(arr, ',\n') .. '\n' .. lastIndent .. '}'
	return ret
end

-- TODO multi args
function _dump(v, indent)
	local t = type(v)
	if nil == v or 'number' == t or 'boolean' == t then
		return tostring(v)
	elseif t == 'string' then
		return '"' .. v .. '"' -- same as chrome
	elseif t == 'table' then
		if _.isArray(v) then
			return '[' .. _.join(_.map(v, function(x)
				return _dump(x, indent)
			end) , ', ') .. ']'
		else
			return _dumpTable(v, indent)
		end
	end
	return '[' .. t .. ']'
end

-- TODO other function

_.dump = function(...)
	return _.join(_.map({...}, function(val)
		return _dump(val)
	end), ' ')
end

-- other end

setmetatable(_, {__call = call})

return _
