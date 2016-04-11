local _ = require 'shim'
local test = require 'min-test'

test('isEqual', function(t)
	local o = {a = 1}
	t.ok(_.isEqual(o, o))
	t.ok(_.isEqual(1, 1))
	t.ok(_.isEqual({}, {}))
	t.ok(not _.isEqual({a = 1}, {}))
	t.ok(not _.isEqual({}, {a = 1}))
	t.ok(_.isEqual({a = 1}, {a = 1}))
end)


-- after test _.isEqual, override lua assert
local assert = _.ok

test('isArray', function(t)

	local arr = {
		  _.isArray({1, 2, 3})
		, not _.isArray({1, 2, 3, w = 4})
		, _.isArray({[1] = 2, [2] = 3})
		, not _.isArray({[1] = 2, [2] = 3, [4] = 5})
		, _.isArray({})
		, _.isArray({
			{1, 2},
			{a = 2},
			3,
			{1, 2},
			{a = {
				a = 2
			}}
		})
	}
	
	_.each(arr, function(val)
		t.ok(val)
	end)

end)

test('each', function(t)
	local arr = {1, 0, 2, 4}
	local i = 0
	t.ok(_.each(arr, function(x)
		i = i + 1
		t.ok(x == arr[i])
	end) == arr)

	_.each({}, function()
		t.ok(false, 'never access')
	end)
end)

test('_each', function(t)
	local arr = {}
	_._each({1, 2, 3, 4}, function(x)
		if x > 2 then return false end
		table.insert(arr, x)
	end)
	t.ok(
		{arr, {1, 2}}
	)
end)

test('_each 2', function(t)
	local arr = {}
	_._each({1, 2, 3, 4}, function(x)
		table.insert(arr, x or 'error')
	end)
	t.ok({arr, {1, 2, 3, 4}})

	_._each({}, function()
		t.ok(false, 'never access')
	end)
end)

test('some', function(t)
	local flag = _.some({1, 2, 3}, function(x)
		return x > 2
	end)
	t.ok(flag)

	local flag = _.some({1, 2, 3}, function(x)
		return x > 4
	end)
	t.ok(not flag)
end)

test('every', function(t)
	local flag = _.every({1, 2, 3}, function(x)
		return x > 0
	end)
	t.ok(flag)

	local flag = _.every({1, 2, 3}, function(x)
		return x > 2
	end)
	t.ok(not flag)
end)

test('find', function(t)
	t.equal(_.find({1, 2, 3, 4, 5}, function(x)
		return x >= 3
	end), 3)

	t.equal(_.find({1, 2, 3, 4, 5}, function(x)
		return x >= 6
	end), nil)
end)

-- map
local arr = {1, 0, 2, 4}
assert(
	{_.map(arr, function(x)
		return x + 1
	end), {2, 1, 3, 5}}
)

-- includes
assert(
	  _.includes('qwert', 'rt')
	, not _.includes('qwert', 'tr')
	, not _.includes('qwert', nil)
	, not _.includes('qwert', 1024)
	, not _.includes('qwert')

	, _.includes({1, 2, 3, 4}, 3)
	, not _.includes({1, 2, 3, 4}, 5)
	, not _.includes({a = 1, b = 2}, 3)
)

-- extend
assert(
	  {_.extend({a = 1}, {b = 2}), {a = 1, b = 2}}
	, {_.extend(nil, {a = 1}), nil}
	, {_.extend({a = 1}, {a = 2}), {a = 2}}
	, {_.extend({a = 1}), {a = 1}}
	, {_.extend({a = 1}, {b = 2}, {c = 3}), {a = 1, b = 2, c = 3}}
)

-- filter
assert(
	{_.filter({1, 2, 3, 4, 5}, function(x)
		return x > 3
	end), {4, 5}}
)

-- indexOf
assert(
	  _.indexOf({11, 22, 33}, 22) == 2
	, _.indexOf({11, 22, 33}, 44) == nil
	--, _.indexOf({11, 22, 33, 33, 22, 11}, 22, 3) == 5
)
local i, j = _.indexOf('qwerty', 'we')
assert(i == 2)
assert(j == 3)

