local state = gstate.new()


function state:init()

end


function state:enter()
	love.mouse.setGrabbed(false)
end


function state:focus()

end


function state:mousepressed(x, y, btn)
	
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
	if key=="return" then
		gstate.switch(game)
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	t:update(dt)
	bullet.update(dt)
	car.update(dt)
	explode.update(dt)
	sparkle.update(dt)
end


function state:draw()

	love.graphics.setColor(255,255,255)
	love.graphics.print("Game over",10,10)
	love.graphics.print("Survived "..(math.floor(gtime*100)/100).." seconds",10,30)
	love.graphics.print("Destroyed "..tkills.." insurgents",10,50)
	love.graphics.print("Killed "..ckills.." civilians",10,70)
	love.graphics.print("Vehicles past the checkpoint: "..entries,10,90)
	love.graphics.print("Military score: "..(math.floor(gtime)*70+tkills*10-ckills+entries*10),10,110)
	love.graphics.print("Ghandi score: "..(math.floor(gtime)-ckills*30+entries*100),10,130)
	love.graphics.print("G.W. Bush score: "..(math.floor(gtime)*10+tkills*300+ckills*50-entries),10,150)



end

return state