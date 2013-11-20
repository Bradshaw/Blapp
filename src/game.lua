local state = gstate.new()


function state:init()

end


function state:enter()
	love.mouse.setGrabbed(true)
	lives = 3
	gtime = 0
	inter = 1
	tkills = 0
	ckills = 0
	entries = 0
	global.difficulty = 0.5
	car.all = {}
	bullet.all = {}
	t = tank.new(3*global.width/4, global.height/2)
	for i=1,25 do
		
	end
	carspawn = 0
end


function state:focus()

end


function state:mousepressed(x, y, btn)
	if btn == "wu" then
		--t.weapon = (t.weapon%#tank.weapons) + 1
	else
		--table.insert(b, bullet.new(t.x,t.y,t.aim))
	end
end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	hard:setVolume(math.min(1,global.difficulty-0.5))

	gtime = gtime+dt
	inter = inter-dt
	if inter>0 then
		carspawn = 0.3
		if #car.all>0 and inter<1.98 then
			inter = 2
			car.all[1].hp=-5000
			thing.all[1].hp=-5000
		end
	else
		carspawn = carspawn-dt
	end
	if #thing.all<25 then
		thing.new()
	end
	global.difficulty = global.difficulty + 0.03*dt

	if inter<0.3 and lives<=0 then
		gstate.switch(endscreen)
	end

	if carspawn<=0 then
		local x = 0
		local y = 0
		if false then
			x = math.random(0,global.width)
			y = useful.tri(math.random()>0.5,0,global.height)
		else
			x = 0
			y = math.random(0,global.height)
		end
		local tx = math.random(global.width/3,2*global.width/3)
		local ty = math.random(global.height/3,2*global.height/3)
		carspawn = 0.5/global.difficulty
		car.new(x, y, (math.random()-0.5)/10)
	end

	t:update(dt)
	bullet.update(dt)
	car.update(dt)
	thing.update(dt)
	explode.update(dt)
	sparkle.update(dt)
end


function state:draw()

	if inter>1.9 and math.floor(gtime*20)%2==0 then
		love.graphics.setColor(global.colours[11])
		love.graphics.rectangle("fill",0,0,global.width,global.height)
	else
		--love.graphics.setColor(global.colours[12])
	end
	--love.graphics.rectangle("fill",0,0,global.width,global.height)
	car.draw()
	thing.draw()
	sparkle.draw()
	t:draw()
	bullet.draw()
	muzzle.draw()
	local b =math.sqrt(1-((global.time*3)%1))/2
	love.graphics.setColor(global.colours[3])
	love.graphics.draw(sprt,reticle,love.mouse.getX()/global.scale,love.mouse.getY()/global.scale,global.time*5,1+b,1+b,8,8)
	explode.draw()
end

return state