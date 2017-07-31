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

function ffff( )
    local t = {}
    str = "{['A']=1,['B']={1,{['y']=0.1,['x']='strB2x'},['b']='strBb'}}"
    for i = 1, 100000 do
        --local x = load("return  " .. str)()
        t[i] = {['A']=1,['B']={1,{['y']=0.1,['x']='strB2x'},['b']='strBb'}}
        --print(t[i]['A'])
    end
    t =nil
end

skynet.start(function()


    skynet.newservice("debug_console", 6009)

    print("Server Start")
    ffff()

   --skynet.exit()
end)
