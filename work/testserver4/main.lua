local skynet = require "skynet"
local config = require "config.testServer4Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testServer4",logger.level.debug)
    log.info("start testServer4")


    local mygate = skynet.newservice("agentManager")
    skynet.call(mygate, "lua", "open", {
        port = config.testServer.port,
        maxclient = 10000,
        nodelay = true,
    })


    skynet.exit()
end)
