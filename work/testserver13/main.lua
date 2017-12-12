local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"


skynet.start(function()

   local webclient = skynet.newservice("webclients")
   -- local x ,y= skynet.call(webclient, "lua", "request", "http://www.dpull.com")
   -- print(x)
   -- print(y)

 local x ,y= skynet.call(webclient, "lua", "request", "https://www.baidu.com/")
   print(x)
   print(y)


   
    skynet.exit()


end)
