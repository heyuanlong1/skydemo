local skynet 		= require "skynet"



local CMD = {}
local x={}
	
CMD.start = function ( )
    print("----------------")

    for i=10000,510000 do
        x[i] = 20
    end

    for i=210000,211000 do
        print(x[i])
    end
    
	print("++++++++++++++++")
    skynet.sleep(5*100)
    x=nil
    x={}
    print("++++++++++++++++")
end


skynet.start(function()
	skynet.dispatch("lua", function(_, _, command, ...)
        local f = CMD[command]
        if f then
            skynet.ret(skynet.pack(f(...)))
        end
	end)
end)
