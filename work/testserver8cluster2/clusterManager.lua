local skynet = require "skynet"
local skynet = require "skynet.manager"
local cluster = require "cluster"
local commonlog 	= require "common.log.commonlog"


local CMD 		= {}

local function connectToServer(nodeName)
    while true do
        local status, addr = xpcall(function()
            return cluster.query(nodeName, "clusterManager1")
        end, function(errormsg) 
            
        end)
        
        if status then
            commonlog.common.info("已连接"..nodeName)
            return addr
        end
    
        skynet.sleep(100)
    end
end


function CMD.sendheartbeat(nodeName)
    local addr = connectToServer(nodeName)
    
    skynet.fork(function()
        while true do
        	commonlog.common.info("sendheartbeat")
            local status = pcall(function()
                cluster.call(nodeName, addr, "heartbeat", "node"..skynet.getenv("gsIndex") , tonumber(skynet.getenv("gsIndex")))
            end)
            if not status then
                commonlog.common.info("连接不上"..nodeName)
                addr = connectToServer(nodeName)
            end
            skynet.sleep(500)
        end
    end)
end

skynet.start(function()
	skynet.dispatch("lua", function( session, source, command, ... )
		local f = CMD[command]
        if f then
            skynet.ret(skynet.pack(f(...)))
        end
	end)
end)
