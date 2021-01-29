function table.clone(t)
	local newT = {}
  	for i,v in ipairs(t) do 
  		table.insert(newT, v)
  	end
  	return newT
end

function distance(x, y, x2, y2)
	return math.sqrt(math.pow(x2 - x, 2) + math.pow(y2 - y, 2))
end

function vecLength(x, y)
	return distance(0, 0, x, y)
end

function vecNormalize(x, y)
	local len = vecLength(x, y)
	if len == 0 then return 0, 0 end
	return x / len, y / len
end