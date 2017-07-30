local skynet = require "skynet"
local 	testclass = require "testClass"
local logger = require "common.log.skynetlog"
skynet.start(function()
	log = logger.create("testserver10",logger.level.debug)

	log.info(testclass.get())

    skynet.exit()
end)
