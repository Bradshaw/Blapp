local explode_mt = {}
explode = {}

explode.all = {}

explode.circle = love.graphics.newQuad(0, 12*16, 64, 64, 256, 256)

explode.snd = love.audio.newSource("audio/splod.wav")
explode.snd:setVolume(0.7)

explode.canvas = love.graphics.newCanvas()

function explode.new( x, y )
	local self = setmetatable({},{__index=explode_mt})
	explode.snd:setPitch(1+(math.random()-0.5)/5)
	if explode.snd:isPlaying() then
		explode.snd:rewind()
	else
		explode.snd:play()
	end
	abb = abb + 0.5
	self.x = x + math.random(-5,5)
	self.y = y + math.random(-5,5)
	self.xoff = math.random(-5,5)
	self.yoff = math.random(-5,5)
	self.age = 0
	self.expand = 15

	self.inflicted = false

	---[[
	for i=1,5 do
		local d = math.random()*math.tau
		local v = math.random()*20
		local s  = sparkle.fire(
			self.x+math.cos(d)*v,
			self.y+math.sin(d)*v
		)
		s.dx = math.cos(d)
		s.dy = math.sin(d)
	end
	--]]

	table.insert(explode.all, self)
	return self
end

function explode.update( dt )
	local i = 1
	while i<=#explode.all do
		local v = explode.all[i]
		if v.purge then
			table.remove(explode.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function explode.draw()
	explode.canvas:clear()

	local canv  = love.graphics.getCanvas()
	love.graphics.setCanvas(explode.canvas)

	love.graphics.setColor(255,255,255)
	for i,v in ipairs(explode.all) do
		v:drawWhite()
	end

	love.graphics.setColor(0,0,0)
	for i,v in ipairs(explode.all) do
		v:drawBlack()
	end


	love.graphics.setColor(255,255,255)
	love.graphics.setCanvas(canv)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(explode.canvas)
	love.graphics.setBlendMode("alpha")
end

function explode_mt:update( dt )
	self.expand = self.expand + dt * 300
	self.age = self.age + dt * 500
	if self.age>self.expand+5 then
		self.purge = true
	end
	if not self.inflicted then
		self.inflicted = true
		for i,v in ipairs(car.all) do
			local dx = self.x-v.x
			local dy = self.y-v.y
			local d = math.sqrt(dx*dx+dy*dy)
			local nx = dx/d
			local ny = dy/d
			if d<30 then
				v.hp=v.hp-(30-d)*4
				v.dx = -nx * (50 - d) *3
				v.dy = -ny * (50 - d) *3
			end
		end
		for i,v in ipairs(thing.all) do
			local dx = self.x-v.x
			local dy = self.y-v.y
			local d = math.sqrt(dx*dx+dy*dy)
			local nx = dx/d
			local ny = dy/d
			if d<30 then
				v.hp=v.hp-(30-d)*4
				v.dx = -nx * (50 - d) *3
				v.dy = -ny * (50 - d) *3
			end
		end
	end
end

function explode_mt:drawWhite( ... )
	love.graphics.draw(sprt, explode.circle, self.x, self.y, 0, self.expand/64, self.expand/64, 32, 32)
end

function explode_mt:drawBlack( ... )
	love.graphics.draw(sprt, explode.circle, self.x+self.xoff, self.y+self.yoff, 0, self.age/64, self.age/64, 32, 32)
end