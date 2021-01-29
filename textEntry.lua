textEntry = {}
textEntry.__index = textEntry

function textEntry.new(x, y, charLimit, preText, text, textColor, hColor)
	local font = love.graphics.getFont()

	local o = 
	{
		x = x, 
		y = y, 
		charLimit = charLimit, --limits how many chars can be entered
		--height = h,
		preText = preText,
		preTextObj = love.graphics.newText(font, preText),
		text = text, 
		textObj = love.graphics.newText(font, text),
		state = "idle", 
		name = "textEntry", 
		textColor = textColor, 
		highlightColor = hColor
	}
	setmetatable(o, textEntry)
	return o
end

function textEntry:hovering()
	local x, y = love.mouse.getPosition()
	--return x > self.x and x < (self.x + self.width) and y > self.y and y < (self.y + 15)
	local endx = self.x + self.preTextObj:getWidth() + self.charLimit * 8

	return x > self.x and x < endx and y > self.y and y < (self.y + 16)
end

function textEntry:set(str)
	self.text = str
	self.textObj:set(str)
end

function textEntry:input(c)
	if (string.len(self.text) < self.charLimit) then 
		self.text = self.text .. c
		self.textObj:set(self.text)
	end
end

function textEntry:popBack()
	self.text = string.sub(self.text, 1, string.len(self.text) - 1)
	self.textObj:set(self.text)
end

function textEntry:clear()
	self.text = ""
	self.textObj:set(self.text)
end

function textEntry:draw()
	if self.state == "active" then 
		love.graphics.setColor(self.highlightColor)
	else
		love.graphics.setColor(self.textColor)
	end

	love.graphics.draw(self.preTextObj, self.x, self.y)
	love.graphics.draw(self.textObj, self.x + self.preTextObj:getWidth(), self.y)

	local startx, starty = self.x + self.preTextObj:getWidth(), self.y + self.preTextObj:getHeight()
	love.graphics.line(startx, starty, startx + self.charLimit * 8, starty)
end




