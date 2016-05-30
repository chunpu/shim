local _ = require 'shim'
local test = require 'min-test'

local function assertList(arr, t)
	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end

test('isEqual', function(t)
	local o = {a = 1}
	t.ok(_.isEqual(o, o))
	t.ok(_.isEqual(1, 1))
	t.ok(_.isEqual({}, {}))
	t.ok(not _.isEqual({a = 1}, {}))
	t.ok(not _.isEqual({}, {a = 1}))
	t.ok(_.isEqual({a = 1}, {a = 1}))
end)

test('slice', function(t)
	local str = 'abcde'
	t.equal(_.slice(str), str)
	t.equal(_.slice(str, 1, _.len(str) + 1), str)
	t.equal(_.slice(str, 2), 'bcde')
	t.equal(_.slice(str, 2, 3), 'b')
	t.equal(_.slice(str, 2, 4), 'bc')
	t.equal(_.slice(str, 2, 2), '')

	local arr = {2, 3, 4, 5}
	t.deepEqual(_.slice(arr), {2, 3, 4, 5})
	t.deepEqual(_.slice(arr, 1, 5), {2, 3, 4, 5})
	t.deepEqual(_.slice(arr, 2), {3, 4, 5})
	t.deepEqual(_.slice(arr, 2, 3), {3})
	t.deepEqual(_.slice(arr, 2, 2), {})
end)

test('startsWith', function(t)
	t.ok(_.startsWith('abcd', 'a'))
	t.ok(_.startsWith('abcd', 'abcd'))
	t.ok(not _.startsWith('abcd', nil))
	t.ok(not _.startsWith('abcd', 'dc'))
	t.ok(not _.startsWith('abcd', 'c'))
	t.ok(_.startsWith('http%3Axxxx', 'http%3A'))
end)

test('endsWith', function(t)
	t.ok(_.endsWith('abcd', 'd'))
	t.ok(_.endsWith('abcd', 'abcd'))
	t.ok(_.endsWith('abcdabc', 'abc'))
	t.ok(not _.endsWith('abcd', nil))
	t.ok(not _.endsWith('abcd', 'dc'))
	t.ok(not _.endsWith('abcd', 'c'))
	t.ok(not _.endsWith('abcd', 'abcdeabc'))
end)

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
	t.deepEqual(arr, {1, 2})
end)

