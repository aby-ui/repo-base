local myname, ns = ...

local merge = function(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
end

merge(ns.points[862], { -- Zuldazar
})
merge(ns.points[863], { -- Nazmir
})
merge(ns.points[864], { -- Vol'dun
})
merge(ns.points[895], { -- Tiragarde Sound
})
merge(ns.points[896], { -- Drustvar
})
merge(ns.points[942], { -- Stormsong Valley
})
