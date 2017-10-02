local sti = require "sti"
local lasers = {}
local lasermap = {}
local size = 40
local maptilesize = 16
local mapsize = { x = 12, y = 9}
local inhand = 0
local pressed = {x = 0, y = 0}
local touch = 0
local touchclick = 0 

function love.load()
    local w = 640
    local h = 360
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    scale = math.min(width/w, height/h)

    size = 40*scale

    map = sti("maps/level4.lua")
    for k, object in pairs(map.objects) do
        table.insert(lasers,object)
    end
    map:removeLayer("ObjectLayer")

    for i=1,mapsize.x do
        lasermap[i] = {}
        for j=1,mapsize.y do
            lasermap[i][j] = 0
        end
    end

    for y, tiles in ipairs(map.layers["Walls"].data) do
        for x, tile in pairs(tiles) do
            if tile ~= 0 then
                lasermap[x][y] = 1
            end
        end
    end

    for i = 1, #lasers do
        if lasers[i].name == "Laser1" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 2
        elseif lasers[i].name == "Laser2" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 12
        elseif lasers[i].name == "Laser3" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 22
        elseif lasers[i].name == "Laser4" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 32
        elseif lasers[i].name == "Mirror1" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 3
        elseif lasers[i].name == "Mirror2" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 13
        elseif lasers[i].name == "Mirror3" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 23
        elseif lasers[i].name == "Mirror4" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 33
        elseif lasers[i].name == "End1" then
            local x = (lasers[i].x+maptilesize)/maptilesize
            local y = (lasers[i].y+maptilesize)/maptilesize
            lasermap[x][y] = 4
        end
    end
end

function love.update(dt)
    map:update(dt)
    for i = 1, mapsize.x do
        for j = 1, mapsize.y do
            if lasermap[i][j] == 9 then
                lasermap[i][j] = 0
            end
        end
    end
    addLaserbeam()
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    --map:draw()
    love.graphics.setColor(127, 127, 127)
    --love.graphics.print(tostring(map.layers),200,200)
    --love.graphics.print(inhand,size*12.9,size*1.5)
    --love.graphics.print(pressed.x.." "..pressed.y,size*13,size)
    if inhand == 3 then
        love.graphics.polygon("fill",size*14.5-size, size*3-size, size*14.5, size*3-size, size*14.5, size*3)
        love.graphics.rectangle("line",size*14.5-size, size*3-size, size, size)
    elseif inhand == 13 then 
        love.graphics.polygon("fill",size*14.5, size*3, size*14.5, size*3-size, size*14.5-size, size*3)
        love.graphics.rectangle("line",size*14.5-size, size*3-size, size, size)
    elseif inhand == 23 then 
        love.graphics.polygon("fill",size*14.5, size*3, size*14.5-size, size*3-size, size*14.5-size, size*3)
        love.graphics.rectangle("line",size*14.5-size, size*3-size, size, size)
    elseif inhand == 33 then
        love.graphics.polygon("fill",size*14.5-size, size*3-size, size*14.5, size*3-size, size*14.5-size, size*3)
        love.graphics.rectangle("line",size*14.5-size, size*3-size, size, size)
    else
        love.graphics.rectangle("line",size*14.5-size, size*3-size, size, size)
    end

    --love.graphics.rectangle("line",size*13.5, size*7, size, size)
    --love.graphics.print("  EXIT",size*13.5, size*7.3)

    for i = 1, mapsize.x do
        for j = 1, mapsize.y do
            if lasermap[i][j] == 1 then
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("fill", i*size-size, j*size-size, size, size)
                love.graphics.setColor(127, 127, 127)
            elseif lasermap[i][j] == 2 or lasermap[i][j] == 12 or lasermap[i][j] == 22 or lasermap[i][j] == 32 then
                love.graphics.rectangle("fill", i*size-size, j*size-size, size, size)
            elseif lasermap[i][j] == 3 then
                love.graphics.polygon("fill",i*size-size, j*size-size, i*size, j*size-size, i*size, j*size)
            elseif lasermap[i][j] == 13 then 
                love.graphics.polygon("fill",i*size, j*size, i*size, j*size-size, i*size-size, j*size)
            elseif lasermap[i][j] == 23 then 
                love.graphics.polygon("fill",i*size, j*size, i*size-size, j*size-size, i*size-size, j*size)
            elseif lasermap[i][j] == 33 then
                love.graphics.polygon("fill",i*size-size, j*size-size, i*size, j*size-size, i*size-size, j*size)
            elseif lasermap[i][j] == 8 then
                love.graphics.rectangle("line", i*size-size, j*size-size, size, size)
                --love.graphics.line(i*size-size, j*size-size/2, i*size, j*size-size/2)
            elseif lasermap[i][j] == 9 then
                love.graphics.rectangle("line", i*size-size, j*size-size, size, size)
                --love.graphics.line(i*size-size/2, j*size-size, i*size-size/2, j*size)
            elseif lasermap[i][j] == 4 then
                if lasermap[i+1][j] == 9 or lasermap[i-1][j] == 9 or lasermap[i][j+1] == 9 or lasermap[i][j-1] == 9 then
                    love.graphics.setColor(0, 127, 0)
                else
                    love.graphics.setColor(127, 0, 0)
                end
                love.graphics.rectangle("fill", i*size-size, j*size-size, size, size)
                love.graphics.setColor(127, 127, 127)
            end
            --love.graphics.print(lasermap[i][j],300+i*20,100+j*20)
        end
    end
