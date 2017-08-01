local skynet 		= require "skynet"
local gateserver 	= require "snax.gateserver"
local socketdriver  = require "socketdriver"
local netpack 	= require "netpack"



local handler = {}

function handler.open(source, conf)
    
end

local function closeFd(fd)
    gateserver.closeclient(fd)  -- 关闭 fd
end

function handler.connect(fd, addr)
    gateserver.openclient(fd)   -- 允许 fd 接收消息
end

function handler.disconnect(fd)
    closeFd(fd)
end

function handler.error(fd, msg)
    closeFd(fd)
end

--处理网络包
function handler.message(fd, msg, sz)

    local packet = netpack.tostring(msg, sz)
    print("packet:"..packet.."___111111111111")
    skynet.sleep(5 * 100)
    print("packet:"..packet.."___222222222222")
    socketdriver.send(fd, packet)
    
end

function handler.command(cmd, source, ...)
	
end

gateserver.start(handler)
