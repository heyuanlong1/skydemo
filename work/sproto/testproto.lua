local sproto 	= require "sproto"
local core 		= require "sproto.core"


sp = sproto.parse [[

.wailiTestRegRequest{
	id 0 : integer
}
.wailiTestRegResponse{
	errorCode 0 : integer
	authCode 1 : string
}

.wailiTestLoginRequest{
	id 0 : integer
	authCode 1 : string
}
.wailiTestLoginResponse{
	errorCode 0 : integer
}

.wailiTestLpushRequest{
	id 0 : integer
	num 1 : integer
}
.wailiTestLpushResponse{
	errorCode 0 : integer
}

.wailiTestSingleValueRequest{
	key 0 : string
	value 1 : string
	sign 2 : string	
}
.wailiTestSingleValueResponse{
	errorCode 0 : integer
}

.wailiTestMultiValueRequest{
	key 0 : *string
	value 1 : *string
	sign 2 : string	
}
.wailiTestMultiValueResponse{
	errorCode 0 : integer
}


.Person {
	name 0 : string
	id 1 : integer
	email 2 : string
	.PhoneNumber {
		number 0 : string
		type 1 : integer
	}
	phone 3 : *PhoneNumber
}
.AddressBookRequest {
	person 0 : *Person(id)
	others 1 : *Person
}

.AddressBookResponse{
	errorCode 0 : integer
}

]]


return sp
