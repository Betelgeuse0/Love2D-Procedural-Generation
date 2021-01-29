
controller = {}

function controller:load(baseHeight, freq, smoothCycles, spreadX, spreadY, wormRadius, wormLenLow, wormLenHigh, stepX, stepY)
	--TERRAIN VARIABLES
	self.baseHeight = baseHeight --the base height of the terrain
	self.freq = freq			 --the "bumpiness" of the terrain
	self.smoothCycles = smoothCycles --how many cyles the terrain is smoothed. The more cycles, the smoother it is.
	--CAVE VARIABLES
	self.spreadX = spreadX				--how far on the x axis the caves spawn from eachother
	self.spreadY = spreadY				--how far on the y axis the caves spawn from eachother
	self.wormRadius = wormRadius		--the radius of the circle that carves out the caves
	self.wormLenLow = wormLenLow		--the lowest "length" of a cave (smaller caves)
	self.wormLenHigh = wormLenHigh	--the highest "length" of a cave (bigger caves)
	self.stepX = stepX 					--how much we step on the x axis when creating a cave 
	self.stepY = stepY 					--how much we step on the y axis when creating a cave
	--buttons and text entries
	self.buttons = {}
	self.textEntries = {}

	local trigger = function()
		controller:genMap()
	end
	local genButton = button.new(0, 700, 800, 100, "Generate", {1, 1, 1, 1}, {0, 0.5, 0, 1}, {0, 0.8, 0, 1}, trigger)
	table.insert(self.buttons, genButton)

	controller:addTextEntry(15, 610, 3, "baseHeight: ", "20", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(15, 630, 3, "frequency:  ", "20", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(15, 650, 3, "smoothCycles:  ", "5", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(185, 610, 3, "spreadX: ", "20", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(185, 630, 3, "spreadY: ", "10", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(355, 610, 3, "wormRadius: ", "1.7", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(355, 630, 3, "wormLenLow:  ", "15", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(355, 650, 3, "wormLenHigh: ", "20", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(525, 610, 3, "stepX: ", "2.5", {0, 0, 0, 1}, {0.5, 0, 1, 1})
	controller:addTextEntry(525, 630, 3, "stepY: ", "2.5", {0, 0, 0, 1}, {0.5, 0, 1, 1})

	map:init(800, 600)
	self:genMap()
end

function controller:genMap()
	self.baseHeight = tonumber(self.textEntries[1].text)
	self.freq = tonumber(self.textEntries[2].text)
	self.smoothCycles = tonumber(self.textEntries[3].text)
	self.spreadX = tonumber(self.textEntries[4].text)
	self.spreadY = tonumber(self.textEntries[5].text)
	self.wormRadius = tonumber(self.textEntries[6].text)
	self.wormLenLow = tonumber(self.textEntries[7].text)
	self.wormLenHigh = tonumber(self.textEntries[8].text)
	self.stepX = tonumber(self.textEntries[9].text)
	self.stepY = tonumber(self.textEntries[10].text)
	map:genTerrain(self.baseHeight, self.freq, self.smoothCycles)
	map:genCaves(self.spreadX, self.spreadY, self.wormRadius, self.wormLenLow, self.wormLenHigh, self.stepX, self.stepY)
end

function controller:addTextEntry(x, y, w, preText, text, textColor, hColor)
	local t = textEntry.new(x, y, w, preText, text, textColor, hColor)
	table.insert(self.textEntries, t)
end

function fixInvalidTextEntry(t)
	if (not t.text or t.text == "" or not tonumber(t.text)) then 
		t:set("1")
	elseif (tonumber(t.text) == 0) then
		local i = string.find(t.preText, "spreadX")
		local j = string.find(t.preText, "spreadY")
		local k = string.find(t.preText, "stepX")
		local p = string.find(t.preText, "stepY")

		if i ~= nil or j ~= nil or k ~= nil or p ~= nil then 
			t:set("1")
		end
	end
end

function controller:draw()
	--draw background
	love.graphics.setColor(1, 0.898, 0.706, 1)
	love.graphics.rectangle("fill", 0, 600, 800, 100)
	--draw buttons
	for i,b in ipairs(self.buttons) do 
		b:draw()
	end
	--draw textEntries
	for i,t in ipairs(self.textEntries) do 
		t:draw()
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	for i,t in ipairs(controller.textEntries) do
		fixInvalidTextEntry(t)
		if (t:hovering()) then
			t.state = "active"
			t:clear()
		else
			t.state = "idle"
		end
	end

	for i,b in ipairs(controller.buttons) do 
		if (b:hovering()) then 
			b.state = "active"
		else 
			b.state = "idle"
		end
	end
end

function love.mousereleased(x, y, button, istouch, presses)
	for i,b in ipairs(controller.buttons) do 
		if (b:hovering() and b.state == "active") then 
			b.trigger()
		end
		b.state = "idle"
	end
end

function love.keypressed(key, scancode, isrepeat)
	local num = string.byte(key)
	if (string.find(key, "kp")) then 
		num = string.byte(string.sub(key, string.len(key)))
		key = string.sub(key, string.len(key))
	end

	local isNumKey = (num >= 48 and num <= 57)
	local isStrKey = key == "." or key == "backspace" or key == "return" or key == "escape" or key == "kp."

	if not isNumKey and not isStrKey then return end

	for i, t in ipairs(controller.textEntries) do
		if (t.state == "active") then 
			if key == "backspace" then 
				t:popBack()
			elseif key == "return" or key == "escape" then 
				t.state = "idle"
				fixInvalidTextEntry(t)
			else
				if (isNumKey) then
					t:input(num - 48)
				else
					t:input(key)
				end
			end
		end
	end
end