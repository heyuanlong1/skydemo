local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testServer1",logger.level.debug)
    log.info("start testServer1")

    skynet.call(skynet.newservice("mysqldb"), "lua", "start", ".mysql_test1", 
        {
            host = config.mysql.testmysql1.host,
            port = config.mysql.testmysql1.port,
            database = config.mysql.testmysql1.database,
        },
        {
            user = config.mysql.testmysql1.user,
            password = config.mysql.testmysql1.password,
        }, 5)
    
    local res = skynet.call(".mysql_test1", "lua", "query", string.format("SELECT id, name FROM testtable WHERE id > %d",  1))
    for i, v in ipairs(res) do
        log.error(v.name)
    end


    skynet.call(skynet.newservice("redisdb"), "lua", "start", ".redis_test1", 
        {
            host = config.redis.testredis1.host,
            port = config.redis.testredis1.port,
        },
        config.redis.testredis1.auth,5)

    local value = skynet.call(".redis_test1", "lua", "HGET", 1201, "auth")
    log.error(value)


    skynet.exit()
end)
