package.cpath = "skynetlib/luaclib/?.so"
package.path = "skynetlib/lualib/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end

local socket = require "clientsocket"
local fd = assert(socket.connect("127.0.0.1", 9021))

while true do
    socket.send(fd, string.pack(">s2", "client2...") )
    local str   = socket.recv(fd)
    if str ~= nil then
        print("msg:"..str)
    end
    socket.usleep(100000)
end
