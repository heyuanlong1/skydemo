local skynet = require "skynet"
local config = require "config.testServer1Config"
local logger = require "common.log.skynetlog"


skynet.start(function()

   local webclient = skynet.newservice("webclients")
   -- local x ,y= skynet.call(webclient, "lua", "request", "http://www.dpull.com")
   -- print(x)
   -- print(y)

 local x ,y= skynet.call(webclient, "lua", "request", "https://graph.facebook.com/debug_token?input_token=EAAasZAeGJdnkBAOrNVdrQjN9z0HSkPGAC3WTZAZAQOBySi5ZBkhdfg8CLkki5qjuolYtfx7yaMwcReepnONfCZBnnNieGxsy2UXEnbaDuDMhgR6gLIOqoqxVK9pC8mg5sRWBGLCXHxX6MSOZA3JR4e2djRNZCG3pQ7utuuzLpCOSHPaRUQjUPhkqhXvM5XbuOTmKVah24mOIWyM6CP9jhFp&access_token=1878403435820665|f0GT7NDhFMJHGBl_BZqCsMamcIs")
   print(x)
   print(y)


   
    skynet.exit()


end)
