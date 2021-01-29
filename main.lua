require("helperFunctions")
require("map")
require("controller")
require("button")
require("textEntry")

function love.load()
	love.window.setMode(800, 800)
	controller:load(20, 20, 5, 20, 10, 1.7, 15, 20, 2.5, 2.5)	
end

function love.draw()
	map:draw()
	controller:draw()
end


