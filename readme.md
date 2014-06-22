Shim.lua
===

A clean utility library, support for basic and useful function, make it easy to write lua code neatly

`Shim.lua` was deeply inspired by [Underscore.js](https://github.com/jashkenas/underscore), [Lodash.js](https://github.com/lodash/lodash), [Moses](https://github.com/Yonaba/Moses)


Usage
---

```lua
local _ = require 'shim'

_.isArray({1, 2, 3}) -- => true

_({1, 2, 3}):chain():map(function(x)
    return x * 2
end):filter(function(x)
    return x > 3
end):value() -- => {4, 6}
```

Api
---

TODO %>_<%


License
---

Shim.lua is under MIT
Copyright (c) 2012-2014 [Chunpu](https://github.com/chunpu)
