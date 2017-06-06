local skynet = require "skynet"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testserver8cluster1",logger.level.debug)
    log.info("start testserver8cluster1")


    local clusterManager = skynet.newservice("clusterManager")
    skynet.call(clusterManager, "lua", "start")


    skynet.exit()
end)
