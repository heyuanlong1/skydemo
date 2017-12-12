local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"
local httpc = require "http.httpc"








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
        log.info(v.name)
    end
    local res = skynet.call(".mysql_test1", "lua", "query", string.format("SELECT id, namexxxx FROM testtable WHERE id > %d",  1))
    log.info(type(res))
    for i, v in ipairs(res) do
        log.info(v.name)
    end

    for i=1,2 do
            skynet.sleep(2 * 100)
        local res = skynet.call(".mysql_test1", "lua", "query", string.format("SELECT id, name FROM testtable WHERE id > %d",  1))
        for i, v in ipairs(res) do
            log.info(v.name)
        end
    end



    skynet.call(skynet.newservice("redisdb"), "lua", "start", ".redis_test1", 
        {
            host = config.redis.testredis1.host,
            port = config.redis.testredis1.port,
        },
        config.redis.testredis1.auth,5)

    local value = skynet.call(".redis_test1", "lua", "HGET", 1201, "auth")
    log.info(value)

    local addr = ".redis_test1"
    local iss = skynet.call(addr, "lua", "exists", "tttt_key1")
    log.info(type(iss))
    log.info(iss)

    local lists = {}
    --skynet.call(addr, "lua", "SADD", "tttt_key1", table.unpack(lists)) 

    local result = skynet.call(addr, "lua", "SMEMBERS", "tttt_key1")
    for i, v in ipairs(result) do
        local id = tonumber(v)
        log.info(id)
    end
    local iss = skynet.call(addr, "lua", "exists", "tttt_key1")
    log.info(type(iss))
    log.info(iss)


    skynet.exit()
end)
