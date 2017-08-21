local skynet 		= require "skynet"
local gateserver 	= require "snax.gateserver"
local socketdriver 	= require "socketdriver"
local md5 			= require "md5"

local protobuf      = require "protobuf"
local pbCode        = require "pb/pbCode"

local fd


--加载pb
local pbFile
pbFile = io.open("work/pb/test.pb", "rb")
protobuf.register(pbFile:read("*a"))
pbFile:close()


local function response(msgID,resp)
    local respId = pbCode.getRepToResponseID(msgID)
    local pbmessage = pbCode.getProtoBuffStrByMsgID(respId)
    local msg = protobuf.encode(pbmessage , resp)
    local packet = string.pack(">s2", string.pack("<I4", respId)..msg)
    socketdriver.send(fd, packet)
end


local dealCmd = {}
dealCmd[pbCode.clientToServerMsg.wailiTestRegRequest] = function( req )
    local authCode = md5.sumhexa( req.id.."_"..tostring(skynet.time()) )
    print("------- authCode:"..authCode)

    local resp = {
        errorCode = 200,
        authCode = authCode,
    }
    response(pbCode.clientToServerMsg.wailiTestRegRequest,resp)
end
dealCmd[pbCode.clientToServerMsg.wailiTestLoginRequest] = function( req )
    local  userID = req.id
    local authCode =req.authCode
    if authCode == nil then
        print("nilnilnilnilnilnilnil")
    end
    if authCode == "" then
        print("nnnnnnnnnnnnnnnnnnnnnn") -- 打印这里
    end

    local resp = {
        errorCode = 200,
    }
    print("userID:"..userID.."authCode:"..authCode.." login success")
    response(pbCode.clientToServerMsg.wailiTestLoginRequest,resp)
end
dealCmd[pbCode.clientToServerMsg.wailiTestLpushRequest] = function( req )
    local value = req.num
    print("value:"..value)
    local resp = {
        errorCode = 200,
    }
    response(pbCode.clientToServerMsg.wailiTestLpushRequest,resp)
end


local CMD = {}

CMD.login = function (manager, f )
	fd = f
end

CMD.message = function ( packet )
	local msgId = string.unpack("<I4", packet)
    print("msgId:"..msgId)
    local msg = string.sub(packet, 5)
    print("msg length:"..#msg)

    local pbmessage = pbCode.getProtoBuffStrByMsgID(msgId)
    local req, errormsg = protobuf.decode(pbmessage, msg)

    local f = dealCmd[msgId]
    if f then
    	f(req)
	else
		print("msgId is error :"..msgId);
	end
end


skynet.start(function()
	skynet.dispatch("lua", function(_, _, command, ...)
    	if command == "message" then
                CMD["message"](...)
     	else
            local f = CMD[command]
            if f then
                skynet.ret(skynet.pack(f(...)))
            end
        end
	end)
end)
