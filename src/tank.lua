require("useful")

local tank_mt = {
	accel = 200,
	damp = 5
}
tank = {}

tank.quad = useful.quad(0,0)
tank.turret = useful.quad(1,0)
tank.cannon = useful.quad(0,1)
tank.autocannon = useful.quad(1,1)
tank.launcher = useful.quad(2,1)
tank.gatling = useful.quad(3,1)

tank.weapons = {
	tank.cannon,
	tank.autocannon,
	tank.launcher,
	tank.gatling
}

useful.quad(0,0)

function tank.new(x,y,heading)
	local self = setmetatable({},{__index=tank_mt})


	self.x = x or math.random(0,global.width)
	self.y = y or math.random(0,global.height)
	self.heading = math.pi
	self.aim = math.pi
	self.currentspeed = 0
	self.currentrotate = 0
	self.weapon = 4

	self.cooldown = 0

	return self
end

function tank_mt:update( dt )

	self.cooldown = self.cooldown - dt

	if love.keyboard.isDown("up", "z", "w") then
		self.currentspeed = self.currentspeed + self.accel * dt
	end
	if love.keyboard.isDown("down", "s") then
		self.currentspeed = self.currentspeed - self.accel * dt
	end
	self.currentspeed = self.currentspeed - self.currentspeed * self.damp * dt
	if love.keyboard.isDown("left", "q", "a") then
		self.currentrotate = self.currentrotate - self.accel * dt
	end
	if love.keyboard.isDown("right", "d") then
		self.currentrotate = self.currentrotate + self.accel * dt
	end
	self.currentrotate = self.currentrotate - self.currentrotate * self.damp * dt
	self.x = self.x+math.cos(self.heading)*self.currentspeed*dt
	self.y = self.y+math.sin(self.heading)*self.currentspeed*dt
	self.heading = self.heading + self.currentrotate*dt*0.05


	if love.mouse.isDown("l") and self.cooldown<=0 then
		bullet.new(self.x-math.cos(self.heading)*2,self.y-math.sin(self.heading)*2,t.aim)
		self.cooldown = 0.3
	end


	local dx = self.x-(love.mouse.getX()/global.scale)
	local dy = self.y-(love.mouse.getY()/global.scale)
	local d = math.sqrt(dx*dx+dy*dy)
	local nx = dx/d
	local ny = dy/d

	if nx and ny then
		local det = (dx*math.sin(self.aim) - dy*math.cos(self.aim))
		self.aim = self.aim + useful.sign(det)*dt*5
	end

	self.x = math.max(10, math.min(global.width-10,self.x))
	self.y = math.max(10, math.min(global.height-10,self.y))

end

function tank_mt:draw()

	love.graphics.setColor(138,123,206)
	love.graphics.draw(sprt,tank.quad,self.x,self.y,self.heading+math.pi/2,1,1,8,8)

	love.graphics.setColor(83,66,158)
	love.graphics.draw(sprt,tank.turret,self.x,self.y,self.heading+math.pi/2,1,1,8,8)

	love.graphics.setColor(155,81,166)
	love.graphics.draw(sprt,tank.weapons[self.weapon],self.x-math.cos(self.heading)*2,self.y-math.sin(self.heading)*2,self.aim+math.pi/2,1,1,8,13)

end