end


function addLaserbeam()
    for i = 1, mapsize.x do
        for j = 1, mapsize.y do
            local movement = {x = 0, y = 0}
            if lasermap[i][j] == 2 then
                movement = {x = 1, y = 0}
            elseif lasermap[i][j] == 12 then
                movement = {x = 0, y = 1}
            elseif lasermap[i][j] == 22 then
                movement = {x = -1, y = 0}
            elseif lasermap[i][j] == 32 then
                movement = {x = 0, y = -1}
            end
            local hitwall = false
            local current = {x = i, y = j}
            local loop = 0
            repeat
                --Start
                if (lasermap[current.x][current.y] == 2 or lasermap[current.x][current.y] == 22) and (lasermap[current.x+movement.x][current.y+movement.y] == 0 or lasermap[current.x+movement.x][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y
                elseif (lasermap[current.x][current.y] == 12 or lasermap[current.x][current.y] == 32) and (lasermap[current.x+movement.x][current.y+movement.y] == 0 or lasermap[current.x+movement.x][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y
                --Follow
                elseif lasermap[current.x][current.y] == 9 and (lasermap[current.x+movement.x][current.y+movement.y] == 0 or lasermap[current.x+movement.x][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y
                --Left Down
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 3 and movement.x == 1 and movement.y == 0 and (lasermap[current.x+movement.x][current.y+movement.y+1] == 0 or lasermap[current.x+movement.x][current.y+movement.y+1] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y+1] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y+1
                    movement = {x = 0, y = 1}
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 3 and movement.x == 0 and movement.y == -1 and (lasermap[current.x+movement.x-1][current.y+movement.y] == 0 or lasermap[current.x+movement.x-1][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x-1][current.y+movement.y] = 9
                    current.x = current.x+movement.x-1
                    current.y = current.y+movement.y
                    movement = {x = -1, y = 0}
                --Top Left
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 13 and movement.x == 0 and movement.y == 1 and (lasermap[current.x+movement.x-1][current.y+movement.y] == 0 or lasermap[current.x+movement.x-1][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x-1][current.y+movement.y] = 9
                    current.x = current.x+movement.x-1
                    current.y = current.y+movement.y
                    movement = {x = -1, y = 0}
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 13 and movement.x == 1 and movement.y == 0 and (lasermap[current.x+movement.x][current.y+movement.y-1] == 0 or lasermap[current.x+movement.x][current.y+movement.y-1] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y-1] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y-1
                    movement = {x = 0, y = -1}
                --Right Top
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 23 and movement.x == -1 and movement.y == 0 and (lasermap[current.x+movement.x][current.y+movement.y-1] == 0 or lasermap[current.x+movement.x][current.y+movement.y-1] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y-1] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y-1
                    movement = {x = 0, y = -1}
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 23 and movement.x == 0 and movement.y == 1 and (lasermap[current.x+movement.x+1][current.y+movement.y] == 0 or lasermap[current.x+movement.x+1][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x+1][current.y+movement.y] = 9
                    current.x = current.x+movement.x+1
                    current.y = current.y+movement.y
                    movement = {x = 1, y = 0}
                --Down Right
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 33 and movement.x == 0 and movement.y == -1 and (lasermap[current.x+movement.x+1][current.y+movement.y] == 0 or lasermap[current.x+movement.x+1][current.y+movement.y] == 9) then
                    lasermap[current.x+movement.x+1][current.y+movement.y] = 9
                    current.x = current.x+movement.x+1
                    current.y = current.y+movement.y
                    movement = {x = 1, y = 0}
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 33 and movement.x == -1 and movement.y == 0 and (lasermap[current.x+movement.x][current.y+movement.y+1] == 0 or lasermap[current.x+movement.x][current.y+movement.y+1] == 9) then
                    lasermap[current.x+movement.x][current.y+movement.y+1] = 9
                    current.x = current.x+movement.x
                    current.y = current.y+movement.y+1
                    movement = {x = 0, y = 1}
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 1 then
                    hitwall = true
                else
                    hitwall = true
                end
                loop = loop + 1
            until hitwall == true or loop >= mapsize.x*mapsize.y
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    oldx = x
    oldy = y
    x = math.ceil(x/size) 
    y = math.ceil(y/size)
    pressed.x = x
    pressed.y = y
    if button == 1 and x <= mapsize.x and y <= mapsize.y then         
        if inhand == 0 and (lasermap[x][y] == 3 or lasermap[x][y] == 13 or lasermap[x][y] == 23 or lasermap[x][y] == 33) then 
            inhand = lasermap[x][y] 
            lasermap[x][y] = 0 
        elseif inhand ~= 0 and (lasermap[x][y] == 0 or lasermap[x][y] == 9 or lasermap[x][y] == 8) then
            lasermap[x][y] = inhand 
            inhand = 0 
        end
    --elseif oldx >= size*13.5 and oldx <= size*14.5 and oldy >= size*7 and oldy <= size*8 then
    --    love.event.quit()
    end
end

function love.touchpressed( id, x, y, dx, dy, pressure)
    if touch == 0 and touchclick == 60 then
        touch = id
    elseif touchclick < 5 then
        touchclick = touchclick + 1
    end
end

function love.touchreleased( id, x, y, dx, dy, pressure)
    oldx = x
    oldy = y
    x = math.ceil(x/size) 
    y = math.ceil(y/size)
    pressed.x = x
    pressed.y = y
    if touch == id and x <= mapsize.x and y <= mapsize.y then         
        if inhand == 0 and (lasermap[x][y] == 3 or lasermap[x][y] == 13 or lasermap[x][y] == 23 or lasermap[x][y] == 33) then 
            inhand = lasermap[x][y] 
            lasermap[x][y] = 0 
        elseif inhand ~= 0 and (lasermap[x][y] == 0 or lasermap[x][y] == 9) then
            lasermap[x][y] = inhand 
            inhand = 0 
        end
        touch = 0
        touchclick = 0
    --elseif touch == id and oldx >= size*13.5 and oldx <= size*14.5 and oldy >= size*7 and oldy <= size*8 then
    --    love.event.quit()
    end
end