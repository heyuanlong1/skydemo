local skynet = require "skynet"
require "skynet.manager"
local cluster = require "cluster"
local config = require "config.testServerConfig"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testserver8cluster3",logger.level.debug)
    log.info("start testserver8cluster3")



    local clusterManager = skynet.newservice("clusterManager")
    skynet.call(clusterManager, "lua", "sendheartbeat", "s1")
    

 
    local test1 = skynet.newservice("test1")
    skynet.name(".test1", test1)

    cluster.open("s3")  
	cluster.register(".test1", test1)

    skynet.exit()
end)
