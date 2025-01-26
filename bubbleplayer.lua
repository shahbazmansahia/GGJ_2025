-- Flagged tile indices (replace with actual tile indices you're using for solid surfaces)
local solid_tiles = { 33, 34, 35 }  -- Example indices for solid tiles
num_float_objects = 1
local float_objects = {}

function _init()
    -- not all of these variables are in use
    x=50
    y=90
    vx = 0
    vy = 0
    speed = 1
    sprite=1 -- current sprite
    jump_btn_held = false
    jump_power = -4
    jump_power_max = jump_power
    jump_boost = 1
    jump_boost_max = jump_boost
    person_jump_power = -3
    jump_hold_time = 10
    jump_hold_time_max = jump_hold_time
    jump_active = false
    bubble_boost_time = 20
    bubble_boost_time_max = bubble_boost_time
    dir = 2
    state=-1
    health = 0
    setHealth(1)

    on_ground = false

    for i = 1, num_float_objects do
        add(float_objects, {x = rnd(128), y = 120, active = true})
    end

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

    if state == 0 then
        default_person_movement()
    elseif state == 1 then
        default_bubble_movement()     
    elseif state == 2 then
        person_falling_movement()
    end

    -- Check for collisions in the new position before updating
    if not check_collision(x + vx, y) then
        x = x + vx  -- Update position if no collision
    end
    
    -- Check for vertical collisions (falling)
    -- jumping underneath platforms is very janky
    if not check_collision(x, y + vy) or (vy < 0 and not check_collision(x, y - 20)) then -- not sure how 20 works. I would think 9 would be enough
        y = y + vy  -- Update position if no collision
    else
        -- If collision, stop downward movement and set player on ground
        vy = 0
        on_ground = true
    end

    -- check for bubble collisions
    for i = 1, #float_objects do
        local obj = float_objects[i]
        if obj.active then
            if not collides(x, y, 8, 8, obj.x, obj.y, 8, 8) then
                -- No collision detected, update object position
                obj.y -= .25
                
                if obj.y < 0 then
                    --table.remove(float_objects, i)
                    obj.active = false
                end
            else
                -- Collision detected, destroy object and add points
                --table.remove(float_objects, i)
                obj.active = false
                setHealth(health+1)
                
            end
        end
    end
    
    -- DEBUG
    --printh("x : " .. x .. " y: " .. y .. " vx : " .. vx .. " vy: " .. vy )
    --printh("s: " .. state)
end

function default_bubble_movement()
    -- the great movement if statement
    if btn(0) then
        if vy > 0 and bubble_boost_time == bubble_boost_time_max then
            vx = jump_power_max
            vy = jump_power_max/2
            bubble_boost_time = 0
        elseif on_ground then
            vx = -speed  -- Left
        end
        
        dir = -3
    elseif btn(1) then
        if vy > 0 and bubble_boost_time == bubble_boost_time_max then
            vx = -jump_power_max
            vy = jump_power_max/2
            bubble_boost_time = 0
        elseif on_ground then
            vx = speed  -- Left    
        end
        dir = 3
    elseif btn(3) then
        if vy > 0 and bubble_boost_time == bubble_boost_time_max then
            vy = -jump_power_max/2
            bubble_boost_time = 0
            -- printh("bubble jump triggered!")
            -- play_jump_sound()
        end
    else
        vx = 0
        dir = 2
    end

    if not on_ground then -- when falling, add drag to any horizontal movement
        if vx > 0 then
            vx = max(vx - 0.5, 0)           
        elseif vx < 0 then
            vx = min(vx + 0.5, 0)
        end
    end

    -- jump off the ground and in the water
    if btn(2) and (on_ground or bubble_boost_time == bubble_boost_time_max) then -- Jump
        vy = jump_power_max
        on_ground = false
        bubble_boost_time = 0
    end

    -- this limits how often the player can boost in water
    bubble_boost_time = min(bubble_boost_time + 1, bubble_boost_time_max)


    if vy > 0 then  -- when falling, add drag to any vertical movement...and do other things, this should get cleaned up
        if vy <= 0.25 then
            vy = min(vy + 0.1, 0.25) -- give the graceful bubble drop affect 
        else
            vy = max(vy - 0.1, 0.25)
        end
    else
        if btn(2) and not on_ground and jump_hold_time > 0 then
            jump_hold_time -= 1
            jump_hold_time = max(jump_hold_time, 0) -- Limit the jump power to a max value
        
            vy += 0.1
        else
            vy += 0.5
        end

        

    end
end

function default_person_movement()
    if btn(0) then
        vx = -speed  -- Left
        dir = -3
    elseif btn(1) then
        vx = speed   -- Right
        dir = 3
    else
        vx = 0
        --dir = 2
    end

    if btnp(2) and on_ground then -- Jump
        -- printh("jump triggered!")
        -- play_jump_sound()
        vy = person_jump_power
        on_ground = false
        
    end

    if vy > 0 and not on_ground then
        state = 2
        if (dir < 0) dir = -5
        if (dir > 0) dir = 5

    else
        vy += 0.2
    end
end

function person_falling_movement()
    if on_ground then
        state = 0
        if (dir < 0) dir = -3
        if (dir > 0) dir = 3
    else
        --[[ -- uncomment to enable movement when diving
            if btn(0) then
                dir = -5
            elseif btn(1) then
                dir = 5
            end
        ]]
    
        vy = min(vy + 0.3, 1)
        vx = (abs(vx) + .1) * dir

        if (vx > 1) vx = 2
        if (vx < -1) vx = -2

        --printh("vx: " .. vx)
    end

end

function _draw()
    cls()
    -- draw the world
    map(0,0,0,0,16,16)
    -- draw the player, we use dir to mirror sprites
    draw_player(dir)

    for i = 1, num_float_objects do
        local obj = float_objects[i]
        if obj.active then
            spr(1, obj.x, obj.y)
        end
    end
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

-- check for map collisions
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

-- check for collisions with another object
function collides(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and ax + aw > bx and ay < by + bh and ay + ah > by
end

function draw_player(dir)
    
    dir = (dir == nil) and 2 or dir
    local is_flip = (dir < 0)
    dir = abs(dir)

    if (health == 2) then
        spr(dir, x, y - 1, 1, 1, is_flip)
        spr(1, x, y)
    else
        spr(dir, x, y, 1, 1, is_flip)
    end
    
    
end

function setHealth(h)

    if h == 2 then
        state = 1
    elseif h == 1 then
        state = 0
    elseif h == 0 then
        state = -1
    elseif h > 2 then
        h = 2
    end

    health = h

end

function play_jump_sound()
    printh ('Jump Sound Triggered!')
    play_sfx(0)
end

function play_hurt_sound()
    printh ('Hurt Sound Triggered!')
    return
end