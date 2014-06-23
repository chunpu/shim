local _ = {}

function _.isArray(t)
    if type(t) == 'table' then
        local i = 0
        for _ in pairs(t) do
            i = i + 1
            if (t[i] == nil) then
                return false
            end
        end
        return true
    end
    return false
end

function _.each(arr, fn)
    for i = 1, #arr do
        fn(arr[i], i, arr)
    end
    return arr
end

function _.map(arr, fn)
    local ret = {}
    for i = 1, #arr do
        ret[i] = fn(arr[i], i, arr)
    end
    return ret
end

function _.isEqual(a, b)
    -- won't compare metatable
    if a == b then return true end
    if type(a) == 'table' and type(b) == 'table' then
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

function _.has(list, item)
    local tp = type(list)
    if tp == 'string' then
        return list:find(item) ~= nil
    elseif tp == 'table' then
        for k, v in pairs(list) do
            if v == item then
                return true
            end
        end
    end
    return false
end

function _.sub(s, i, j)
    return string.sub(s, i, j)
end

function _.trim(s, where)
    local i = 1
    local j = #s
    if where ~= 'left' then
        -- match right space
        local a, b = _.lastIndexOf(s, '%s+')
        if b == j then
            j = a - 1
        end
    end
    if where ~= 'right' then
        -- match left space
        local a, b = _.indexOf(s, '%s+')
        if a == 1 then
            i = b + 1
        end
    end
    return _.sub(s, i, j)
end

function _.flatten(arr)
    local ret = {}
    for i = 1, #arr do
        if type(arr[i]) == 'table' then
            local val = _.flatten(arr[i])
            for j = 1, #val do
                table.insert(ret, val[j])
            end
        else
            table.insert(ret, arr[i])
        end
    end
    return ret
end

function _.uniq(arr)
    -- use hash so not sorted
    local hash = {}
    local ret = {}
    for i = 1, #arr do
        hash[arr[i]] = true
    end
    for k, v in pairs(hash) do
        table.insert(ret, k)
    end
    return ret
end

function _.union(...)
    return _.uniq(_.flatten({...}))
end

function _.extend(dst, ...)
    local src = {...}
    _.each(src, function(obj)
        if type(obj) == 'table' then
            for k, v in pairs(obj) do
                dst[k] = v
            end
        end
    end)
    return dst
end

function _.sort(t, fn)
    table.sort(t, fn)
    return t
end

function _.filter(arr, fn)
    local ret = {}
    _.each(arr, function(x)
        if fn(x) then
            table.insert(ret, x)
        end
    end)
    return ret
end

function _.indexOf(arr, val, from, isPlain)
    local tp = type(arr)
    if tp == 'string' then
        return string.find(arr, val, from, isPlain)
    end
    if tp == 'table' then
        for i = from or 1, #arr do
            if arr[i] == val then
                return i
            end
        end
    end
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

function dumpTable(o, lastIndent)
    if type(lastIndent) ~= 'string' then
        lastIndent = ''
    end
    local indent = '    ' .. lastIndent
    if #indent > 4 * 7 then
        return '[Nested]' -- may be nested, default is 7
    end
    local ret = '{\n'
    local arr = {}
    for k, v in pairs(o) do
        table.insert(arr, indent .. dump(k) .. ': ' .. dump(v, indent))
    end
    ret = ret .. table.concat(arr, ',\n') .. '\n' .. lastIndent .. '}'
    return ret
end

-- TODO multi args
function dump(v, indent)
    local t = type(v)
    if t == 'number' or t == 'boolean' then
        return tostring(v)
    elseif t == 'string' then
        return "'" .. v .. "'"
    elseif t == 'table' then
        if _.isArray(v) then
            return '[' .. table.concat(_.map(v, function(x)
                return dump(x)
            end) , ', ') .. ']'
        else
            return dumpTable(v, indent)
        end
    elseif t == 'nil' then
        return 'null'
    end
    return '[' .. t .. ']'
end

-- TODO split, reduce, ... other function

_.dump = dump

setmetatable(_, {__call = call})

return _
