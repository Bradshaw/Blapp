local car_mt = {}
car = {}

car.g_body = useful.quad(4,1)
car.g_windows = useful.quad(5,1)

car.all = {}
car.count = 0

function car.new( x, y, direction )
	local self = setmetatable({}, {__index=car_mt})

	car.count = car.count+1
	self.swerve = math.random()*math.tau
	self.terrorist = (car.count%10)==9
	self.x = x or math.random(0,global.width)
	self.y = y or math.random(0,global.height)
	self.dx = 0
	self.dy = 0
	self.hp = 100
	self.direction = direction or math.random()*math.tau

	table.insert(car.all, self)

	return self
end

function car.update( dt )
	local i = 1
	while i<=#car.all do
		local v = car.all[i]
		if v.purge then
			table.remove(car.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function car.draw()
	for i,v in ipairs(car.all) do
		v:draw()
	end
end

function car_mt:update( dt )

	self.swerve = self.swerve + dt
	if not self.dead and inter<=0 then
		self.dx = self.dx + useful.tri(self.terrorist,500,300) * dt * math.cos(self.direction) * global.difficulty
		self.dy = self.dy + useful.tri(self.terrorist,500,300) * dt * math.sin(self.direction) * global.difficulty
	end

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	self.dx = self.dx - self.dx * dt * 10
	self.dy = self.dy - self.dy * dt * 10

	--self.x = math.max(6, math.min(global.width-6, self.x))
	self.y = math.max(6, math.min(global.height-6, self.y))
	if self.x>global.width+10 then
		self.purge = true
		if self.terrorist then
			lives = lives - 1
			inter = 2
		else
			entries = entries + 1
		end
	end

	if self.hp<0 then
		self.dead = true
	end

	if self.hp<-5000 then
		self.purge = true
		for i=1,3 do
			explode.new(self.x,self.y)
		end
		if inter<=0 then
			if self.terrorist then
				tkills = tkills + 1
			else
				ckills = ckills + 1
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
			if d<10 then
				self.x = self.x+nx
				self.y = self.y+ny
				self.direction = self.direction + math.random()-0.5
			end
		end
	end
	self.direction = self.direction - self.direction*dt + useful.tri(self.terrorist,math.sin(self.swerve) * dt * 0.5,0)
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

	if self.dead then
		self.hp = self.hp - 500*dt
		if math.random()>0.99 then
			sparkle.fire(self.x, self.y)
		end
	end
end

function car_mt:draw(  )
	love.graphics.setColor(global.colours[useful.tri(self.dead,12,useful.tri(self.terrorist,3,6))])
	love.graphics.draw(sprt,car.g_body,self.x, self.y, self.direction+math.pi/2, 1, 1, 8, 8)

	love.graphics.setColor(global.colours[useful.tri(self.dead,1,4)])
	love.graphics.draw(sprt,car.g_windows,self.x, self.y, self.direction+math.pi/2, 1, 1, 8, 8)
end