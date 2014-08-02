Shim.lua
===

[![build status][travis-image]][travis-url]

A clean utility library, support for basic and useful function, make it easy to write lua code neatly

`Shim.lua` was deeply inspired by [Underscore.js](https://github.com/jashkenas/underscore), [Lodash.js](https://github.com/lodash/lodash), [Moses](https://github.com/Yonaba/Moses)

Install
---

```bash
$ wget --no-check-certificate https://raw.githubusercontent.com/chunpu/Shim/master/shim.lua
```

Usage
---

```lua
local _ = require 'shim'

_.isArray({1, 2, 3}) -- => true
_.isEqual({a = 1, b = 2}, {a = 1, b = 2}) -- => true
```

basic wrapper for oo style

```lua
_({1, 2, 3}):map(function(x) return x * 2 end)
-- => {2, 4, 6}
```

chain support

```lua
_({1, 0, 2, 4})
    :chain()
    :sort()
    :map(function(x) return x * 2 end)
    :filter(function(x) return x < 6 end)
    :value()
-- => {0, 2, 4}
```

pretty print

```lua
print(_.dump({
    a = 1,
    b = {
        a = 1,
        b = {2, 3, 4}
    }
}))
--[[ =>
{
    'b': {
        'b': [2, 3, 4],
        'a': 1
    },
    'a': 1
}
]]
```

Api
---

TODO %>_<%


License
---

Shim.lua is under MIT

Copyright (c) 2012-2014 [Chunpu](https://github.com/chunpu)

[travis-image]: https://img.shields.io/travis/chunpu/Shim.svg?style=flat
[travis-url]: https://travis-ci.org/chunpu/Shim
