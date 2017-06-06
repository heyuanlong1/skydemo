local skynet = require "skynet"
local skynet = require "skynet.manager"
local cluster = require "cluster"
local commonlog     = require "common.log.commonlog"


local CMD 		= {}
local simpledb  = {}

function CMD.set(key ,value)
    commonlog.common.info("key:"..key.." value:"..value)
    local last = simpledb[key]
    simpledb[key] = value
    return last
end
function CMD.get(key)
    commonlog.common.info("key:"..key)
    return simpledb[key]
end

skynet.start(function()
	skynet.dispatch("lua", function( session, source, command, ... )
		local f = CMD[command]
        if f then
            skynet.ret(skynet.pack(f(...)))
        end
	end)
end)
