local skynet = require "skynet"
local skynet = require "skynet.manager"
local cluster = require "cluster"
local commonlog 	= require "common.log.commonlog"



local gsMap  	= {}
local gsList 	= {}

local CMD 		= {}


function CMD.start()
    cluster.open("s1")
    cluster.register("clusterManager1")
        
    --移除没有心跳的gs
    skynet.fork(function()
        while true do
            local now = skynet.now()
            for i, gs in ipairs(gsList) do
                if (now - gs.lastTime) > 600 then

                    commonlog.common.info("移除nodename :%s index:%d", gs.name,gs.index)

                    gsMap[gs.index] = nil
                    table.remove(gsList, i)                   
                end
            end
            skynet.sleep(100)
        end
    end)
end


function CMD.heartbeat(nodeName, gsIndex)
    if gsMap[gsIndex] then
        gsMap[gsIndex].lastTime = skynet.now()
        commonlog.common.info("heartbeat %s", nodeName)
    else
        commonlog.common.info("添加gameserver%d", gsIndex)
        local gs = 
        {
            index = gsIndex,
            name = nodeName,
            lastTime = skynet.now(),
        }

        gsMap[gsIndex] = gs
        table.insert(gsList, gs)
    end
end

skynet.start(function()
	skynet.dispatch("lua", function( _, _, command, ... )
		local f = CMD[command]
        if f then
            skynet.ret(skynet.pack(f(...)))
        end
	end)
end)
