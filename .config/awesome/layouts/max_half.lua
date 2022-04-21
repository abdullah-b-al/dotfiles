local half = {}

half.name = "half"

function half.arrange(p)
  local t   = p.tag or screen[p.screen].selected_tag
  local area = p.workarea
  local cls = p.clients

  local master = true
  for _, c in pairs(p.clients) do
    local x     = master and area.x or (area.x + (area.width / 2))
    local width = (#cls == 1) and area.width or (area.width / 2)
    local g = {
      x = x,
      y = area.y,
      width = width,
      height = area.height
    }
    p.geometries[c] = g
    master = false
  end
end
function half.skip_gap(nclients, t) -- luacheck: no unused args
  return true
end

return half
