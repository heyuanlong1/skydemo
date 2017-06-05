package.cpath = "skynetlib/luaclib/?.so"
package.path = "skynetlib/lualib/?.lua;work/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end

local socket 		= require "clientsocket"
local testproto 	= require "sproto.testproto"
local pbCode 		= require "sproto.pbCode"


local myid = 1201
local fd = assert(socket.connect("127.0.0.1", 9023))


local stringbuffer = testproto:encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestRegRequest),
    {
        id = myid,
    })
socket.send(fd, string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestRegRequest)..stringbuffer) )
local str   = socket.recv(fd)
if str == nil or str == "" then
	print("str == nil")
    socket.close(fd)
    os.exit(0)
end
local packet = string.unpack(">s2", str)
local msgId = string.unpack("<I4", packet)
local msg = string.sub(packet, 5)
local req, errormsg = testproto:decode(pbCode.getProtoBuffStrByMsgID(msgId), msg, #msg)
local authCode = req.authCode
print("msgId:"..msgId)
print("authCode:"..authCode)
print("reg success")




local stringbuffer = testproto:encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestLoginRequest),
    {
        id = myid,
        authCode = authCode,
    })

local msgsend = string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestLoginRequest) ..stringbuffer)
socket.send(fd, msgsend)
local str   = socket.recv(fd)
if str == nil  or str == "" then
    print("str error login")
    socket.close(fd)
    os.exit(0)
end
local packet = string.unpack(">s2", str)
local msgId = string.unpack("<I4", packet)
local msg = string.sub(packet, 5)
local req, errormsg = testproto:decode(pbCode.getProtoBuffStrByMsgID(msgId), msg, #msg)
print("msgId:"..msgId)
print("login:"..req.errorCode)





while true do
    -- 读取用户输入消息
    local readstr = socket.readstdin()
    if readstr then

        if readstr == "quit" then
            socket.close(fd)
            break;
        elseif readstr == "single" then
            local stringbuffer = testproto:encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestSingleValueRequest),
                {
                    key        = "key",
                    value      = "value",
                    sign       = "sign",
                })
            socket.send(fd, string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestSingleValueRequest) ..stringbuffer))
        elseif readstr == "multi" then
            local stringbuffer = testproto:encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestMultiValueRequest),
                {
                    key        = {"key1","key2","key3"},
                    value      = {"value1","value2","value3"},
                    sign       = "sign",
                })
            socket.send(fd, string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.wailiTestMultiValueRequest) ..stringbuffer))
        elseif readstr == "book" then
            local ab = {
                    person = {
                        [10000] = {
                            name = "Alice",
                            id = 10000,
                            phone = {
                                { number = "123456789" , type = 1 },
                                { number = "87654321" , type = 2 },
                            }
                        },
                        [20000] = {
                            name = "Bob",
                            id = 20000,
                            phone = {
                                { number = "01234567890" , type = 3 },
                            }
                        }
                    },
                    others = {
                        {
                            name = "Carol",
                            id = 30000,
                            phone = {
                                { number = "9876543210" },
                            }
                        },
                    }
                }
            local stringbuffer = testproto:encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.AddressBookRequest),ab)
            socket.send(fd, string.pack(">s2", string.pack("<I4", pbCode.clientToServerMsg.AddressBookRequest) ..stringbuffer))
        else
            -- 把用户输入消息发送给服务器
            local num = tonumber(readstr)
            if num ~= nil then
                local stringbuffer = testproto:encode(  pbCode.getProtoBuffStrByMsgID(pbCode.clientToServerMsg.wailiTestLpushRequest),
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
        local req, errormsg = testproto:decode(pbCode.getProtoBuffStrByMsgID(msgId), msg, #msg)
        if msgId == pbCode.clientToServerMsg.wailiTestLpushResponse then
            print("lpush:"..req.errorCode)
        elseif msgId == pbCode.clientToServerMsg.wailiTestSortResponse then
            print("value:"..req.value)
        else
            print("unknow msgid")
        end

    end
end
