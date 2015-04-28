local cbi = require "luci.cbi"
local uci = luci.model.uci.cursor()

local M = {}

function M.section(form)
  local s = form:section(cbi.SimpleSection, nil,
    [[Um deinen Knoten auf der Karte anzeigen zu können, benötigen
    wir seine Koordinaten. Hier hast du die Möglichkeit, diese
    manuell festzulegen.]])

  local o

  o = s:option(cbi.Flag, "_location", "Eigene Koordinaten eingeben")
  o.default = uci:get_first("gluon-node-info", "location", "user_defined_location", o.disabled)
  o.rmempty = false

  o = s:option(cbi.Value, "_latitude", "Breitengrad")
  o.default = uci:get_first("gluon-node-info", "location", "latitude")
  o:depends("_location", "1")
  o.rmempty = false
  o.datatype = "float"
  o.description = "z.B. 51.873621"

  o = s:option(cbi.Value, "_longitude", "Längengrad")
  o.default = uci:get_first("gluon-node-info", "location", "longitude")
  o:depends("_location", "1")
  o.rmempty = false
  o.datatype = "float"
  o.description = "z.B. 7.689901"
end

function M.handle(data)
  local sname = uci:get_first("gluon-node-info", "location")

  uci:set("gluon-node-info", sname, "user_defined_location", data._location)
  if data._location and data._latitude ~= nil and data._longitude ~= nil then
    uci:set("gluon-node-info", sname, "latitude", data._latitude)
    uci:set("gluon-node-info", sname, "longitude", data._longitude)
  end
  uci:save("gluon-node-info")
  uci:commit("gluon-node-info")
end

return M
