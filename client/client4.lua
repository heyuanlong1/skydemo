package.cpath = "skynetlib/luaclib/?.so"
package.path = "skynetlib/lualib/?.lua;work/pb/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end

local socket        = require "clientsocket"
local protobuf      = require "protobuf"
local pbCode        = require "pbCode"

local myid = ...
local fd = assert(socket.connect("127.0.0.1", 9024))

--加载pb
local pbFile
pbFile = io.open("work/pb/test.pb", "rb")
protobuf.register(pbFile:read("*a"))
pbFile:close()




local stringbuffer = protobuf.encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestRegRequest),
    {
        id = myid,
    })

print(stringbuffer)
socket.send(fd, string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestRegRequest)..stringbuffer) )
local str   = socket.recv(fd)
if str == nil or str == "" then
    socket.close(fd)
    os.exit(0)
end

local packet = string.unpack(">s2", str)
local msgId = string.unpack("<I4", packet)
local msg = string.sub(packet, 5)
local req, errormsg = protobuf.decode(pbCode.getProtoBuffStrByMsgID(msgId), msg, #msg)
local authCode = req.authCode
print("msgId:"..msgId)
print("authCode:"..authCode)
print("reg success")


local stringbuffer = protobuf.encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestLoginRequest),
    {
        id = myid,
        authCode = authCode,
    })
print(stringbuffer)
local msgsend = string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestLoginRequest) ..stringbuffer)
print("msgsend length:"..#msgsend)
socket.send(fd, msgsend)
print("socket.send")
-- local str = nil
-- while true do
--     str   = socket.recv(fd)
--     print("socket.recv")
--     if str ~= nil  and str ~= "" then
--         break
--     end
-- end

local str   = socket.recv(fd)
print(str)
if str == nil  or str == "" then
    print("str error login")
    socket.close(fd)
    os.exit(0)
end

local packet = string.unpack(">s2", str)
local msgId = string.unpack("<I4", packet)
local msg = string.sub(packet, 5)
local req, errormsg = protobuf.decode(pbCode.getProtoBuffStrByMsgID(msgId), msg, #msg)
print("msgId:"..msgId)
print("login:"..req.errorCode)



while true do
    -- 读取用户输入消息
    local readstr = socket.readstdin()
    if readstr then

        if readstr == "quit" then
            socket.close(fd)
            break;
        elseif readstr == "getsort" then
            local stringbuffer = protobuf.encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestSortRequest),
                {
                 
                })
            socket.send(fd, string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestSortRequest) ..stringbuffer))
        else
            -- 把用户输入消息发送给服务器
            local num = tonumber(readstr)
            if num ~= nil then
                local stringbuffer = protobuf.encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestLpushRequest),
                    {
                        id = myid,
                        num = num,
                    })
                local  msgsend  = string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestLpushRequest) ..stringbuffer)
                print("msg length:"..#stringbuffer)
                socket.send(fd, msgsend)
            end
        end
    else
        socket.usleep(100)
    end



    local str   = socket.recv(fd)
    if str ~= nil then
        if str == nil  or str == "" then
            socket.close(fd)
            os.exit(0)
        end
        local packet = string.unpack(">s2", str)
        local msgId = string.unpack("<I4", packet)
        local msg = string.sub(packet, 5)
        print("msgId:"..msgId)
        local req, errormsg = protobuf.decode(pbCode.getProtoBuffStrByMsgID(msgId), msg, #msg)
        if msgId == pbCode.clientToServerMsg.wailiTestLpushResponse then
            print("lpush:"..req.errorCode)
        elseif msgId == pbCode.clientToServerMsg.wailiTestSortResponse then
            print("value:"..req.value)
        else
            print("unknow msgid")
        end

    end
end
