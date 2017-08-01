local skynet 		= require "skynet"
local gateserver 	= require "snax.gateserver"
local socketdriver 	= require "socketdriver"
local netpack   = require "netpack"

local connctionAgents = {}
skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
}

local handler = {}
function handler.open(source, conf)
end

local function closeFd(fd)
    gateserver.closeclient(fd)  			-- 关闭 fd
    connctionAgents[fd] = nil               -- 落了关闭agent 服务
end

function handler.connect(fd, addr)
    local agent = skynet.newservice("agent")
    skynet.call(agent, "lua", "start", skynet.self(), fd)
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
	    --skynet.call(connctionAgents[fd], "client",  msg,sz)
        skynet.redirect(connctionAgents[fd], 0, "client", 0, msg, sz)
    end
end

function handler.command(cmd, source, ...)
end

gateserver.start(handler)
