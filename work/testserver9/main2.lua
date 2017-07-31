local skynet = require "skynet"
local config = require "config.testServer1Config"
local redisdb = require "common.db.redis.redisdb"
local mysqldb = require "common.db.mysql.mysqldb"
local logger = require "common.log.skynetlog"

local httpc = require "http.httpc"
local crypt = require "crypt"


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function fff(  )
    local str = "{['A']=1,['B']={1,{['y']=0.1,['x']='strB2x'},['b']='strBb'}}"
    return load("return  " .. str)()

end



skynet.start(function()


    skynet.newservice("debug_console", 6009)

    print("Server Start")

    for i = 1, 100000 do
        local x = fff()
    end


   skynet.exit()
end)
