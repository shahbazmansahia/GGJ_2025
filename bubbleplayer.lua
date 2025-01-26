-- Flagged tile indices (replace with actual tile indices you're using for solid surfaces)


function _init()
    solid_tiles = { 33, 34, 35}  -- Example indices for solid tiles
    platforms = {20, 21, 22, 23}
    num_float_objects = 1
    float_objects = {}
    enemy_tiles = {16, 17, 18, 19}
    --fish_spawns = {{2, 9}, {11, 11}, {7, 5}}
    fish_spawns = {{18, 41}, {27, 39}, {9, 38}, {5, 38}, {7, 25}, {10, 20}}
    --herm_spawns = {{2, 15}, {12, 15}}
    herm_spawns = {{27, 46}, {8, 40}, {2, 37}, {9, 22}, {6, 17}, {7, 12}}
    fishies = {}
    hermes = {}

    -- not all of these variables are in use
    x=56
    y=488
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
    immune_time = 20
    immune_time_max = immune_time
    health = 0
    setHealth(2)
    gameover = false
    restart_timer = 50
    restart_timer_max = restart_timer
    camera_x = 0
    camera_y = 3

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

    for _, enemy in pairs(fish_spawns) do
        temp_fish = create_fish(enemy[1] * 8, enemy[2] * 8)
        fishies[#fishies+1] = temp_fish

    end
    for _, enemy in pairs(herm_spawns) do
        temp_herm = create_herm(enemy[1] * 8, enemy[2] * 8)
        hermes[#hermes+1] = temp_herm
    end
    
end

function _update()
    
    if gameover then
        restart_timer += 1
        if restart_timer >= restart_timer_max then
            _init()
        end
    else
        immune_time = min(immune_time + 1, immune_time_max)

        local player_chunk_x = flr((x) / 128)
        local player_chunk_y = flr((y) / 128)
        printh(camera_x)



        camera(player_chunk_x*16*8, player_chunk_y*16*8)

        if state == 0 then
            default_person_movement()
        elseif state == 1 then
            default_bubble_movement()     
        elseif state == 2 then
            person_falling_movement()
        elseif state == -1 then
            vy += 0.1
            vx = 0
            gameover = true
            restart_timer = 0
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

        for i = 1, #fishies do
            local obj = fishies[i]
            if obj.active then
                if collides(x, y, 8, 8, obj.x, obj.y, 8, 8) then
                    --obj.active = false
                    play_hurt_sound()
                    setHealth(health-1)               
                end
            end
        end

        for i = 1, #hermes do
            local obj = hermes[i]
            if obj.active then
                if collides(x, y, 8, 8, obj.x, obj.y, 8, 8) then
                    --obj.active = false
                    play_hurt_sound()
                    setHealth(health-1)               
                end
            end
        end
        
        update_enemies()
    end
    -- DEBUG
    --printh("x : " .. x .. " y: " .. y .. " vx : " .. vx .. " vy: " .. vy )
    --printh("s: " .. state)
end

function update_enemies() -- animates the enemies
    for i, fish in pairs(fishies) do
        if (fish.x > (fish.origin_x + fish.x_range)) then
            fish.dir = -1
        elseif (fish.x < (fish.origin_x - fish.x_range)) then
            fish.dir = 1
        end
        fish.x = fish.x + fish.dir
        fishies[i] = fish
    end

    for i, herm in pairs(hermes) do
        if check_collision(herm.x + herm.dir, herm.y) then
            herm.dir = -herm.dir
        end

        herm.x = herm.x + herm.dir
        
        hermes[i] = herm
    end
end

function default_bubble_movement()
    -- the great movement if statement
    if btn(0) then
        if vy > 0 and bubble_boost_time == bubble_boost_time_max then
            vx = jump_power_max
            vy = jump_power_max/2
            bubble_boost_time = 0
            play_jump_sound('left')
        elseif on_ground then
            vx = -speed  -- Left
        end
        
        dir = -3
    elseif btn(1) then
        if vy > 0 and bubble_boost_time == bubble_boost_time_max then
            vx = -jump_power_max
            vy = jump_power_max/2
            bubble_boost_time = 0
            play_jump_sound('right')
        elseif on_ground then
            vx = speed  -- Left    
        end
        dir = 3
    elseif btn(3) then

        if vy > 0 and bubble_boost_time == bubble_boost_time_max then
            vy = -jump_power_max/2
            bubble_boost_time = 0
            play_jump_sound('down')
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
        play_jump_sound('up')
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
    if gameover then
        print("Game Over")
    else
        cls()
        -- draw the world
        map()
        -- draw the player, we use dir to mirror sprites
        draw_player(dir)

        for i = 1, num_float_objects do
            local obj = float_objects[i]
            if obj.active then
                spr(1, obj.x, obj.y)
            end
        end
        
        draw_enemies()
    end
end

function draw_enemies()
    for _, fish in pairs(fishies) do
        is_flip = (fish.dir < 0)
        if (fish.x % 2 == 0) then
            spr(fish.sprite, fish.x, fish.y, 1, 1, is_flip)
        else
            spr(fish.animation, fish.x, fish.y, 1, 1, is_flip)
        end
    end
    for _, herm in pairs(hermes) do
        if (herm.x % 3 == 0) then
            spr(herm.sprite, herm.x, herm.y)
        else
            spr(herm.animation, herm.x, herm.y)
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


function is_enemy_tile(x, y)
    local tile = mget(x, y)
    for i=1, #enemy_tiles do
        if tile == enemy_tiles[i] then
            printh("ENEMY COLLISION! ", tile)
            return true
        end
    end
    return false
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

    --[[
        if is_enemy_tile(x1, y1) or is_enemy_tile(x1, y2) or is_enemy_tile(x2, y1) or is_enemy_tile(x2, y2) then
            play_hurt_sound()
            health = health-1
            player_pos_x = player_pos_x - 4 -- poor attempt at a knockback for now ;-;
            return true  -- There's a collision
        end
        ]]
    
    
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

    if immune_time >= immune_time_max then
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
        immune_time = 0
    end

end

function play_jump_sound()
    printh ('Jump Sound Triggered!')
    play_sfx(0)
end

function create_fish(spawn_x, spawn_y)
    local fish = {
        x = spawn_x,
        y = spawn_y,
        origin_x = spawn_x,
        x_range = 16,
        dir = 1,
        sprite = 17,
        animation = 16,
        active = true
        
    }
    return fish
end

function create_herm(spawn_x, spawn_y)
    local herm = {
        x = spawn_x,
        y = spawn_y,
        origin_x = spawn_x,
        dir = -1,
        sprite = 19,
        animation = 18,
        active = true
    }
    return herm
end




function play_jump_sound(str_dir)

    --printh ('Jump Sound Triggered!')
    if (str_dir == 'up') then
        sfx(0)
    elseif (str_dir == 'left') or (str_dir == 'right') then
        sfx(2)
    elseif (str_dir == 'down') then
        sfx(3)
    else
        printh ("ERROR: no direction mentioned to play sound!")
    end
    sfx(0)

end


function play_hurt_sound()
    sfx(1)
    printh ('Hurt Sound Triggered!')
end