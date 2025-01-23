-- pico-8 gamedev #1
-- getting started

curr_level = 0
player_pos_x = 7 * 8
player_pos_y = 7 * 8
player_health = 1

function _init()
    msg="hello pico-8"
    x=40 y=64
    dx=1 dy=1
    curr_level = 0
   end
   
   function _update()
    -- x+=dx y+=dy
    -- if x<1 or x>128-#msg*4 then
    --  dx*=-1
    -- elseif y<1 or y>127-5 then
    --  dy*=-1
    -- end
    if curr_level == 0 then
        if (btnp(5)) then
            curr_level = 1
            print('Game Started!')
        end
    elseif curr_level == 1 then
        if (btnp(5)) then
            player_health = 0
        end
    end
   end
   
   function _draw()
    cls(1)
    if curr_level == 0 then
        print(msg,x,y,8+dx+dy)
    end
    if curr_level == 1 then
        map()
        draw_player()
    end
   end
   
   function draw_player()
    if (player_health==1) then
        spr(2, player_pos_x, player_pos_y-1)
        spr(1, player_pos_x, player_pos_y)          
    else
        spr(2, player_pos_x, player_pos_y)
    end
    
   end