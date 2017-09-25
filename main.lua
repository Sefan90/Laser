local sti = require "sti"
local lasers = {}
local lasermap = {}
local size = 16
local mapsize = { x = 12, y = 9}

function love.load()
    map = sti("maps/level2.lua")
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
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 2
        elseif lasers[i].name == "Laser2" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 12
        elseif lasers[i].name == "Laser3" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 22
        elseif lasers[i].name == "Laser4" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 32
        elseif lasers[i].name == "Mirror1" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 3
        elseif lasers[i].name == "Mirror2" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 13
        elseif lasers[i].name == "Mirror3" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 23
        elseif lasers[i].name == "Mirror4" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 33
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
    map:draw()
    love.graphics.setColor(0, 255, 0)
    love.graphics.print(tostring(map.layers),200,200)
    for i = 1, mapsize.x do
        for j = 1, mapsize.y do
            if lasermap[i][j] == 2 or lasermap[i][j] == 12 or lasermap[i][j] == 22 or lasermap[i][j] == 32 or lasermap[i][j] == 3 or lasermap[i][j] == 13 or lasermap[i][j] == 23 or lasermap[i][j] == 33 then
                love.graphics.rectangle("fill", i*size-size, j*size-size, size, size)
            elseif lasermap[i][j] == 9 then
                love.graphics.rectangle("line", i*size-size, j*size-size, size, size)
            end
            love.graphics.print(lasermap[i][j],300+i*20,100+j*20)
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
                if (lasermap[current.x][current.y] == 2 or lasermap[current.x][current.y] == 12 or lasermap[current.x][current.y] == 22 or lasermap[current.x][current.y] == 32) and (lasermap[current.x+movement.x][current.y+movement.y] == 0 or lasermap[current.x+movement.x][current.y+movement.y] == 9) then
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
                elseif lasermap[current.x+movement.x][current.y+movement.y] == 23 and movement.x == 0 and movement.y == -1 and (lasermap[current.x+movement.x+1][current.y+movement.y] == 0 or lasermap[current.x+movement.x+1][current.y+movement.y] == 9) then
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