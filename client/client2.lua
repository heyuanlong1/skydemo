package.cpath = "skynetlib/luaclib/?.so"
package.path = "skynetlib/lualib/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end

local socket = require "clientsocket"
local fd = assert(socket.connect("127.0.0.1", 9021))
local x = 0
while true do
	x = x + 1
    socket.send(fd, string.pack(">s2", "client2..."..x) )
    local str   = socket.recv(fd)
    if str ~= nil then
        print("msg:"..str)
    end
    socket.usleep(1000000)
end
