
local pbCode = {}

-- 消息ID定义
pbCode.clientToServerMsg = {
	wailiTestRegRequest					= 111,
	wailiTestRegResponse				= 112,
	wailiTestLoginRequest				= 113,
	wailiTestLoginResponse				= 114,
	wailiTestLpushRequest				= 115,
	wailiTestLpushResponse				= 116,
	wailiTestSingleValueRequest			= 117,
	wailiTestSingleValueResponse		= 118,
	wailiTestMultiValueRequest			= 119,
	wailiTestMultiValueResponse			= 120,
	AddressBookRequest					= 121,
	AddressBookResponse					= 122,
}



-- req - > rep
local repToResponse = {
	[pbCode.clientToServerMsg.wailiTestRegRequest] 				= pbCode.clientToServerMsg.wailiTestRegResponse,
	[pbCode.clientToServerMsg.wailiTestLoginRequest] 			= pbCode.clientToServerMsg.wailiTestLoginResponse,
	[pbCode.clientToServerMsg.wailiTestLpushRequest] 			= pbCode.clientToServerMsg.wailiTestLpushResponse,
	[pbCode.clientToServerMsg.wailiTestSingleValueRequest] 		= pbCode.clientToServerMsg.wailiTestSingleValueResponse,
	[pbCode.clientToServerMsg.wailiTestMultiValueRequest] 		= pbCode.clientToServerMsg.wailiTestMultiValueResponse,
	[pbCode.clientToServerMsg.AddressBookRequest] 				= pbCode.clientToServerMsg.AddressBookResponse,

}
function pbCode.getRepToResponseID(msgID)
	return repToResponse[msgID]
end



-- ID 转换为protocol buffer 解析标示
local msgIDToProtoBufStr = {
	[pbCode.clientToServerMsg.wailiTestRegRequest] 						= "wailiTestRegRequest",
	[pbCode.clientToServerMsg.wailiTestRegResponse] 					= "wailiTestRegResponse",
	[pbCode.clientToServerMsg.wailiTestLoginRequest] 					= "wailiTestLoginRequest",
	[pbCode.clientToServerMsg.wailiTestLoginResponse] 					= "wailiTestLoginResponse",
	[pbCode.clientToServerMsg.wailiTestLpushRequest] 					= "wailiTestLpushRequest",
	[pbCode.clientToServerMsg.wailiTestLpushResponse] 					= "wailiTestLpushResponse",
	[pbCode.clientToServerMsg.wailiTestSingleValueRequest] 				= "wailiTestSingleValueRequest",
	[pbCode.clientToServerMsg.wailiTestSingleValueResponse] 			= "wailiTestSingleValueResponse",
	[pbCode.clientToServerMsg.wailiTestMultiValueRequest] 				= "wailiTestMultiValueRequest",
	[pbCode.clientToServerMsg.wailiTestMultiValueResponse] 				= "wailiTestMultiValueResponse",
	[pbCode.clientToServerMsg.AddressBookRequest] 						= "AddressBookRequest",
	[pbCode.clientToServerMsg.AddressBookResponse] 						= "AddressBookResponse",

}
function pbCode.getProtoBuffStrByMsgID(msgID)
	return msgIDToProtoBufStr[msgID]
end

return pbCode
