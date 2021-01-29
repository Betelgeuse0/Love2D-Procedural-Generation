
button = {}
button.__index = button

function button.new(x, y, w, h, text, textColor, color, highlightColor, trigFunc)
	--local font = love.graphics.getFont()
	local font = love.graphics.newFont(25)
	local o = {}
	o.x = x
	o.y = y
	o.width = w 
	o.height = h
	o.textObj = love.graphics.newText(font, text)
	o.textColor = textColor or {0, 0, 0, 1}
	o.color = color
	o.highlightColor = highlightColor
	o.trigger = trigFunc
	o.state = "idle"
	setmetatable(o, button)
	return o
end

function button:hovering()
	local x, y = love.mouse.getPosition()
	return x > self.x and x < (self.x + self.width) and y > self.y and y < (self.y + self.height)
end

function button:draw()
	if (self.state == "active") then 
		love.graphics.setColor(self.highlightColor)
	else
		love.graphics.setColor(self.color)
	end
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(self.highlightColor)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.setColor(self.textColor)
	local x, y = self.x + (self.width / 2), self.y + (self.height / 2) 
	x, y = x - (self.textObj:getWidth() / 2), y - (self.textObj:getHeight() / 2)
	love.graphics.draw(self.textObj, x, y)
end