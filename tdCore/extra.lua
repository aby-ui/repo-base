
local function riter(t, i)
    i = i - 1
    if i > 0 then
        return i, t[i]
    end
end

function ripairs(t)
    assert(type(t) == 'table')
    
    return riter, t, #t + 1
end