local index = _.indexOf('qwerty')
assert(not index)

-- lastIndexOf
assert(
	  _.lastIndexOf({11, 22, 33, 11}, 11) == 4
	, _.lastIndexOf({11, 22, 33, 11}, 0) == nil
	, _.lastIndexOf({11, 22, 33}, 11) == 1
)
local i, j = _.lastIndexOf('qweqwe', 'we')
assert(i == 5)
assert(j == 6)

-- trim
assert(
	  _.trim('  qq  ') == 'qq'
	, _.trim('   ') == ''
	, _.trim('') == ''
	, _.trim('  qq  ', 'right') == '  qq'
	, _.trim('  qq  ', 'left') == 'qq  '
	, _.trim(nil) == ''
)

-- flatten
assert(
	{
		_.flatten({1, {2}, {3, {{4}}}}),
		{1, 2, 3, {{4}}}
	}
)

-- uniq
assert(
	{
		_.uniq({1, 2, 3, 2, 1}),
		{1, 2, 3}
	}
)

local tbla = {a = 1}
local tblb = {b = 1}
assert(
	{
		_.uniq({tbla, tblb, 3, tbla, tblb, tbla}),
		{tbla, tblb, 3}
	}
)

-- union
assert(
	{
		_.sort(_.union({1, 2, 3}, {5, 2, 1, 4}, {2, 1})),
		{1, 2, 3, 4, 5}
	}
)

-- split
assert(
	{
		_.split('q,w,e,r', ','),
		{'q', 'w', 'e', 'r'}
	}
	, {
		_.split('qwer as', ''),
		{'q', 'w', 'e', 'r', ' ', 'a', 's'}
	}
	, {
		_.split('qwer', 'zz'),
		{'qwer'}
	}, {
		_.split('qq@ww@ee', '@'),
		{'qq', 'ww', 'ee'}
	}, {
		_.split(nil, ''),
		{}
	}, {
		_.split(0, '-'),
		{'0'}
	}, {
		_.split('127.0.0.1', '.', true),
		{'127', '0', '0', '1'}
	}
)

-- join
assert({
	_.join({1, 2, 3}, '-'),
	'1-2-3'
})
assert({
		_.join(nil, '-'),
		''
	}, {
	   _.join(2222, '-'),
	   ''
	}, {
		_.join({11, nil, '33'}, '-'),
		'11--33'
	}, {
		_.includes(_.join({11, {a = 1}, 22}, '-'), 'table'),
		true
	}, {
		_.join({11, 22}, nil),
		'1122'
	}
)

-- empty
assert(_.empty(false))
assert(_.empty(true))
assert(_.empty({}))
assert(_.empty(0))
assert(_.empty(1))
assert(_.empty(''))
assert(_.empty(print))
assert(not _.empty('0'))
assert(not _.empty('11111'))
assert(not _.empty({0}))
assert(not _.empty({1, 2}))
assert(not _.empty({a = 1}))

-- difference
assert(
	{
		_.difference({1, 2, 3, 4, 5}, {5, 2, 10}),
		{1, 3, 4}
	}
)

-- without
assert(
	{
		_.without({1, 4, 3, nil, 0, ''}, nil, 0, ''),
		{1, 4, 3}
	}
)

-- push
assert(
	{
		_.push({1, 2, 3}, 4, 5),
		{1, 2, 3, 4, 5}
	},
	{
		_.push(nil, 4, 5),
		nil
	}
)

-- sub
assert(
	{
		_.sub('qwer', 2, 3),
		'we'
	},
	{
		_.sub(nil, 2, 3),
		''
	}
)

-- reduce
assert(
	{
		_.reduce({}, function() end),
		nil
	},
	{
		_.reduce({}, function() end, 2),
		2
	},
	{
		_.reduce({1, 2, 3, 4}, function(ret, k)
			return ret + k
		end, 0),
		10
	}
)

