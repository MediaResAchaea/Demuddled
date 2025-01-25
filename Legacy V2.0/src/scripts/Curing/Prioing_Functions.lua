function Deprio(aff, depth)
  Legacy.Curing.Prios.PrioUpdates = Legacy.Curing.Prios.PrioUpdates or {}
  local aff = aff:title()
    if depth == nil and Legacy.Curing.Prios.temp[aff] ~= 26 and not table.contains(Legacy.Curing.Prios.PrioUpdates, aff.." 26") then
      table.insert(Legacy.Curing.Prios.PrioUpdates, aff.." 26")
      Legacy.Curing.Prios.temp[aff] = 26
    elseif depth == "hard" and Legacy.Curing.Prios.temp[aff] ~= 26 then
      if Legacy.Curing.Prios.temp[aff] == 26 then
        --nothing
      elseif not table.contains(Legacy.Curing.Prios.PrioUpdates, aff.." 26") then
        table.insert(Legacy.Curing.Prios.PrioUpdates, aff.." 26")
      end
    elseif depth == "soft" then
      if math.floor(Legacy.Curing.Prios.temp[aff] + 3) > 26 and Legacy.Curing.Prios.temp[aff] ~= 26 and not table.contains(Legacy.Curing.Prios.PrioUpdates, aff.." 26") then
        table.insert(Legacy.Curing.Prios.PrioUpdates, aff.." 26")
        Legacy.Curing.Prios.temp[aff] = 26
      elseif Legacy.Curing.Prios.temp[aff] ~= tonumber(depth) and not table.contains(Legacy.Curing.Prios.PrioUpdates, aff.." 26") then
        table.insert(Legacy.Curing.Prios.PrioUpdates, aff.." "..tonumber(depth))
        Legacy.Curing.Prios.temp[aff] = tonumber(depth)
      end
    
      
    end
end

function Reprio(aff)
  Legacy.Curing.Prios.PrioUpdates = Legacy.Curing.Prios.PrioUpdates or {}
  local aff = aff:title()
  
  if (Legacy.Curing.Prios.temp[aff] < Legacy.Curing.Prios.legacy[aff]) or (Legacy.Curing.Prios.temp[aff] > Legacy.Curing.Prios.legacy[aff]) and not table.contains(Legacy.Curing.Prios.PrioUpdates, aff.." "..Legacy.Curing.Prios.legacy[aff]) then
    table.insert(Legacy.Curing.Prios.PrioUpdates, aff.." "..Legacy.Curing.Prios.legacy[aff])
    Legacy.Curing.Prios.temp[aff] = Legacy.Curing.Prios.legacy[aff]
  end
    
end

function Prio(aff, pos)
  if pos == nil then pos = 1 end
  Legacy.Curing.Prios.PrioUpdates = Legacy.Curing.Prios.PrioUpdates or {}
  local aff = aff:title()
  if Legacy.Curing.Prios.temp[aff] ~= pos and not table.contains(Legacy.Curing.Prios.PrioUpdates, aff.." "..pos) then
    table.insert(Legacy.Curing.Prios.PrioUpdates, aff.." "..pos)
    Legacy.Curing.Prios.temp[aff] = pos
    Legacy.echo(pos)
  end
end

function UpdatePrios()
if Legacy == nil then return end
  Legacy.Curing.Prios.PrioUpdates = Legacy.Curing.Prios.PrioUpdates or {}
  if table.size(Legacy.Curing.Prios.PrioUpdates) > 0 then
    send("curing priority "..table.concat(Legacy.Curing.Prios.PrioUpdates, " "))
    Legacy.Curing.Prios.PrioUpdates = {}
  end
  
end
registerAnonymousEventHandler("LPrompt", "UpdatePrios")