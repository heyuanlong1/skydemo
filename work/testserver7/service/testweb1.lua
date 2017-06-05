local skynet 		= require "skynet"
require "skynet.manager"
local utils 		= require "common.tools.utils"
local commonlog 	= require "common.log.commonlog"


local CMD = {}

function CMD.run(query)
	
	for k,v in pairs(query) do
		commonlog.web.error(k..":"..v)
	end

	local x 	= {}
	x.id 		= 1201
	x.name		="heyuanlong"
	local msg 	= utils.getSuccessResponse(x)
    return msg

end




skynet.start(function()
    skynet.register(".testweb1")
    skynet.dispatch("lua", function(_, _, command, ...)
        local f = CMD[command]
        skynet.ret(skynet.pack(f(...)))
    end)


end)