-- only
assert(
	{
		_.only({
			a = 1,
			b = 2,
			c = 3
		}, {'a', 'b'}),
		{a = 1, b = 2}
	},
	{
		_.only({
			a = 1,
			b = 2,
			c = 3,
			d = 4
		}, 'a c  d'),
		{
			a = 1,
			c = 3,
			d = 4
		}
	}
)

-- keys
assert(
	{
		_.sort(_.keys({
			a = 1,
			b = 2,
			c = 3
		})),
		_.sort({'a', 'b', 'c'})
	}
)

-- values
assert(
	{
		_.sort(_.values({
			a = 1,
			b = 2,
			c = 3
		})),
		_.sort({1, 2, 3})
	}
)

-- forIn
local forInObj = {a = 1, b = 2}
local forInArr = {}
_.forIn(forInObj, function(val, key, obj)
	assert(forInObj == obj)
	assert(val == obj[key])
	_.push(forInArr, val)
end)
assert({
	_.sort(forInArr),
	_.sort({1, 2})
})

_.forIn(nil, function()
	assert(false)
end)

_.forIn(2, function()
	assert(false)
end)

-- mapKeys
assert(
	{
		_.mapKeys({a = 1, b = 2}, function(val, key)
			return key .. val
		end),
		{a1 = 1, b2 = 2}
	}
)

-- mapValues
assert(
	{
		_.mapValues({a = 1, b = 2}, function(val, key)
			return val * 3
		end),
		{a = 3, b = 6}
	}
)

-- get
assert(
	{
		_.get({a = {{b = {c = 3}}}}, {'a', 1, 'b', 'c'}),
		3
	},
	{
		_.get({a = 1}, {}),
		nil
	},
	{
		_.get({a = 1}, {'b', 'c'}),
		nil
	},
	{
		_.get(3, {1, 2}),
		nil
	},
	{
		_.get({a = 1}, {'a', 'b'}),
		nil
	}
)

-- invoke
assert(
	{
		_.invoke({'1', '2', '3'}, tonumber),
		{1, 2, 3}
	},
	{
		_.invoke({1, 2, 3}),
		{nil, nil, nil}
	},
	{
		_.invoke({{3, 2, 1}, {4, 6, 5}}, _.sort),
		{{1, 2, 3}, {4, 5, 6}}
	}
)

-- wrapper
local arr = _({1, 2, 3}):map(function(x)
	return x * 2
end)
assert({arr, {2, 4, 6}})


-- chain
local arr = _({1, 0, 2, 4})
	:chain()
	:sort()
	:map(function(x) return x * 2 end)
	:filter(function(x) return x < 6 end)
	:value()
assert({arr, {0, 2, 4}})

-- chain direct
local function double(val)
	return val * 2
end
local chain1 = _.chain({1, 2, 3}):map(double):value()
local chain2 = _.chain({2, 3, 4}):map(double):value()
assert({chain1, {2, 4, 6}})
assert({chain2, {4, 6, 8}})

-- not mixed
local chain3 = _({1, 1, 2}):chain()
local chain4 = _({2, 2, 1}):chain()
assert({chain3:map(double):value(), {2, 2, 4}})
assert({chain4:map(double):value(), {4, 4, 2}})

local chain5 = _({1, 1, 2}):chain():map(double)
local chain6 = _({2, 2, 1}):chain():map(double)
assert({chain5:value(), {2, 2, 4}})
assert({chain6:value(), {4, 4, 2}})

-- string chain never crash
assert({_.chain():map(double):value(), {}})
assert({_.chain(3333):map(double):value(), {}})

assert(_.chain():split(''):value(), {})

local dumpedString1 = _.dump(123, true, nil, '321')
assert(dumpedString1 == '123 true nil "321"')
-- local dumpedString2 = _.dump({1, nil, true, '2'})
local dumpedString2 = _.dump({1, 2, 3, 4})
assert(dumpedString2 == '[1, 2, 3, 4]')

--[[
print(_.dump({
	a = 1,
	b = {
		a = 1,
		b = {2, 3, 4}
	}
}))
]]
print('all tests ok!')
