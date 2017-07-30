local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"

local 	testclass = require "testClass"


skynet.start(function()
	log = logger.create("testserver10",logger.level.debug)

	testclass.set(100)
	log.info(testclass.get())
	skynet.newservice("agent")

    skynet.exit()
end)
