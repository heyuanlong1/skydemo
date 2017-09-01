local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"

local httpc = require "http.httpc"


skynet.start(function()

    local status, body = httpc.get("studygolang.com", "/static/js/libs/jquery.timeago.js?v=1.5.4", {})
    print(status)
    print(body)
    --local result = json.decode(body)

    skynet.exit()
end)
