local skynet = require "skynet"
local config = require "config.testServerConfig"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testServer6",logger.level.debug)
    log.info("start testServer6")

    skynet.uniqueservice("protoloader")

    local mygate = skynet.newservice("watchdog")
    skynet.call(mygate, "lua", "start", {
        port = config.testServer.port,
        maxclient = 10000,
        nodelay = true,
    })


    skynet.exit()
end)
