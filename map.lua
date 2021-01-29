
map = 
{
	WIDTH = 0,
	HEIGHT = 0,
	TILEWIDTH = 0,
	TILEHEIGHT = 0,
	TILESIZE = 10,
	TILETYPES = 
	{
		SKY = 0, 
		GRASS = 1,
		DIRT = 2,
		DIRTWALL = 3
	},

 	TILES = {} --the actual tiles in the map
}

function map:init(w, h, tileSize)
	self.WIDTH = w
	self.HEIGHT = h
	self.TILESIZE = tileSize or self.TILESIZE
	self.TILEWIDTH = w / self.TILESIZE
	self.TILEHEIGHT = h / self.TILESIZE
	--setup the map grid
	for x = 1, self.TILEWIDTH do 
		table.insert(self.TILES, {})
	end
end

function map:setTile(x, y, tileType)
	y = math.floor(y)
	x = math.floor(x)
	if x < 1 or x > self.TILEWIDTH or y < 1 or y > self.TILEHEIGHT then 
		return
	end
	self.TILES[x][y] = tileType
end

function map:getTile(x, y)
	y = math.floor(y)
	x = math.floor(x)
	if x < 1 or x > self.TILEWIDTH or y < 1 or y > self.TILEHEIGHT then 
		return
	end
	return self.TILES[x][y]
end

function map:drawTile(x, y)
	local tile = self.TILES[x][y]

	if (tile == self.TILETYPES.SKY) then
		love.graphics.setColor(0.529, 0.808, 0.922, 1)
	elseif (tile == self.TILETYPES.GRASS) then
		love.graphics.setColor(0, 153 / 255, 23 / 255, 1)
	elseif (tile == self.TILETYPES.DIRT) then
		love.graphics.setColor(165 / 255, 42 / 255, 42 / 255, 1)
	elseif (tile == self.TILETYPES.DIRTWALL) then
		love.graphics.setColor(128 / 255, 0, 0, 1)
	end

	love.graphics.rectangle("fill", (x - 1) * self.TILESIZE, (y - 1) * self.TILESIZE, self.TILESIZE, self.TILESIZE)
end

function map:genTerrain(baseHeight, freq, smoothCycles)
	--generate terrain with simplex noise
	valuesY = {} --the top y values of the terrain
	for x = 1, self.TILEWIDTH do 
		local y = love.math.noise(math.random(), math.random()) * freq + baseHeight
		table.insert(valuesY, y)
	end

	--smooth the terrain
	smoothY = {}
	table.insert(smoothY, valuesY[1])

	for c = 1, smoothCycles do 
		for x = 2, self.TILEWIDTH do
			local y = valuesY[x]
			--get average between current y and last y
			local averY = (y + valuesY[x - 1]) / 2
			if #smoothY < #valuesY then 
				table.insert(smoothY, averY)
			else
				smoothY[x] = averY
			end
		end
		valuesY = table.clone(smoothY)
	end 

	--set the tiles based on the y values of the terrain
	for x, y in ipairs(valuesY) do 
		self:setTile(x, y, self.TILETYPES.GRASS)

		for i = y - 1, 1, -1 do 
			self:setTile(x, i, self.TILETYPES.SKY)
		end

		for i = y + 1, self.TILEHEIGHT + 1 do
			self:setTile(x, i, self.TILETYPES.DIRT)
		end
	end		
end

function map:genCaves(spreadX, spreadY, wormRadius, wormLenLow, wormLenHigh, stepX, stepY)
	local stepX, stepY = stepX or 1, stepY or 1

	for x = spreadX, self.TILEWIDTH - spreadX, spreadX do 
		for y = spreadY, self.TILEHEIGHT - spreadY, spreadY do 
			if self:getTile(x, y) ~= self.TILETYPES.SKY then 

				--create simplex worm
				local wormLen = math.random(wormLenLow, wormLenHigh)
				local noise = love.math.noise(math.random())
				--local angleX, angleY = math.cos(noise), math.sin(noise)

				local angleX, angleY = noise * math.random(-1, 1), noise * math.random(-1, 1)
				angleX, angleY = vecNormalize(angleX, angleY)
				local posx, posy = x, y

				for i = 0, wormLen do 
					--carve out the circle
					for dx = posx - wormRadius, posx + wormRadius do 
						for dy = posy - wormRadius, posy + wormRadius do
							if distance(dx, dy, posx, posy) <= wormRadius and 
							   self:getTile(dx, dy) ~= self.TILETYPES.SKY then 
								self:setTile(dx, dy, self.TILETYPES.DIRTWALL)
							end
						end
					end
					posx = posx + angleX * stepX 
					posy = posy + angleY * stepY
					noise = love.math.noise(math.random())
					angleX, angleY = noise * math.random(-1, 1), noise * math.random(-1, 1)
					angleX, angleY = vecNormalize(angleX, angleY)
				end
			end
		end
	end
end

function map:draw()
	for x = 1, self.TILEWIDTH do
		for y = 1, self.TILEHEIGHT do 
			self:drawTile(x, y)
		end
	end
end