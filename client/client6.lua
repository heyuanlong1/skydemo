package.cpath = "skynetlib/luaclib/?.so"
package.path = "skynetlib/lualib/?.lua;work/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end

local socket 		= require "clientsocket"
local proto         = require "sprotorpc.proto"
local sproto        = require "sproto"



local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local fd = assert(socket.connect("127.0.0.1", 9026))
local session = 0
local last = ""

--------------------------------------------------------------------------------------
local function send_package(fd, pack)              --发送数据
    local package = string.pack(">s2", pack)
    socket.send(fd, package)
end


local function send_request(name, args)
    session = session + 1
    local str = request(name, args, session)      --返回特定的 sproto rpc格式数据
    send_package(fd, str)
    print("Request:", session)
end

--------------------------------------------------------------------------------------
local function unpack_package(text)
    local size = #text
    if size < 2 then
        return nil, text
    end
    local s = text:byte(1) * 256 + text:byte(2)
    if size < s+2 then
        return nil, text
    end

    return text:sub(3,2+s), text:sub(3+s)
end

local function recv_package(last)
    local result
    result, last = unpack_package(last)
    if result then
        return result, last
    end
    local r = socket.recv(fd)
    if not r then
        return nil, last
    end
    if r == "" then
        error "Server closed"
    end
    return unpack_package(last .. r)
end

local function print_request(name, args)
    print("REQUEST", name)
    if args then
        for k,v in pairs(args) do
            print(k,v)
        end
    end
end

local function print_response(session, args)
    print("RESPONSE", session)
    if args then
        for k,v in pairs(args) do
            print(k,v)
        end
    end
end

local function print_package(t, ...)
    if t == "REQUEST" then
        print_request(...)
    else
        assert(t == "RESPONSE")
        print_response(...)
    end
end

local function dispatch_package()
    while true do
        local v
        v, last = recv_package(last)
        if not v then
            break
        end

        print_package(host:dispatch(v))
    end
end

--------------------------------------------------------------------------------------

send_request("handshake")
send_request("set", { what = "hello", value = "world" })
while true do
    dispatch_package()
    local cmd = socket.readstdin()
    if cmd then
        if cmd == "quit" then
            send_request("quit")
        else
            send_request("get", { what = cmd })
        end
    else
        socket.usleep(100)
    end
end