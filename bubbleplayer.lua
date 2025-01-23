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

    if btnp(2) and on_ground then -- Jump
        vy = jump_power
        on_ground = false
    end

    if vy > 0 then
        vy = min(vy + 0.2, 1) -- give the graceful bubble drop affect
    else
        vy += 0.2
    end
    
    x += vx
    y += vy

    if y >= 120 - 8 then -- basic collision
        y = 120 - 8
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
