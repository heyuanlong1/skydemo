local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"

local httpc = require "http.httpc"
local crypt = require "crypt"



function tohex( str )
    local hex = "0123456789abcdef"
    local ret = ""
    for i=1,#str do
        local j = (string.byte(string.sub(str,i,i)) >> 4 ) 
        local k =  string.byte(string.sub(str,i,i)) & 0xf
        ret = ret..  string.sub(hex, j,j)
        ret = ret..  string.sub(hex, k,k)
    end
    return ret
end

function num2hex(num)
    local hexstr = '0123456789abcdef'
    local s = ''
    while num > 0 do
        local mod = math.fmod(num, 16)
        s = string.sub(hexstr, mod+1, mod+1) .. s
        num = math.floor(num / 16)
    end
    if s == '' then s = '0' end
    return s
end
--- Returns HEX representation of str
function str2hex(str)
    local hex = ''
    while #str > 0 do
        local hb = num2hex(string.byte(str, 1, 1))
        if #hb < 2 then hb = '0' .. hb end
        hex = hex .. hb
        str = string.sub(str, 2)
    end
    return hex
end

skynet.start(function()


-- 	log = logger.create("testServer9",logger.level.debug)
--     log.info("start testServer9")

--     local recvheader = {}
--     local header = {}
--     header.AppKey="6239251ba82728b7148085debfe9df09"
--     header.Nonce="4tgggergigwow323t23t"
--     header.CurTime=math.floor(skynet.time())
--     local ll = header.AppKey..header.Nonce..header.CurTime
--     print("ll:"..ll)
--     local ss = crypt.sha1(ll)
--     print("ss:"..ss)
--     header.CheckSum= crypt.hexencode(ss)
--     print("header.CheckSum:"..header.CheckSum)
--     header["Content-Type"]="application/x-www-form-urlencoded;charset=utf-8"

--     for k,v in pairs(header) do
--         print(k,v)
--     end

-- --curl -X POST -H "AppKey: 6239251ba82728b7148085debfe9df09" -H "CurTime: 1498815463" -H "CheckSum: 303c572ec731468dec7a5cd09d7643a6d23" -H "Nonce: 679415" -H "Content-Type: application/x-www-form-urlencoded" -d 'mobile=13430124629' 'https://api.netease.im/sms/sendcode.action'




--     local value ,body= httpc.request("POST", "api.netease.im", "https://api.netease.im/sms/sendcode.action", recvheader, header, "mobile=13430124629")
--     print("value:"..value)
--     print("body:"..body)
--     if type(value) == "string" then
--         log.info(value)
--     end
--     if type(value) == "table" then
--         for i, v in ipairs(value) do
--             log.info(i..":"..v)
--         end
--     end

--     for k,v in pairs(recvheader) do
--         print(k,v)
--     end
    skynet.newservice("debug_console", 6009)

    print("Server Start")
    local t = {}
    for i = 1, 100000 do
        t[i] = load("return aaaaaaaaaaaaaaaaaaaa, " .. i)
    end
    t = nil

    skynet.exit()
end)
