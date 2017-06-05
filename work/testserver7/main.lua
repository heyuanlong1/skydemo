local skynet = require "skynet"
local config = require "config.testServerConfig"
local logger = require "common.log.skynetlog"


skynet.start(function()
	log = logger.create("testServer7",logger.level.debug)
    log.info("start testServer7")


    local web = skynet.newservice("web")
    skynet.call(web, "lua", "start", "0.0.0.0", config.testServer.webport)

    local testweb1 = skynet.newservice("testweb1")
    skynet.call(web, "lua", "registerService", "testweb1", testweb1)
    local testweb2 = skynet.newservice("testweb2")
    skynet.call(web, "lua", "registerService", "testweb2", testweb2)



    skynet.exit()
end)
