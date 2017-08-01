local skynet 		= require "skynet"
local gateserver 	= require "snax.gateserver"
local socketdriver 	= require "socketdriver"
local netpack   = require "netpack"


local connctionAgents = {}


local handler = {}
function handler.open(source, conf)
end

local function closeFd(fd)
    gateserver.closeclient(fd)  			-- 关闭 fd
    connctionAgents[fd] = nil
end

function handler.connect(fd, addr)
    local agent = skynet.newservice("agent")
    skynet.call(agent, "lua", "login", skynet.self(), fd)
    connctionAgents[fd] = agent
    gateserver.openclient(fd)   			-- 允许 fd 接收消息
end

function handler.disconnect(fd)
    closeFd(fd)
end

function handler.error(fd, msg)
    closeFd(fd)
end


function handler.message(fd, msg, sz)		--处理网络包
	if connctionAgents[fd] ~= nil then
	    local packet = netpack.tostring(msg, sz)
	    skynet.call(connctionAgents[fd], "lua", "message", packet)
    end
end

function handler.command(cmd, source, ...)
end

gateserver.start(handler)
