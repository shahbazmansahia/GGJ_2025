-- Flagged tile indices (replace with actual tile indices you're using for solid surfaces)
local solid_tiles = { 33, 34, 35 }  -- Example indices for solid tiles


function _init()
    x=50 -- x-position
    y=90 -- y-position
    vx = 0
    vy = 0
    speed = 1
    sprite=1 -- current sprite
    jump_btn_held = false
    jump_power = -5

    on_ground = false

    -- Still trying to test this
    -- https://www.youtube.com/watch?v=IOe1aGY6hXA
    jump_height = 50
    jump_peak_time = 1
    jump_fall_time = 2

    jump_velocity = ((2 * jump_height) / jump_peak_time) * -1
    jump_gravity = ((-2 * jump_height) / (jump_peak_time * jump_peak_time)) * -1
    fall_gravity = ((-2 * jump_height) / (jump_fall_time * jump_fall_time)) * -1
    
end

function _update()
    x=(x+128)%128 -- no bounds left and right

    if btn(0) then
        vx = -speed  -- Left
    elseif btn(1) then
        vx = speed   -- Right
    else
        vx = 0
    end

     -- Check for collisions in the new position before updating
     if not check_collision(x + vx, y) then
        x = x + vx  -- Update position if no collision
    end

    if btnp(2) and on_ground then -- Jump
        vy = jump_power
        on_ground = false
    end

    if vy > 0 then
        vy = min(vy + 0.2, 1) -- give the graceful bubble drop affect
    else
        vy += 0.2
    end

    -- Check for vertical collisions (falling)
    if not check_collision(x, y + vy) then
        y = y + vy  -- Update position if no collision
    else
        -- If collision, stop downward movement and set player on ground
        vy = 0
        on_ground = true
    end

    -- DEBUG
    --printh("x : " .. x .. " y: " .. y .. " vx : " .. vx .. " vy: " .. vy )
end

function _draw()
    cls()
    -- draw the world
    map(0,0,0,0,16,16)
    -- draw the player, we use dir to mirror sprites
    spr(sprite, x,y,1,1,dir==-1)
end

-- still testing this
function  get_gravity()
    if vy < 0 then
        return jump_gravity
    else
        return fall_gravity
        
    end
end

-- Function to check if a tile is flagged (solid)
function is_solid_tile(x, y)
    local tile = mget(x, y)
    for i=1, #solid_tiles do
        if tile == solid_tiles[i] then
            return true  -- This is a solid tile
        end
    end
    return false  -- This is not a solid tile
end


function check_collision(new_x, new_y)
    -- Check collisions for all four corners of the character
    local x1 = flr(new_x / 8)  -- Calculate tile grid x for left side
    local y1 = flr(new_y / 8)  -- Calculate tile grid y for bottom side
    local x2 = flr((new_x + 8 - 1) / 8)  -- Right side
    local y2 = flr((new_y + 8 - 1) / 8)  -- Top side
    
    -- Check if any of the four corners are colliding with solid tiles
    if is_solid_tile(x1, y1) or is_solid_tile(x1, y2) or is_solid_tile(x2, y1) or is_solid_tile(x2, y2) then
        return true  -- There's a collision
    end
    
    return false  -- No collision
end
