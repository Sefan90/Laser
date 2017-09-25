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
        end
    end

    for i = 1, #lasers do
        if lasers[i].name == "Mirror1" then
            local x = (lasers[i].x+size)/size
            local y = (lasers[i].y+size)/size
            lasermap[x][y] = 3
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
    for i = 1, mapsize.x do
        for j = 1, mapsize.y do
            if (lasermap[i][j] == 2 or lasermap[i][j] == 9) and i+1 <= mapsize.x then
                if lasermap[i+1][j] ~= 1 and lasermap[i+1][j] ~= 2 and lasermap[i+1][j] ~= 3 then
                    lasermap[i+1][j] = 9
                end
            end
            if (lasermap[i][j] == 3 or lasermap[i][j] == 8) and j+1 <= mapsize.y then
                if lasermap[i][j+1] ~= 1 and lasermap[i][j+1] ~= 2 and lasermap[i][j+1] ~= 3 then 
                    lasermap[i][j+1] = 8
                end
            end
        end
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    map:draw()
    love.graphics.setColor(0, 255, 0)
    love.graphics.print(tostring(map.layers),200,200)
    for i = 1, mapsize.x do
        for j = 1, mapsize.y do
            if lasermap[i][j] == 2 or lasermap[i][j] == 3 then
                love.graphics.rectangle("fill", i*size-size, j*size-size, size, size)
            elseif lasermap[i][j] == 8 or lasermap[i][j] == 9 then
                love.graphics.rectangle("line", i*size-size, j*size-size, size, size)
            end
            love.graphics.print(lasermap[i][j],300+i*10,200+j*10)
        end
    end
end