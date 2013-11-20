useful = {}

math.tau = math.pi * 2


function useful.quad(i, j)
	return love.graphics.newQuad(i*16,j*16,16,16,256,256)
end

function useful.tri(cond, yes, no)
	if cond then
		return yes
	else
		return no
	end
end

function useful.sign(n)
	if n==0 then
		return 0
	else
		return useful.tri(n>0,1,-1)
	end
end

function useful.lerp(n, a, b)
	return b*n+a*(n-1)
end