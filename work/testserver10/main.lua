local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"

local httpc = require "http.httpc"
local crypt = require "crypt"



skynet.start(function()



    skynet.exit()
end)
