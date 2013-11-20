local thing_mt = {}
thing = {}

thing.all = {}
thing.count = 0

thing.g_box = useful.quad(6,1)
thing.g_cross = useful.quad(7,1)

function thing.new( x, y, direction )
	local self = setmetatable({}, {__index=thing_mt})

	self.x = x or math.random(0,global.width)
	self.y = y or math.random(0,global.height)
	explode.new(self.x, self.y)
	self.hp = 0
	self.dx = 0
	self.dy = 0
	self.direction = direction or math.random()*math.tau

	table.insert(thing.all, self)

	return self
end

function thing.update( dt )
	local i = 1
	while i<=#thing.all do
		local v = thing.all[i]
		if v.purge then
			table.remove(thing.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function thing.draw()
	for i,v in ipairs(thing.all) do
		v:draw()
	end
end

function thing_mt:update( dt )

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	self.dx = self.dx - self.dx * dt * 10
	self.dy = self.dy - self.dy * dt * 10

	self.x = math.max(6, math.min(global.width-6, self.x))
	self.y = math.max(6, math.min(global.height-6, self.y))

	for i,v in ipairs(thing.all) do
		if v~=self then
			local dx = self.x-v.x
			local dy = self.y-v.y
			local d = math.sqrt(dx*dx+dy*dy)
			local nx = dx/d
			local ny = dy/d
			if d<11 then
				self.x = self.x+nx
				self.y = self.y+ny
				self.direction = self.direction + math.random()-0.5
			end
		end
	end
	for i,v in ipairs(car.all) do
		if v~=self then
			local dx = self.x-v.x
			local dy = self.y-v.y
			local d = math.sqrt(dx*dx+dy*dy)
			local nx = dx/d
			local ny = dy/d
			if d<11 then
				self.x = self.x+nx
				self.y = self.y+ny
				self.direction = self.direction + math.random()-0.5
			end
		end
	end
	if self.hp<=-2000 then
		self.purge = true
		for i=1,3 do
			explode.new(self.x,self.y)
		end
	end
	local dx = self.x-t.x
	local dy = self.y-t.y
	local d = math.sqrt(dx*dx+dy*dy)
	local nx = dx/d
	local ny = dy/d
	if d<12 then
		self.x = self.x+nx
		self.y = self.y+ny
		self.direction = self.direction + math.random()-0.5
	end
end

function thing_mt:draw(  )
	love.graphics.setColor(global.colours[10])
	love.graphics.draw(sprt,thing.g_box,self.x, self.y, self.direction+math.pi/2, 1, 1, 8, 8)

	love.graphics.setColor(global.colours[9])
	love.graphics.draw(sprt,thing.g_cross,self.x, self.y, self.direction+math.pi/2, 1, 1, 8, 8)
end