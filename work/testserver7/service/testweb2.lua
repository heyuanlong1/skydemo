local skynet 		= require "skynet"
require "skynet.manager"
local utils 		= require "common.tools.utils"
local json 			= require "common.tools.json"
local commonlog 	= require "common.log.commonlog"


local CMD = {}

function CMD.run(query)
	
	for k,v in pairs(query) do
		commonlog.web.error(k..":"..v)
	end	

	local udata = utils.urldecode(query.data)

	local status, arg = pcall(function() return json.decode(udata) end)
	if status and type(arg) == "table" then
		for k,v in pairs(arg) do
			commonlog.web.error("shuchu:"..k..":"..v)
		end
	else
		commonlog.web.error("json.decode,error:"..arg)
		return utils.getErrResponse(1001,"json decode error")
	end

	local x 	= {}
	x.id 		= 1201
	x.name		="heyuanlong"
	local msg 	= utils.getSuccessResponse(x)
    return msg

end




skynet.start(function()
    skynet.register(".testweb2")
    skynet.dispatch("lua", function(_, _, command, ...)
        local f = CMD[command]
        skynet.ret(skynet.pack(f(...)))
    end)


end)
