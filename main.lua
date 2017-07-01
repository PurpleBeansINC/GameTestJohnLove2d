local sti = require "sti"

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	love.physics.setMeter(599)

	-- Load a map exported to Lua from Tiled
	map = sti("map/map1.lua", { "box2d" })

	-- Prepare physics world with horizontal and vertical gravity
	world = love.physics.newWorld(0, 0)

	-- Prepare collision objects
	map:box2d_init(world)

	-- Create a Custom Layer
	local layer = map:addCustomLayer("Sprites", 2)

	-- Player SpriteSheet
	spriteSheet_Idle = love.graphics.newImage("assest/SpriteSheet-Idle.png")

	-- Create player object
	local spriteLayer = map.layers["Sprite Layer"]
	layer.player = {
		spriteSheet = spriteSheet_Idle,
		front = love.graphics.newQuad(0,0,32,64,spriteSheet_Idle:getDimensions()),
		back = love.graphics.newQuad(32,0,32,64,spriteSheet_Idle:getDimensions()),
		left = love.graphics.newQuad(64,0,32,64,spriteSheet_Idle:getDimensions()),
		right = love.graphics.newQuad(96,0,32,64,spriteSheet_Idle:getDimensions()),
		facing = 0,
		x = 32,
		y = 64,
	}

	-- Add controls to player
    layer.update = function(self, dt)
        -- 96 pixels per second
        local speed = 96

        -- Move player up
        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            self.player.y = self.player.y - speed * dt
            self.player.facing = 0
        end

        -- Move player down
        if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            self.player.y = self.player.y + speed * dt
            self.player.facing = 1
        end

        -- Move player left
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            self.player.x = self.player.x - speed * dt
            self.player.facing = 2
        end

        -- Move player right
        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            self.player.x = self.player.x + speed * dt
            self.player.facing = 3
        end
    end

	-- Draw player
    layer.draw = function(self)
    	if self.player.facing == 0 then
        	love.graphics.draw(self.player.spriteSheet, self.player.back, math.floor(self.player.x), math.floor(self.player.y), 0, 1, 1)
        end
        if self.player.facing == 1 then
        	love.graphics.draw(self.player.spriteSheet, self.player.front, math.floor(self.player.x), math.floor(self.player.y), 0, 1, 1)
        end
        if self.player.facing == 2 then
        	love.graphics.draw(self.player.spriteSheet, self.player.left, math.floor(self.player.x), math.floor(self.player.y), 0, 1, 1)
        end
        if self.player.facing == 3 then
        	love.graphics.draw(self.player.spriteSheet, self.player.right, math.floor(self.player.x), math.floor(self.player.y), 0, 1, 1)
        end
    end
end

function love.update(dt)
	map:update(dt)
end

function love.draw()
	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	map:draw()

	-- Please note that map:draw, map:box2d_draw, and map:bump_draw take
	-- translate and scale arguments (tx, ty, sx, sy) for when you want to
	-- grow, shrink, or reposition your map on screen.
	-- Draw Collision Map (useful for debugging)
	local player = map.layers["Sprites"].player
	local tx = math.floor(player.x - windowWidth / 2)
    local ty = math.floor(player.y - windowHeight / 2)
    -- Draw Collision Map (useful for debugging)
	love.graphics.setColor(255, 0, 0)
	map:box2d_draw(tx, ty,1,1)
end