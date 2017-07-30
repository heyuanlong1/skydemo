local testclass = {}

testclass.x = 0

function testclass.set( i )
	testclass.x = i
end

function testclass.get(  )
	return testclass.x
end

return testclass