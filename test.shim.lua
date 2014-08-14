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
    , _.isArray({
        {1, 2},
        {a = 2},
        3,
        {1, 2},
        {a = {
            a = 2
        }}
    })
)

-- each
local arr = {1, 0, 2, 4}
local i = 0
assert(_.each(arr, function(x)
    i = i + 1
    assert(x == arr[i])
end) == arr)
local str = '1024'
local i = 0
assert(_.each(str, function(x)
    i = i + 1
    assert(x == str[i])
end) == str)

-- _each
local arr = {}
_._each({1, 2, 3, 4}, function(x)
    if x > 2 then return false end
    table.insert(arr, x)
end)
assert(
    {arr, {1, 2}}
)

-- some
local flag = _.some({1, 2, 3}, function(x)
    return x > 2
end)
assert(flag)

local flag = _.some({1, 2, 3}, function(x)
    return x > 4
end)
assert(not flag)

-- every
local flag = _.every({1, 2, 3}, function(x)
    return x > 0
end)
assert(flag)

local flag = _.every({1, 2, 3}, function(x)
    return x > 2
end)
assert(not flag)

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
    , _.trim(nil) == nil
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
    }, {
        _.split(nil, ''),
        nil
    }
)

-- empty
assert(_.empty(false))
assert(not _.empty(true))
assert(_.empty({}))
assert(_.empty(0))
assert(not _.empty('0'))
assert(not _.empty(1))
assert(_.empty(''))

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
        nil
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
        }, 'a c     d'),
        {
            a = 1,
            c = 3,
            d = 4
        }
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
