local _ = require 'shim'

-- isEqual
local o = {a = 1}
assert(_.isEqual(o, o))
assert(_.isEqual(1, 1))
assert(_.isEqual({}, {}))
assert(not _.isEqual({a = 1}, {}))
assert(not _.isEqual({}, {a = 1}))
assert(_.isEqual({a = 1}, {a = 1}))


-- after test _.isEqual, override lua assert
local assert = _.ok

-- isArray
assert(
      _.isArray({1, 2, 3})
    , not _.isArray({1, 2, 3, w = 4})
    , _.isArray({[1] = 2, [2] = 3})
    , not _.isArray({[1] = 2, [2] = 3, [4] = 5})
    , _.isArray({})
)

-- each
local arr = {1, 0, 2, 4}
local i = 0
assert(_.each(arr, function(x)
    i = i + 1
    assert(x == arr[i])
end) == arr)

-- map
local arr = {1, 0, 2, 4}
assert(
    {_.map(arr, function(x)
        return x + 1
    end), {2, 1, 3, 5}}
)

-- has
assert(
      _.has('qwert', 'rt')
    , not _.has('qwert', 'tr')

    , _.has({1, 2, 3, 4}, 3)
    , not _.has({1, 2, 3, 4}, 5)

    , _.has({a = 1}, 1)
    , not _.has({a = 1, b = 2}, 3)
)

-- extend
assert(
      {_.extend({a = 1}, {b = 2}), {a = 1, b = 2}}
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
    , _.indexOf({11, 22, 33, 33, 22, 11}, 22, 3) == 5
)
local i, j = _.indexOf('qwerty', 'we')
assert(i == 2)
assert(j == 3)

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
)

-- flatten
assert(
    {
        _.flatten({1, {2, {3, {4}}}}),
        {1, 2, 3, 4}
    }
)

-- uniq
assert(
    {
        _.uniq({1, 2, 3, 2, 1}),
        {1, 2, 3}
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
