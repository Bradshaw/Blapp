global = {
	scale = 3,
	time = 0,
	difficulty = 0.5
}

global.colours = {}

table.insert(global.colours, {0,	0,	0})
table.insert(global.colours, {255,	255,	255})
table.insert(global.colours, {152,	75,	67})
table.insert(global.colours, {120,	193,	200})
table.insert(global.colours, {155,	81,	166})
table.insert(global.colours, {105,	174,	93})
table.insert(global.colours, {83,	66,	158})
table.insert(global.colours, {201,	214,	134})
table.insert(global.colours, {155,	102,	58})
table.insert(global.colours, {106,	84,	0})
table.insert(global.colours, {196,	123,	117})
table.insert(global.colours, {99,	99,	99})
table.insert(global.colours, {138,	138,	138})
table.insert(global.colours, {163,	230,	153})
table.insert(global.colours, {138,	123,	206})
table.insert(global.colours, {173,	173,	173})

global.width = love.graphics.getWidth()/global.scale
global.height = love.graphics.getHeight()/global.scale

hard = love.audio.newSource("audio/hardtek.wav")

function love.load(arg)
	require("useful")

	abb = 0

	display  = love.graphics.newCanvas(512,512)
	display:setFilter("nearest","nearest")

	screen  = love.graphics.newCanvas(512,512)
	screen:setFilter("nearest","nearest")
	
	love.mouse.setVisible(false)
	reticle = useful.quad(2,0)
	hard:setLooping(true)
	hard:setVolume(0)
	hard:play()


	require("tank")
	require("thing")
	require("car")
	require("explode")
	require("bullet")
	require("muzzle")
	require("sparkle")
	sprt = love.graphics.newImage("images/spritemap.png")
	sprt:setFilter("nearest","nearest")

	gstate = require "gamestate"
	game = require("game")
	endscreen = require("endscreen")
	gstate.switch(game)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function keyreleased(key, uni)
	gstate.keyreleased(key)
end

local max_dt = 1/30
function love.update(dt)
	local dt = math.min(max_dt,dt)
	abb = math.max(0,math.min(1,abb-dt*5))
	--abb = 0.75
	gstate.update(dt)
	global.time = global.time+dt
end

function love.draw()
	screen:clear()
	display:clear()
	love.graphics.setCanvas(screen)
	gstate.draw()


	love.graphics.push()
	love.graphics.setCanvas(display)
	love.graphics.setBlendMode("additive")

	love.graphics.setColor(255,0,0)
	love.graphics.draw(screen,abb*math.random(),0)
	love.graphics.setColor(0,255,0)
	love.graphics.draw(screen,-abb*math.random(),abb*math.random())
	love.graphics.setColor(0,0,255)
	love.graphics.draw(screen,0,-abb*math.random())

	love.graphics.pop()

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255)
	love.graphics.setCanvas()
	love.graphics.scale(global.scale)
	love.graphics.draw(display)

end

print("Loaded!")