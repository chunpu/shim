local _ = require 'shim'

local queue = {}

local function ok(val, msg)
	assert(true == val, msg)
end

local function equal(val, expected, msg)
	if val ~= expected then
		assert(false, msg or tostring(val) .. ' = ' .. tostring(expected))
	end
end

local function deepEqual(val, expected, msg)
	local ok = _.isDeepEqual(val, expected)
	if not ok then
		assert(false, msg or tostring(val) .. ' = ' .. tostring(expected))
	end
end

local function getT()
	return {
		ok = ok,
		equal = equal,
		deepEqual = deepEqual
	}
end

local function report(ok, title, msg)
	if ok then
		print('pass ' .. title)
	else
		print('fail ' .. title .. ' ' .. msg)
	end
end

local function execTest(title, func)
	local t = getT()
	local ok, ret = pcall(func, t)
	if ok then
		report(ok, title)
	else
		local info = debug.getinfo(1)
		report(ok, title, info.short_src .. ':' .. info.currentline)
	end
end

local function test(title, func)
	if _.isFunction(title) then
		return test('untitled', title)
	end
	
	if _.isFunction(func) then
		execTest(title, func)
	end
end

return test
