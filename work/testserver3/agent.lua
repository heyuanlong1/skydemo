local skynet 		= require "skynet"
local gateserver 	= require "snax.gateserver"
local socketdriver 	= require "socketdriver"
local md5 			= require "md5"

local testproto 	= require "sproto.testproto"
local pbCode 		= require "sproto.pbCode"

local fd

local function response(msgID,resp)
    local respId = pbCode.getRepToResponseID(msgID)
    local pbmessage = pbCode.getProtoBuffStrByMsgID(respId)
    local msg = testproto:encode(pbmessage , resp)
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
dealCmd[pbCode.clientToServerMsg.wailiTestSingleValueRequest] = function( req )
    print("key:"..req.key)
    print("value:"..req.value)
    print("sign:"..req.sign)
    local resp = {
        errorCode = 200,
    }
    response(pbCode.clientToServerMsg.wailiTestSingleValueRequest,resp)
end
dealCmd[pbCode.clientToServerMsg.wailiTestMultiValueRequest] = function( req )

    for i,v in ipairs(req.key) do
     print(i,v)
    end
    for i,v in ipairs(req.value) do
     print(i,v)
    end
    print("sign:"..req.sign)
    local resp = {
        errorCode = 200,
    }
    response(pbCode.clientToServerMsg.wailiTestMultiValueRequest,resp)
end
dealCmd[pbCode.clientToServerMsg.AddressBookRequest] = function( req )
    for k,v in pairs(req.person) do
         print("name:"..v.name)
         print("id:"..v.id )
         print("email :"..(v.email or "") )
         for i,v in ipairs(v.phone) do
             print(i,v.number," ",v.type)
         end
    end
    for i,v in ipairs(req.others) do
         print("name:"..v.name)
         print("id:"..v.id )
         print("email :"..(v.email or "") )
         for i,v in ipairs(v.phone) do
             print(i,v.number," ",v.type)
         end
    end

    local resp = {
        errorCode = 200,
    }
    response(pbCode.clientToServerMsg.AddressBookRequest,resp)
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
    local req, errormsg = testproto:decode(pbmessage, msg)

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
