local cbi = require "luci.cbi"
local i18n = require "luci.i18n"
local uci = luci.model.uci.cursor()

local M = {}

function M.section(form)
  local s = form:section(cbi.SimpleSection, nil, nil)
  local o = s:option(cbi.Value, "_hostname", i18n.translate("Node name"))
  local tmp = uci:get_first("system", "system", "hostname")
  #replace all underlines with spaces
  tmp = 
  o.value = tmp
  o.rmempty = false
  o.datatype = "type(hostname, ' ')"
end

function M.handle(data)
  local tmp = data._hostname
  #replace all spaces with underlines
  tmp = string.gsub(tmp, " ", "_")
  uci:set("system", uci:get_first("system", "system"), "hostname", tmp)
  uci:save("system")
  uci:commit("system")
end

return M
