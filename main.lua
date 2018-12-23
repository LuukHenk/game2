love.window.setFullscreen(true, 'desktop')
love.graphics.setDefaultFilter('nearest', 'nearest') --default image filter

local gameMusic = {}
local platform = {}
local player = {}
local objects = {}

local scaleFactor = 10 --image scaling factor

function love.load()
	gameMusic = love.audio.newSource('minimal.mp3', 'stream')
	platform = createPlatform()
	player = createPlayer(platform.width, platform.height)
	objects = createObjects(platform.width, platform.height)
end

function love.update(dt)
		-- if coll.up == false then --if no collision, act as normal jump
		-- 	player.y = player.y - player.currentJumpingSpeed * dt --move up
	-- end
	if floorCollision(player, objects) == false then
		player.y = player.y + platform.gravity * player.mass * dt --fall down
		if player.currentJumpingSpeed > 0 then
			player.currentJumpingSpeed = player.currentJumpingSpeed - platform.gravity * player.mass * dt
		end

	else
		if love.keyboard.isDown('space', 'w', 'up') then
		 	player.currentJumpingSpeed = player.jumpingSpeed
		 end
	end

	--als collision boven niet waar is nog toevoegen
	player.y = player.y - player.currentJumpingSpeed * dt --move up

	if objectCollision(player, objects) == false then
		-- if love.keyboard.isDown('a', 'left') and leftWallCollision(player, objects) == false then
		if love.keyboard.isDown('a', 'left') then
			player.currentImg = player.leftImg
			player.x = player.x - player.speed * dt

		elseif love.keyboard.isDown('d', 'right') then
			player.currentImg = player.rightImg
			player.x = player.x + player.speed * dt

		elseif love.keyboard.isDown('s', 'down') then
			player.currentImg = player.frontLowImg

		else
			player.currentImg = player.frontImg end
	end
end

function objectCollision(player, objects)
	for _,object in pairs(objects) do
		if object.solid == true then
			if player.x + player.width >= object.x and --right side player
				 player.x <= object.x + object.width and --left side player
				 player.y + player.height >= object.y and --bottem player
				 player.y <= object.y + object.height then --top of player
				 return(true)
		  end
	  end
  end
	return(false)
end

function floorCollision(player, objects)
	for _,object in pairs(objects) do
		if object.solid == true then
			if player.x + player.width >= object.x and
				 player.x <= object.x + object.width and
				 player.y + player.height + 1 >= object.y then
				 return(true)
			 end
		end
	end
	return(false)
end

function leftWallCollision(player, objects)
	for _,object in pairs(objects) do
		if object.solid == true then
			if player.y + player.height >= object.y and
				 player.y <= object.y + object.height and
				 player.x <= object.x + object.width + 1 then
				 return(true)
			 end
		end
	end
	return(false)
end
-- function objectCollision(player, objects, direction)
-- 	for _, object in pairs(objects) do
-- 		if object.solid == true then
-- 			if direction == 'up' then
-- 				if collision(player, object, 'left', 0)  == true and
-- 					 collision(player, object, 'right', 0) == true and
-- 					 collision(player, object, 'up', 1)    == true then
-- 					 return(true) end
-- 			elseif direction == 'down' then
-- 				if collision(player, object, 'left', 0)  == true and
-- 					 collision(player, object, 'right', 0) == true and
-- 					 collision(player, object, 'down', 1)  == true then
-- 					 return(true) end
-- 			elseif direction == 'left' then
-- 				if collision(player, object, 'up', 0)   == true and
-- 					 collision(player, object, 'down', 0) == true and
-- 				   collision(player, object, 'left', 1) == true then
-- 					 return(true) end
-- 			elseif direction == 'right' then
-- 				if collision(player, object, 'up', 0)   == true and
-- 					 collision(player, object, 'down', 0) == true and
-- 				   collision(player, object, 'right', 1) == true then
-- 					 return(true) end
-- 			else
-- 				print('ERROR: unknown direction in objectCollision function: ', direction)
-- 				love.event.quit()
-- 			end
-- 		end
-- 	end
-- 	return(false)
-- end

-- function collision(player, object, direction, selected)
-- 	s = selected / 100
-- 	if direction == 'up' then
-- 		if player.y + s <= object.y + object.height and
-- 			 player.y + player.height < object.y then
-- 			return(true)
-- 		else return(false) end
-- 	end
-- 	if direction == 'down' then
-- 		if player.y + player.height >= object.y + s then return(true)
-- 		else return(false) end
-- 	end
-- 	if direction == 'left' then
-- 		if player.x + s <= object.x + object.width then return(true)
-- 		else return(false) end
-- 	end
-- 	if direction == 'right' then
-- 		if player.x + player.width >= object.x + s then return(true)
-- 		else return(false) end
-- 	end
-- 	if direction == 'all' then
-- 		if player.x + player.width >= object.x and player.x <= object.x + object.width and
-- 			player.y + player.height >= object.y and player.y <= object.y + object.height then
-- 			return(true)
-- 		else return(false) end
-- 	end
-- end

