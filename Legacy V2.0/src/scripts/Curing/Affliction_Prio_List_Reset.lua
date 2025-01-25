function Curing_Reset()
  gagprios = true
  local priostr = "curing priority "
  for aff, prio in pairs(Legacy.Curing.Prios.legacy) do
       priostr = priostr..aff.." "..prio.." "
  end
  send(priostr, false)
  tempTimer(20, function() 
      gagprios = false 
    end)
end
registerAnonymousEventHandler("CuringReset", "Curing_Reset")