test('_each 2', function(t)
	local arr = {}
	_._each({1, 2, 3, 4}, function(x)
		table.insert(arr, x or 'error')
	end)
	t.deepEqual(arr, {1, 2, 3, 4})

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

test('map', function(t)
	local arr = {1, 0, 2, 4}
	t.deepEqual(_.map(arr, function(x)
		return x + 1
	end), {2, 1, 3, 5})
end)

test('includes', function(t)
	local arr = {
		  _.includes('qwert', 'rt')
		, not _.includes('qwert', 'tr')
		, not _.includes('qwert', nil)
		, not _.includes('qwert', 1024)
		, not _.includes('qwert')

		, _.includes({1, 2, 3, 4}, 3)
		, not _.includes({1, 2, 3, 4}, 5)
		, not _.includes({a = 1, b = 2}, 3)
	}

	_.each(arr, function(val)
		t.ok(val)
	end)
end)

test('extend', function(t)
	local arr = {
		  {_.extend({a = 1}, {b = 2}), {a = 1, b = 2}}
		, {_.extend(nil, {a = 1}), nil}
		, {_.extend({a = 1}, {a = 2}), {a = 2}}
		, {_.extend({a = 1}), {a = 1}}
		, {_.extend({a = 1}, {b = 2}, {c = 3}), {a = 1, b = 2, c = 3}}
	}

	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('filter', function(t)
	t.deepEqual(_.filter({1, 2, 3, 4, 5}, function(x)
		return x > 3
	end), {4, 5})
end)

test('indexOf', function(t)
	local arr = {
		  _.indexOf({11, 22, 33}, 22) == 2
		, _.indexOf({11, 22, 33}, 44) == nil
		--, _.indexOf({11, 22, 33, 33, 22, 11}, 22, 3) == 5
	}

	_.each(arr, function(val)
		t.ok(val)
	end)

	local i, j = _.indexOf('qwerty', 'we')
	t.ok(i == 2)
	t.ok(j == 3)

	local index = _.indexOf('qwerty')
	t.ok(not index)
end)

test('lastIndexOf', function(t)
	local arr = {
		  _.lastIndexOf({11, 22, 33, 11}, 11) == 4
		, _.lastIndexOf({11, 22, 33, 11}, 0) == nil
		, _.lastIndexOf({11, 22, 33}, 11) == 1
	}
	_.each(arr, function(val)
		t.ok(val)
	end)

	local i, j = _.lastIndexOf('qweqwe', 'we')
	t.ok(i == 5)
	t.ok(j == 6)
end)

test('trim', function(t)
	local arr = {
		  _.trim('  qq  ') == 'qq'
		, _.trim('   ') == ''
		, _.trim('') == ''
		, _.trim('  qq  ', 'right') == '  qq'
		, _.trim('  qq  ', 'left') == 'qq  '
		, _.trim(nil) == ''
	}

	_.each(arr, function(val)
		t.ok(val)
	end)
end)

test('flatten', function(t)
	t.deepEqual(_.flatten({1, {2}, {3, {{4}}}}), {1, 2, 3, {{4}}})
end)

test('uniq', function(t)
	t.deepEqual(_.uniq({1, 2, 3, 2, 1}), {1, 2, 3})

	local tbla = {a = 1}
	local tblb = {b = 1}
	t.deepEqual(_.uniq({tbla, tblb, 3, tbla, tblb, tbla}), {tbla, tblb, 3})
end)

test('union', function(t)
	t.deepEqual(_.sort(_.union({1, 2, 3}, {5, 2, 1, 4}, {2, 1})), {1, 2, 3, 4, 5})
end)

test('split', function(t)
	local arr = {
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
	}

	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('join', function(t)
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
end)

test('empty', function(t)
	local arr = {
		  _.empty(false)
		, _.empty(true)
		, _.empty({})
		, _.empty(0)
		, _.empty(1)
		, _.empty('')
		, _.empty(print)
		, not _.empty('0')
		, not _.empty('11111')
		, not _.empty({0})
		, not _.empty({1, 2})
		, not _.empty({a = 1})
	}
	_.each(arr, function(val)
		t.ok(val)
	end)

end)

test('difference', function(t)
	t.deepEqual(_.difference({1, 2, 3, 4, 5}, {5, 2, 10}), {1, 3, 4})
end)

test('without', function(t)
	t.deepEqual(_.without({1, 4, 3, nil, 0, ''}, nil, 0, ''), {1, 4, 3})
end)

test('push', function(t)
	local arr = {
		{
			_.push({1, 2, 3}, 4, 5),
			{1, 2, 3, 4, 5}
		},
		{
			_.push(nil, 4, 5),
			nil
		}
	}
	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('sub', function(t)
	local arr = {
		{
			_.sub('qwer', 2, 3),
			'we'
		},
		{
			_.sub(nil, 2, 3),
			''
		}
	}
	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('reduce', function(t)
	local arr = {
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
	}

	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('only', function(t)
	local arr = {
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
	}

	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('keys', function(t)
	local arr = {
		{
			_.sort(_.keys({
				a = 1,
				b = 2,
				c = 3
			})),
			_.sort({'a', 'b', 'c'})
		}
	}

	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('values', function(t)
	local arr = {
		{
			_.sort(_.values({
				a = 1,
				b = 2,
				c = 3
			})),
			_.sort({1, 2, 3})
		}
	}

	_.each(arr, function(arr)
		t.deepEqual(arr[1], arr[2])
	end)
end)

test('forIn', function(t)
	local forInObj = {a = 1, b = 2}
	local forInArr = {}

	_.forIn(forInObj, function(val, key, obj)
		t.ok(forInObj == obj)
		t.ok(val == obj[key])
		_.push(forInArr, val)
	end)

	t.deepEqual(_.sort(forInArr), _.sort({1, 2}))

	_.forIn(nil, function()
		t.ok(false)
	end)

	_.forIn(2, function()
		t.ok(false)
	end)
end)

test('mapKeys', function(t)
	local arr = {
		{
			_.mapKeys({a = 1, b = 2}, function(val, key)
				return key .. val
			end),
			{a1 = 1, b2 = 2}
		}
	}
	assertList(arr, t)
end)

test('mapValues', function(t)
	local arr = {
		{
			_.mapValues({a = 1, b = 2}, function(val, key)
				return val * 3
			end),
			{a = 3, b = 6}
		}
	}
	assertList(arr, t)
end)

test('get', function(t)
	local arr = {
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
	}
	assertList(arr, t)
end)

test('invoke', function(t)
	local arr = {
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
	}
	assertList(arr, t)
end)

test('wrapper', function(t)
	local arr = _({1, 2, 3}):map(function(x)
		return x * 2
	end)
	t.deepEqual(arr, {2, 4, 6})
end)


test('chain', function(t)
	local arr = _({1, 0, 2, 4})
		:chain()
		:sort()
		:map(function(x) return x * 2 end)
		:filter(function(x) return x < 6 end)
		:value()
	t.deepEqual(arr, {0, 2, 4})

	-- chain direct
	local function double(val)
		return val * 2
	end
	local chain1 = _.chain({1, 2, 3}):map(double):value()
	local chain2 = _.chain({2, 3, 4}):map(double):value()
	t.deepEqual(chain1, {2, 4, 6})
	t.deepEqual(chain2, {4, 6, 8})

	-- not mixed
	local chain3 = _({1, 1, 2}):chain()
	local chain4 = _({2, 2, 1}):chain()
	t.deepEqual(chain3:map(double):value(), {2, 2, 4})
	t.deepEqual(chain4:map(double):value(), {4, 4, 2})

	local chain5 = _({1, 1, 2}):chain():map(double)
	local chain6 = _({2, 2, 1}):chain():map(double)
	t.deepEqual(chain5:value(), {2, 2, 4})
	t.deepEqual(chain6:value(), {4, 4, 2})

	-- string chain never crash
	t.deepEqual(_.chain():map(double):value(), {})
	t.deepEqual(_.chain(3333):map(double):value(), {})

	t.deepEqual(_.chain():split(''):value(), {})
end)

test('dump', function(t)
	local dumpedString1 = _.dump(123, true, nil, '321')
	t.equal(dumpedString1, '123 true nil "321"')
	-- local dumpedString2 = _.dump({1, nil, true, '2'})
	local dumpedString2 = _.dump({1, 2, 3, 4})
	t.equal(dumpedString2, '[1, 2, 3, 4]')

	--[[
	print(_.dump({
		a = 1,
		b = {
			a = 1,
			b = {2, 3, 4}
		}
	}))
	]]
end)

test('now', function(t)
	local now = _.now()
	t.ok(now > 1462269341287 / 2)
	t.ok(now < 1462269341287 * 2)
end)

print('all tests ok!')