function love.draw()
	love.graphics.setColor(platform.r/255, platform.g/255, platform.b/255)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

	love.graphics.setColor(player.r, player.g, player.b)
	love.graphics.draw(player.currentImg, player.x, player.y, 0, player.relativeWidth,
	                   player.relativeHeight)
	for _, object in pairs(objects) do
	-- 	love.graphics.print(object.x, 600, 50)
	-- 	love.graphics.print(object.x + object.width, 780, 50)
	-- 	love.graphics.print(object.y, 650, 0)
	-- 	love.graphics.print(object.y + object.height, 650, 100)
	-- 	love.graphics.print(tostring(collision(player, object, 'up', 0)), 1150, 0)
	-- 	love.graphics.print(tostring(collision(player, object, 'down', 0)), 1150, 100)
	-- 	love.graphics.print(tostring(collision(player, object, 'left', 0)), 1100, 50)
	-- 	love.graphics.print(tostring(collision(player, object, 'right', 0)), 1280, 50)
		love.graphics.setColor(object.r/255, object.g/255, object.b/255)
		love.graphics.rectangle('fill', object.x, object.y, object.width, object.height)
	end
	-- love.graphics.setColor(1, 1, 1)
	-- love.graphics.print(player.x, 100, 50)
	-- love.graphics.print(player.x + player.width, 280, 50)
	-- love.graphics.print(player.y, 150, 0)
	-- love.graphics.print(player.y + player.height, 150, 100)


end

function getAbsolute(percentage, total)
	return(percentage * total)
end

function getRelative(x, screenWidth, scaleFactor)
	return((x / screenWidth) * (scaleFactor * 100))
end

function createPlatform()
	local self = {}
	self.width  = love.graphics.getWidth()
	self.height = love.graphics.getHeight()

	self.x = 0
	self.y = self.height / 2

	self.r = 60
	self.g = 80
	self.b = 255

	self.gravity = 10
	return(self)
end

function createPlayer(screenWidth, screenHeight)
	local self = {}

	self.x = screenWidth / 2
	self.y = screenHeight / 2

	self.frontImg = love.graphics.newImage('images/player.front.png')
	self.frontLowImg = love.graphics.newImage('images/player.front.low.png')
	self.rightImg = love.graphics.newImage('images/player.right.png')
	self.leftImg  = love.graphics.newImage('images/player.left.png')
	self.currentImg = self.frontImg
	self.imgWidth  = self.currentImg:getWidth()
	self.imgHeight = self.currentImg:getHeight()

	self.relativeWidth  = getRelative(self.imgWidth,  screenWidth,  scaleFactor) * 0.9
	self.relativeHeight = getRelative(self.imgHeight, screenHeight, scaleFactor) * 0.4
	self.width  = self.imgWidth  * self.relativeWidth
	self.height = self.imgHeight * self.relativeHeight

	self.speed = 450
	self.jumpingSpeed = 1000
	self.currentJumpingSpeed = 0
	self.mass = 70

	self.r = 1
	self.g = 1
	self.b = 0
	return(self)
end

function createObjects(screenWidth, screenHeight)
	local self = {}
	--left wall
	table.insert(self, generateRectangle(0, 0, 1, screenHeight, 0, 0, 0, true, 'wall_L'))
	--right wall
	table.insert(self, generateRectangle(screenWidth - 1, 0, screenWidth, screenHeight, 0, 0, 0,
	                                     true, 'wall_R'))
	--floor
	table.insert(self, generateRectangle(0, screenHeight - 40, screenWidth, screenHeight, 0, 0, 0,
	                                     true, 'floor'))
	--other objects
	-- table.insert(self, generateRectangle(100, 800, 10, 200, 0, 255, 0, true))
	-- table.insert(self, generateRectangle(300, screenHeight - 10, 10, 10, 0, 0, 0, true))
	-- table.insert(self, generateRectangle(400, screenHeight - 50, 10, 50, 0, 0, 0, true))
	return(self)
end

function generateRectangle(x, y, w, h, r, g, b, s, t)
	local self = {}

	self.x = x
	self.y = y

	self.width  = w
	self.height = h

	self.r = r
	self.g = g
	self.b = b

	self.solid = s

	self.type = t

	return(self)
end
