-- Implementation of the Ray-casting algorithm. Based on the C implementation found at
-- http://rosettacode.org/wiki/Ray-casting_algorithm#C 

BGD_RayCast_base = {}
BGD_RayCast_base.__index = BGD_RayCast_base
BGD_RayCast_base.zones = { }

setmetatable(BGD_RayCast_base, {
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

function BGD_RayCast_base:_init()
   -- Initialize RayCast_base - Nothing to do atm.
end

-- Subtract vector b from a
function BGD_RayCast_base:vsub(a, b)
    return { a[1] - b[1], a[2] - b[2] }
end

-- Add vector a and b
-- local function BGD_RayCast_base:vadd(a, b)
--    return { a[1] + b[1], a[2] + b[2] }
-- end

-- Dot product of vector a and b
function BGD_RayCast_base:vdot(a, b)
    return a[1] * b[1] + a[2] * b[2];
end

-- Cross product of vector a and b
function BGD_RayCast_base:vcross(a, b)
    return a[1] * b[2] - a[2] * b[1];
end

-- return a + s * b
function BGD_RayCast_base:vmadd(a, s, b)
   return { a[1] + s * b[1], a[2] + s * b[2] }
end


--  check if x0->x1 edge crosses y0->y1 edge. dx = x1 - x0, dy = y1 - y0, then
--   solve  x0 + a * dx == y0 + b * dy with a, b in real
--   cross both sides with dx, then: (remember, cross product is a scalar)
--      x0 X dx = y0 X dx + b * (dy X dx)
--   similarly,
--      x0 X dy + a * (dx X dy) == y0 X dy
--   there is an intersection iff 0 <= a <= 1 and 0 <= b <= 1
-- 
--   returns: 1 for intersect, -1 for not, 0 for hard to say (if the intersect point is too close to y0 or y1)
function BGD_RayCast_base:intersect(x0, x1, y0, y1, tolerance, sect)
    local dx = self:vsub(x1, x0)
    local dy = self:vsub(y1, y0)
    local d = self:vcross(dy, dx)

    if d == 0 then
        return 0, sect -- edges are parallel
    end

    local a = (self:vcross(x0, dx) - self:vcross(y0, dx)) / d;
    if (sect  ~= nil) then
        sect = self:vmadd(y0, a, dy);
    end

    if (a < -tolerance or a > 1 + tolerance) then
        return -1, sect;
    end

    if (a < tolerance or a > 1 - tolerance) then 
        return 0, sect;
    end

    a = (self:vcross(x0, dy) - self:vcross(y0, dy)) / d;
    if (a < 0 or a > 1) then
        return -1, sect;
    end

    return 1, sect;
end
 

-- dist(vec_x, vec_y0, vec_y1, tolerance)
--   vec_x: {real x, real y}
--   vec_y0: {real x, real y}
--   vec_y1: {real x, real y}
--   tolerance: real
-- 
-- Returns the distance between the point "vec_x" and nearest point on y0->y1 segment.  
-- If the point lies outside the segment, returns infinity
function BGD_RayCast_base:dist(vec_x, vec_y0, vec_y1, tolerance)
    local dy = self:vsub(vec_y1, vec_y0)
    local vec_x1 = {}

    vec_x1[1] = vec_x[1] + dy[2];
    vec_x1[2] = vec_x[2] - dy[1];

    local vec_s = {0,0}
    local r
    r, vec_s = self:intersect(vec_x, vec_x1, vec_y0, vec_y1, tolerance, vec_s);

    if (r == -1) then
        return math.huge;
    end
    vec_s = self:vsub(vec_s, vec_x);
    return math.sqrt(self:vdot(vec_s, vec_s));
end


-- insideZone(point)
--   point: {real x, real y}
-- 
-- Checks if "point" is within any defined subzone, returns the name of the first hit or nil if not found.
function BGD_RayCast_base:insideZone(point)
    for k,v in pairs(self.zones) do
        if self:inside(point, v, 1e-10) then
            return k
        end
    end
    return nil
end


-- inside(point, polygon, tolerance)
--   point: {real x, real y}
--   plygon: {point1, point2, ..., pointn}
--   tolerance: real
-- 
-- Returns true when "point" is inside "polygon". 
-- Returns nil if "point" is closer than "tolerance" from an edge or the input polygon is invalid.
-- Returns false if "point" is outside.
function BGD_RayCast_base:inside(point, polygon, tolerance)
    -- Make sure the polygon has at least two points.
    if #polygon < 2 then
        return nil
    end

    -- Make sure we are not too close to an edge.
    for index, _ in pairs(polygon) do
        local nextIndex = (index % #polygon)+1;

        -- the point is intersecting (too close to) an edge.
        if self:dist(point, polygon[index], polygon[nextIndex], tolerance) < tolerance then
            return nil
        end
    end

    local max_x = polygon[1][1]
    local min_x = max_x
    local max_y = polygon[2][2]
    local min_y = max_y

    -- calculate extent of polygon (get bounding box of polygon)
    for _, vector in pairs(polygon) do
        if vector[1] > max_x then max_x = vector[1]; end
        if vector[1] < min_x then min_x = vector[1]; end
        if vector[2] > max_y then max_y = vector[2]; end
        if vector[2] < min_y then min_y = vector[2]; end
    end

    -- Is the "point" outside the bounding box
    if point[1] < min_x or point[1] > max_x or
        point[2] < min_y or point[2] > max_y then
        return false
    end

    max_x = max_x - min_x; max_x = max_x * 2;
    max_y = max_y - min_y; max_y = max_y * 2;
    max_x = max_x + max_y;

    local vec_e = {0,0};
    local crosses
    while true do
        crosses = 0;

        -- pick a random point far enough to be outside polygon
        vec_e[1] = point[1] + (math.random()+1) * max_x;
        vec_e[2] = point[2] + (math.random()+1) * max_y;

        local index
        for i, _ in pairs(polygon) do
            index = i
            local nextIndex = (index % #polygon)+1;
            local r = self:intersect(point, vec_e, polygon[index], polygon[nextIndex], tolerance, nil);

            -- picked a bad point, ray got too close to vertex.
            -- re-pick
            if r == 0 then break end

            if r == 1 then
                crosses = crosses + 1;
            end
        end
    if index == #polygon then break end
    end

    if crosses%2 == 1 then 
        return true
    else
        return false
    end
end
