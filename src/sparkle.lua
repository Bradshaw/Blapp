local sparkle_mt = {}
sparkle = {}


sparkle.all = {}

function sparkle.new( x, y, graphic, colour )
	local self = setmetatable({},{__index=sparkle_mt})

	self.x = x
	self.y = y
	self.graphic = graphic
	self.colour = colour
	local direction = math.random()*math.tau
	self.dx = math.cos(direction)
	self.dy = math.sin(direction)
	self.speed = 10
	self.rot = math.random()*3*useful.tri(math.random()>0.5,1,-1)
	self.age = math.random()-0.5


	table.insert(sparkle.all, self)
	return self
end

sparkle.graphics = {}
sparkle.graphics.smoke = {}
for i=1,4 do
	table.insert(sparkle.graphics.smoke, useful.quad(12+i, 0))
end

function sparkle.smoke( x, y )
	local graphic = sparkle.graphics.smoke[math.random(1, #sparkle.graphics.smoke)]
	return sparkle.new(x, y, graphic,math.random(12,13))
end

function sparkle.fire( x, y )
	local graphic = sparkle.graphics.smoke[math.random(1, #sparkle.graphics.smoke)]
	return sparkle.new(x, y, graphic,useful.tri(math.random()>0.5,3,8))
end

function sparkle.update( dt )
	local i = 1
	while i<=#sparkle.all do
		local v = sparkle.all[i]
		if v.purge then
			table.remove(sparkle.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function sparkle.draw()
	for i,v in ipairs(sparkle.all) do
		v:draw()
	end
end


function sparkle_mt:update( dt )
	self.x = self.x + self.dx * dt * self.speed
	self.y = self.y + self.dy * dt * self.speed
	self.age = self.age + dt
	if self.age > 1 then
		self.purge = true
	end
end


function sparkle_mt:draw()
	love.graphics.setColor(global.colours[self.colour])
	love.graphics.draw(sprt, self.graphic, self.x, self.y, self.age*self.rot, 1, 1, 8, 8)
end
