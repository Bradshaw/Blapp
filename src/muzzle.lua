muzzle = {}

muzzle.flare = {}

for i=1,3 do
	table.insert(muzzle.flare,useful.quad(8+i,0))
end

function muzzle.new(x,y,aim)
	table.insert(muzzle,{
		aim = aim,
		x = x,
		y = y,
		age = 0
	})
end

function muzzle.draw()
	local i = 1
	while i<=#muzzle do
		local v = muzzle[i]
		if v.age>8 then
			table.remove(muzzle,1)
		else
			love.graphics.draw(sprt,muzzle.flare[math.random(1,#muzzle.flare)], v.x, v.y, v.aim+math.pi/2,1,1,8,16)
			v.age = v.age+1
			i=i+1
		end
	end
end