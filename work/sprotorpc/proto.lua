local sprotoparser = require "sprotoparser"

local proto = {}

local file = io.open("work/sprotorpc/c2s.proto", "rb")
proto.c2s = sprotoparser.parse(file:read("*a"))
file:close()

file = io.open("work/sprotorpc/s2c.proto", "rb")
proto.s2c = sprotoparser.parse(file:read("*a"))
file:close()

return proto
