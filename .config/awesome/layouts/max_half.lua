local half = {}

half.name = "half"

function half.arrange(p)
    local t   = p.tag or screen[p.screen].selected_tag
    local area = p.workarea
    local cls = p.clients

    local master = true
    for _, c in pairs(p.clients) do
        local x
        if master then
            x = area.x
        else
            x = (area.x + (area.width / 2))
        end
        local g = {
            x = x,
            y = area.y,
            width = area.width / 2,
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
