local skynet = require "skynet"
require "skynet.manager"
local cluster = require "cluster"

local config = require "config.testServerConfig"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testserver8cluster2",logger.level.debug)
    log.info("start testserver8cluster2")


    local clusterManager = skynet.newservice("clusterManager")
    skynet.call(clusterManager, "lua", "sendheartbeat", "s1")



    local test1 = cluster.query("s3", ".test1")
    cluster.call("s3", test1, "set","a","valueaaaa")
	log.info(cluster.call("s3", test1, "get","a"))
	log.info(cluster.call("s3", test1, "get","a"))
	log.info(cluster.call("s3", test1, "get","a"))
	log.info(cluster.call("s3", test1, "get","a"))
	log.info(cluster.call("s3", test1, "get","a"))

    skynet.exit()
end)
