local _ = require 'util'

-- isEqual
local o = {a = 1}
assert(_.isEqual(o, o))
assert(_.isEqual(1, 1))
assert(_.isEqual({}, {}))
assert(not _.isEqual({a = 1}, {}))
assert(not _.isEqual({}, {a = 1}))
assert(_.isEqual({a = 1}, {a = 1}))

-- isArray
assert(_.isArray({1, 2, 3}))
assert(not _.isArray({1, 2, 3, w = 4}))
assert(_.isArray({[1] = 2, [2] = 3}))
assert(not _.isArray({[1] = 2, [2] = 3, [4] = 5}))
assert(_.isArray({}))

-- each
local arr = {1, 0, 2, 4}
local i = 0
assert(_.each(arr, function(x)
    i = i + 1
    assert(x == arr[i])
end) == arr)

-- map
local arr = {1, 0, 2, 4}
assert(_.isEqual(_.map(arr, function(x)
    return x + 1
end), {2, 1, 3, 5}))

-- has
assert(_.has('qwert', 'rt'))
assert(not _.has('qwert', 'tr'))

assert(_.has({1, 2, 3, 4}, 3))
assert(not _.has({1, 2, 3, 4}, 5))

assert(_.has({a = 1}, 1))
assert(not _.has({a = 1, b = 2}, 3))

-- extend
assert(_.isEqual(_.extend({a = 1}, {b = 2}), {a = 1, b = 2}))
assert(_.isEqual(_.extend({a = 1}, {a = 2}), {a = 2}))
assert(_.isEqual(_.extend({a = 1}), {a = 1}))
assert(_.isEqual(_.extend({a = 1}, {b = 2}, {c = 3}), {a = 1, b = 2, c = 3}))

-- filter
assert(_.isEqual(_.filter({1, 2, 3, 4, 5}, function(x)
    return x > 3
end), {4, 5}))

-- wrapper
local arr = _({1, 2, 3}):map(function(x)
    return x * 2
end)
assert(_.isEqual(arr, {2, 4, 6}))

local arr = _({1, 2, 3}):chain():map(function(x)
    return x * 2
end):filter(function(x)
    return x > 3
end):value()
assert(_.isEqual(arr, {4, 6}))

print("all tests ok!")
