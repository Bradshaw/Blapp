local bullet_mt = {}
bullet = {}

bullet.all = {}

bullet.snd = love.audio.newSource("audio/pew.wav")

bullet.tracers = {}

for i=1,6 do
	table.insert(bullet.tracers,useful.quad(2+i,0))
end

function bullet.new(x, y, aim, off)
	abb = abb+1

	bullet.snd:setPitch(0.5+(math.random()-0.5)/5)
	if bullet.snd:isPlaying() then
		bullet.snd:rewind()
	else
		bullet.snd:play()
	end
	local self = setmetatable({},{__index=bullet_mt})

	self.aim = aim + (math.random()*2-1) * 0.05

	self.x = x+math.cos(aim)*(off or 8)
	self.y = y+math.sin(aim)*(off or 8)
	self.dx = math.cos(self.aim)
	self.dy = math.sin(self.aim)

	self.length = 10

	self.speed = 500
	self.time = 0

	self.drawn = false

	muzzle.new(self.x,self.y,self.aim)
	for i=1,4 do
		local s = sparkle.smoke(self.x, self.y)
		s.dx = s.dx/2+self.dx
		s.dy = s.dy/2+self.dy
	end
	table.insert(bullet.all, self)
	return self
end

function bullet_mt:checkHit( ... )
	
end

function bullet.update( dt )
	local i = 1
	while i<=#bullet.all do
		local v = bullet.all[i]
		if v.purge then
			for i=1,3 do
				explode.new(v.x, v.y)
			end
			table.remove(bullet.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function bullet.draw()
	for i,v in ipairs(bullet.all) do
		v:draw()
	end
end

function bullet_mt:update( dt )
	self.x = self.x + self.speed*self.dx*dt
	self.y = self.y + self.speed*self.dy*dt
	self.time= self.time-dt
	if self.time<0 then
		local s = sparkle.smoke(self.x,self.y)
		--s.dx=self.dx
		--s.dy=self.dy
		s.dx=self.dx/3
		s.dy=self.dy/3
		self.time = 0.01*math.random()
	end
	for i,v in ipairs(car.all) do
		local dx = self.x-v.x
		local dy = self.y-v.y
		local d = math.sqrt(dx*dx+dy*dy)
		if d<10 then
			self.x = self.x-self.dx*5
			self.y = self.y-self.dy*5
			self.purge = true
			return
		end
	end
	for i,v in ipairs(thing.all) do
		local dx = self.x-v.x
		local dy = self.y-v.y
		local d = math.sqrt(dx*dx+dy*dy)
		if d<10 then
			self.x = self.x-self.dx*5
			self.y = self.y-self.dy*5
			self.purge = true
			return
		end
	end
	if self.x>global.width or self.x<0 or self.y>global.height or self.y<0 then
		self.purge = true
	end
end



function bullet_mt:draw(  )
	love.graphics.setColor(255,255,255)
	love.graphics.draw(sprt, bullet.tracers[math.random(1,#bullet.tracers)], self.x, self.y, self.aim+math.pi/2, 1, self.length/16, 8,16)
end