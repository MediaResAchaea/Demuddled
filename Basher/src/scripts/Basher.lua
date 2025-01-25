function Basher_Setup()
  if (Legacy and gmcp.Char and gmcp.Room) then
    send("settarget "..gmcp.Char.Status.name)
    Legacy.Basher = Legacy.Basher or {}
    Legacy.Basher.Targets = Legacy.Basher.Targets or {}
    Legacy.Settings.Basher = Legacy.Settings.Basher or {}
    Legacy.Settings.Basher.Classes = Legacy.Settings.Basher.Classes or {}
    Legacy.Settings.Basher.Ignore = Legacy.Settings.Basher.Ignore or {""}
    Legacy.Settings.Basher.Group = {}
    Legacy.Settings.Basher.Predictions = { ["recklessness"] = false}
    Legacy.Settings.Basher.lokiCount = 0
    Legacy.Settings.Basher.fleeAt = Legacy.Settings.Basher.fleeAt or 10
    Legacy.Settings.Basher.rainbows = Legacy.Settings.Basher.rainbows or true
    Legacy.Settings.Basher.gotGold = false
    if Legacy.Settings.Basher.powerThrough ~= true or Legacy.Settings.Basher.powerThrough == nil then
      Legacy.Settings.Basher.powerThrough = true
    end
    Legacy.Settings.Basher.Gold = 0
    Legacy.Settings.Basher.shield = false
    Legacy.Settings.Basher.status = false
    Legacy.Settings.Basher.fleeing = false
    Legacy.Settings.Basher.fleeRoom = 1234
  function Legacy.Settings.Basher.Mobs()
    Legacy.Settings.Basher.possibleTargets = {}
    for k,v in pairs(gmcp.Char.Items.List.items) do
      if v.attrib == "m" and table.contains(Legacy.Basher.Targets, v.name:lower()) and Legacy.Settings.Basher.status == true and not table.contains(Legacy.Settings.Basher.Ignore, v.name:lower()) then
        Legacy.Settings.Basher.possibleTargets[v.id] = v.name
      end
    end 
  end
  registerAnonymousEventHandler("gmcp.Char.Items.List", "Legacy.Settings.Basher.Mobs")
  
  function Legacy.Settings.Basher.possibleEcho()
    local poss = {}
    for k,v in pairs(gmcp.Char.Items.List.items) do
      if v.attrib == "m" and table.contains(Legacy.Basher.Targets[gmcp.Room.Info.area], v.name:lower()) and Legacy.Settings.Basher.status == true and not table.contains(Legacy.Settings.Basher.Ignore, v.name:lower()) then
        table.insert(poss, "<red>"..v.name)
      elseif v.attrib == "m" and Legacy.Settings.Basher.status == true and not table.contains(Legacy.Settings.Basher.Ignore, v.name:lower()) then
        table.insert(poss, "<orange>"..v.name)
      end
    end
    Legacy.Basher.Target()
    if Legacy.Settings.Basher.status == true and Legacy.Settings.Basher.mobCount() > 0 then
      cecho("\n<gold>Possible Targets<DimGray> (<orange>"..table.size(poss).."<DimGrey>)<white>: \n<red>"..table.concat(poss, "\n"))
    elseif Legacy.Settings.Basher.status == true and table.size(Legacy.Settings.Basher.possibleTargets) == 0 then
      Legacy.echo("<red>No possible targets")
    end 
  end
  registerAnonymousEventHandler("gmcp.Room.Info", "Legacy.Settings.Basher.possibleEcho")

  function Legacy.Settings.Basher.mobRemove()
    if table.contains(Legacy.Settings.Basher.possibleTargets, gmcp.Char.Items.Remove.item.id) and Legacy.Settings.Basher.status == true then
    
      Legacy.Settings.Basher.possibleTargets[gmcp.Char.Items.Remove.item.id] = nil
      if not gmcp.Char.Items.Remove.item.name:match("the corpse of") then
        Legacy.bigEcho(gmcp.Char.Items.Remove.item.name.." ran away!!!", "red", "gold")
        Legacy.Settings.Basher.queued = false
        Legacy.Settings.Basher.currentTar = ""
        Legacy.Settings.Basher.possibleTargets[gmcp.Char.Items.Remove.item.id] = nil
      end
    end
  end
  registerAnonymousEventHandler("gmcp.Char.Items.Remove", "Legacy.Settings.Basher.mobRemove")
  
  function Legacy.Settings.Basher.mobAdd()
    if gmcp.Char.Items.Add.item.attrib == "m" and table.contains(Legacy.Basher.Targets, gmcp.Char.Items.Add.item.name) and Legacy.Settings.Basher.status == true then
      if not table.contains(Legacy.Settings.Basher.possibleTargets, gmcp.Char.Items.Add.item.id) then
        Legacy.Settings.Basher.possibleTargets[gmcp.Char.Items.Add.item.id] = gmcp.Char.Items.Add.item.name
        Legacy.echo("<green>Added <gold>"..gmcp.Char.Items.Add.item.name.."<green> to possible targets")
        Legacy.Basher.Target()
      end
    end
  end
  registerAnonymousEventHandler("gmcp.Char.Items.Add", "Legacy.Settings.Basher.mobAdd")
    
    if Legacy.Settings.Basher.Classes[gmcp.Char.Status.class] == nil then
      Legacy.Settings.Basher.Classes[gmcp.Char.Status.class] = {
        attack      = "",
        pre         = "", 
      }
    end
    
    --Settings
    if Legacy.Settings.Basher.useRage ~= false or Legacy.Settings.Basher.useRage == nil then
      Legacy.Settings.Basher.useRage = true
    end
    
    if Legacy.Settings.Basher.flee ~= false or Legacy.Settings.Basher.flee == nil then
      Legacy.Settings.Basher.flee = true
    end
    
    function Legacy.Settings.Basher.mobCount()
    local mobs = 0
    for k,v in pairs(gmcp.Char.Items.List.items) do
      if v.attrib == "m" then
        mobs = mobs + 1
      end
    end
    return mobs
  end
  registerAnonymousEventHandler("gmcp.Char.Items", "Legacy.Settings.Basher.mobCount")

  function Legacy.Basher.Target()
    if Legacy.Basher.Targets[gmcp.Room.Info.area] == nil and Legacy.Settings.Basher.status == true then
      Legacy.Basher.Targets[gmcp.Room.Info.area] = {}
    end
    if Legacy.Settings.Basher.status == true and (gmcp.IRE.Target.Set == "" or Legacy.Settings.Basher.currentTar == "") and Legacy.Settings.Basher.mobCount() > 0 then
      for i, mob in pairs(Legacy.Basher.Targets[gmcp.Room.Info.area]) do
        for id, item in pairs(Legacy.Settings.Basher.possibleTargets) do
          if item:lower() == mob:lower() and Legacy.Settings.Basher.currentTar == "" and id ~= Legacy.Settings.Basher.currentTar and not table.contains(Legacy.Settings.Basher.Ignore, item:lower()) then
            send("st "..id)
            Legacy.Settings.Basher.shield = false
            Legacy.Settings.Basher.desc = item
            Legacy.Settings.Basher.currentTar = id
            break
          end
        end
      end
    end
  end
  registerAnonymousEventHandler("gmcp.Char.Items", "Legacy.Basher.Target")

  function Legacy.Settings.Basher.failsafes()
    if Legacy.Settings.Basher.status == true then
      if Legacy.Settings.BashercurrentTar == "" and gmcp.IRE.Target.Set ~= "" then
                Legacy.Settings.Basher.currentTar = gmcp.IRE.Target.Set
      elseif gmcp.IRE.Target.Set == "" then
      end
      Legacy.Settings.Basher.queued = false
      Legacy.Settings.Basher.shield = false
    end
  end
  registerAnonymousEventHandler("gmcp.Room.Info", "Legacy.Settings.Basher.failsafes")
  
  function Legacy.Settings.Basher.FleeTracker()
    Legacy.Settings.Basher.fleeing = false
     currentRoom = gmcp.Room.Info.num
     currentExits = {}
    for k,v in pairs(gmcp.Room.Info.exits) do
      currentExits[v] = tostring(k)
    end
    if lastRoom == nil then
      lastRoom = 1234
    end
    if currentRoom ~= lastRoom then
      Legacy.Settings.Basher.fleeExit = currentExits[lastRoom]
    end
    lastRoom = gmcp.Room.Info.num
  end
  registerAnonymousEventHandler("gmcp.Room.Info", "Legacy.Settings.Basher.FleeTracker")
  
  function Legacy.Basher.flee(room)
    if Legacy.Settings.Basher.status == false then return end
    if Legacy.Settings.Basher.flee == false then return end
    if Legacy.Settings.Basher.fleeExit == currentExits[Legacy.Settings.Basher.fleeRoom] then return end
    Legacy.Settings.Basher.fleeRoom = room
    send("queue addclear freestand go "..Legacy.Settings.Basher.fleeExit)
  end
  
  --send("queue addclear freestand go "..Legacy.Settings.Basher.fleeExit)
  function Legacy.Basher.Attack()
  if Legacy.Settings.Basher.status == false then return end
  if gmcp.IRE.Target then
  if Legacy.Settings.Basher.fleeing == true then return end
  if Legacy[gmcp.Char.Status.name].Vitals.hpPer <= math.floor(tonumber(Legacy.Settings.Basher.fleeAt) + 2) and not Legacy.Curing.Affs.blackout and Legacy.Settings.Basher.flee == true then Legacy.bigEcho("Flee! Run for your life!!", "gold", "red") Legacy.Basher.flee(gmcp.Room.Info.num) Legacy.Settings.Basher.fleeing = true return end
  if Legacy.Settings.Basher.status == true then
    if (gmcp.Char.Vitals.eq or gmcp.Char.Vitals.bal) == "0" then return end
    if (gmcp.Char.Vitals.eq and gmcp.Char.Vitals.bal) == "1" then attacked = false end
    if Legacy.Settings.Basher.queued == true then return end
    if attacked == true then return end
  end
  local str = string.gsub(gmcp.IRE.Target.Info.hpperc, "%%", "")
  local health = tonumber(str)
  if Legacy.Settings.Basher.status == false then return end
  --if gmcp.IRE.Target.Info.short_desc:match("a harrowing thrall of") and health < 21 then cecho("\n<red>DON'T KILL THE THRALL!") Legacy.Settings.Basher.status = false end
  if gmcp.IRE.Target.Set == "Aranos" then send("settarget none") return end
  
    sendCount = sendCount or 0
    if sendCounter then
      killTimer("sendCounter") 
      sendCounter = tempTimer(10, function() if sendCount < 49 then sendCount = 0 end end )
    else
      sendCounter = tempTimer(10, function() if sendCount < 49 then sendCount = 0 end end )
    end
    if (Legacy.Settings.Basher.currentTar == "" and table.size(Legacy.Settings.Basher.possibleTargets) > 0) then for k,v in pairs(Legacy.Settings.Basher.possibleTargets) do Legacy.Settings.Basher.currentTar = tostring(k) send("settarget "..k)  break end send("ql") return end
    if sendCount >= 20 then  Legacy.bigEcho("SOMETHING BROKE, TURNING HUNTING OFF", "red", "gold") Legacy.Settings.Basher.status = false return end 
    if gmcp.IRE.Target.Set == "" and not table.contains(gmcp.Char.Items.List, Legacy.Settings.Basher.currentTar) then Legacy.Settings.Basher.currentTar = "" end
    if gmcp.IRE.Target.Info.hpperc ~= "-1" and not (Legacy.Curing.Affs.brokenleftarm and Legacy.Curing.Affs.brokenrightarm) and gmcp.IRE.Target.Set ~= "Aranos" and Legacy.Settings.Basher.queued == false and sendCount < 50 and Legacy.Settings.Basher.status == true and ((tonumber(gmcp.Char.Vitals.hp) > 0 and gmcp.Char.Vitals.hp ~= nil) or (gmcp.Char.Vitals.hp == nil and Legacy.Settings.Basher.powerThrough == true)) and gmcp.IRE.Target.Set ~= "" and gmcp.Char.Vitals.eq == "1" and gmcp.Char.Vitals.bal == "1" and Legacy.Settings.Basher.mobCount() > 0 and (Legacy.Settings.Basher.Classes[gmcp.Char.Status.class].attack ~= nil or Legacy.Settings.Basher.Classes[gmcp.Char.Status.class].attack ~= "") and not Legacy.Curing.Affs.transfixed and not Legacy.Curing.Affs.impaled and not Legacy.Curing.Affs.entangled and not Legacy.Curing.Affs.sleeping and not Legacy.Curing.Affs.webbed and not Legacy.Curing.Affs.aeon then
      if Legacy.Settings.Basher.shield == false then
        local str = string.gsub(gmcp.IRE.Target.Info.hpperc, "%%", "")
        local health = tonumber(str)
        if health >= Legacy.Settings.Basher.Classes[gmcp.Char.Status.class].configRage.bigDamage then
          for k,v  in pairs(Legacy.Settings.Basher.Classes[gmcp.Char.Status.class]) do
            if v.desc == "Big Damage" then
              if math.floor(Legacy[gmcp.Char.Status.name].rage - v.rage) >= 17 and v.available == true and Legacy.Settings.Basher.useRage == true then
                send("queue add freestand "..v.cmd)
                send("queue add freestand basher")
                Legacy.Settings.Basher.queued = true
                tempTimer(26, function() v.available = true end)
                v.available = false
              elseif Legacy.Settings.Basher.queued == false then
                send("queue add freestand basher")
                Legacy.Settings.Basher.queued = true
              end
            end
          end
        elseif health >= Legacy.Settings.Basher.Classes[gmcp.Char.Status.class].configRage.smallDamage then
          for k,v  in pairs(Legacy.Settings.Basher.Classes[gmcp.Char.Status.class]) do
            if v.desc == "Small Damage" then
              if math.floor(Legacy[gmcp.Char.Status.name].rage - v.rage) >= 17 and v.available == true and Legacy.Settings.Basher.useRage == true then
                send("queue add freestand "..v.cmd)
                send("queue add freestand basher")
                Legacy.Settings.Basher.queued = true
                tempTimer(19, function() v.available = true end)
                v.available = false
              elseif Legacy.Settings.Basher.queued == false then
                send("queue add freestand basher")
                Legacy.Settings.Basher.queued = true
              end
            end
          end
        elseif Legacy.Settings.Basher.queued == false then
          send("queue add freestand basher")
          Legacy.Settings.Basher.queued = true
        end
      end
      sendCount = sendCount + 1
    end
  end
  end
  registerAnonymousEventHandler("gmcp.Char.Vitals", "Legacy.Basher.Attack")
  function Legacy.Settings.Basher.Rage()
    if gmcp.Char.Status.class == "Alchemist" then
      Legacy.Settings.Basher.Classes["Alchemist"].miasma = {cmd = "throw miasma", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Alchemist"].cadmium = {cmd = "educe cadmium", rage = 22, desc = "Gives Affliction", aff = "weakness", available = true}
      Legacy.Settings.Basher.Classes["Alchemist"].caustic = {cmd = "throw caustic at ", rage = 17, desc = "Shieldbreak", available = true}
      Legacy.Settings.Basher.Classes["Alchemist"].magnesium = {cmd = "educe magnesium", rage =36, desc = "Big Damage", available = true}
      Legacy.Settings.Basher.Classes["Alchemist"].pathogen = {cmd = "throw pathogen", rage = 25, desc = "Conditional", needs = {"recklessness", "fear"}, available = true}
      Legacy.Settings.Basher.Classes["Alchemist"].hypnotic = {cmd = "throw hypotic", rage = 28, desc = "Gives Affliction", aff = "amnesia", available = true}
      Legacy.Settings.Basher.Classes["Alchemist"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Alchemist"].nrshieldbreak = {cmd = "educe copper", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Apostate" then
      Legacy.Settings.Basher.Classes["Apostate"].convulsions = {cmd = "stare @tar convulsions", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Apostate"].horrify = {cmd = "stare @tar horrify", rage = 29, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Apostate"].daeggerpierce = {cmd = "daegger pierce @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Apostate"].burrow = {cmd = "daegger burrow @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Apostate"].bloodlet = {cmd = "bloodlet @tar", rage = 25, desc = "Conditional", needs = {"sensitivity", "stun"}, available = true}
      Legacy.Settings.Basher.Classes["Apostate"].possess = {cmd = "possess @tar", rage = 32, desc = "Gives Affliction", aff = "charm", available = true}
      Legacy.Settings.Basher.Classes["Apostate"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Apostate"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Bard" then    
      Legacy.Settings.Basher.Classes["Bard"].moulinet = {cmd = "moulinet @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Bard"].trill = {cmd = "play trill at @tar", rage = 28, desc = "Gives Affliction", aff = "amnesia", available = true }
      Legacy.Settings.Basher.Classes["Bard"].resonance = {cmd = "play resonance @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Bard"].howlslash = {cmd = "howlslash @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Bard"].cyclone = {cmd = "cyclone @tar", rage = 25, desc = "Conditional", needs = {"clumsiness", "stun"}, available = true}
      Legacy.Settings.Basher.Classes["Bard"].charm = {cmd = "play charm at @tar", rage = 32, desc = "Gives Affliction", aff = "charm", available = true}
      Legacy.Settings.Basher.Classes["Bard"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Bard"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Blademaster" then
      Legacy.Settings.Basher.Classes["Blademaster"].leapstrike = {cmd = "leapstrike @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Blademaster"].daze = {cmd = "shin daze @tar", rage = 26, desc = "Gives Affliction", aff = "stun", available = true }
      Legacy.Settings.Basher.Classes["Blademaster"].shatter = {cmd = "shin shatter @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Blademaster"].spinslash = {cmd = "spinslash @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Blademaster"].headstrike = {cmd = "strike @tar head", rage = 25, desc = "Conditional", needs = {"recklessness", "fear"}, available = true}
      Legacy.Settings.Basher.Classes["Blademaster"].nerveslash = {cmd = "nerveslash @tar", rage = 22, desc = "Gives Affliction", aff = "weakness", available = true}
      Legacy.Settings.Basher.Classes["Blademaster"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Blademaster"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Depthswalker" then
      Legacy.Settings.Basher.Classes["Depthswalker"].drain = {cmd = "shadow drain @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Depthswalker"].curse = {cmd = "chrono curse @tar", rage = 24, desc = "Gives Affliction", aff = "aeon", available = true }
      Legacy.Settings.Basher.Classes["Depthswalker"].nakail = {cmd = "intone nakail @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Depthswalker"].lash = {cmd = "shadow lash @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Depthswalker"].erasure = {cmd = "chrono erasure @tar", rage = 25, desc = "Mid Damage", available = true}
      Legacy.Settings.Basher.Classes["Depthswalker"].boinad = {cmd = "intone boinad @tar", rage = 32, desc = "Gives Affliction", aff = "charm", available = true}
      Legacy.Settings.Basher.Classes["Depthswalker"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Depthswalker"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Druid" then
      Legacy.Settings.Basher.Classes["Druid"].strangle = {cmd = "strangle @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Druid"].redeem = {cmd = "reclamation redeem @tar", rage = 22, desc = "Gives Affliction", aff = "weakness", available = true }
      Legacy.Settings.Basher.Classes["Druid"].vinecrack = {cmd = "vinecrack @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Druid"].ravage = {cmd = "ravage @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Druid"].sear = {cmd = "sear @tar", rage = 25, desc = "Conditional", needs = {"recklessness", "stun"}, available = true}
      Legacy.Settings.Basher.Classes["Druid"].glare = {cmd = "quarterstaff glare @tar", rage = 14, desc = "Gives Affliction", aff = "clumsiness", available = true}
      Legacy.Settings.Basher.Classes["Druid"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Druid"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Infernal" then
      Legacy.Settings.Basher.Classes["Infernal"].ravage = {cmd = "ravage @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Infernal"].soulshield = {cmd = "soulshield", rage = 22, desc = "Buff", available = true }
      Legacy.Settings.Basher.Classes["Infernal"].shiver = {cmd = "shiver @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Infernal"].spike = {cmd = "spike @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Infernal"].hellstrike = {cmd = "hellstrike @tar", rage = 25, desc = "Conditional", needs = {"recklessness", "fear"}, available = true}
      Legacy.Settings.Basher.Classes["Infernal"].deathlink = {cmd = "deathlink ", rage = 30, desc = "Buff", available = true}
      Legacy.Settings.Basher.Classes["Infernal"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Infernal"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Jester" then
      Legacy.Settings.Basher.Classes["Jester"].noogie = {cmd = "noogie @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Jester"].dustthrow = {cmd = "dustthrow @tar", rage = 18, desc = "Gives Affliction", aff = "inhibit", available = true }
      Legacy.Settings.Basher.Classes["Jester"].jacks = {cmd = "throw jacks at @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Jester"].ensconce = {cmd = "ensconce firecracker on @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Jester"].befuddle = {cmd = "befuddle @tar", rage = 25, desc = "Conditional", needs = {"aeon", "amnesia"}, available = true}
      Legacy.Settings.Basher.Classes["Jester"].rap = {cmd = "rap @tar", rage = 26, desc = "Gives Affliction", aff = "stun", available = true}
      Legacy.Settings.Basher.Classes["Jester"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Jester"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Magi" then
      Legacy.Settings.Basher.Classes["Magi"].windslash = {cmd = "cast windslash at @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Magi"].dialation = {cmd = "cast dialation at @tar", rage = 24, desc = "Gives Affliction", aff = "aeon", available = true }
      Legacy.Settings.Basher.Classes["Magi"].disintegrate = {cmd = "cast disintegrate at @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Magi"].squeeze = {cmd = "golem squeeze @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Magi"].firefall = {cmd = "cast firefall at @tar", rage = 25, desc = "Conditional", needs = {"clumsiness", "recklessness"}, available = true}
      Legacy.Settings.Basher.Classes["Magi"].stormbolt = {cmd = "cast stormbolt at @tar", rage = 26, desc = "Gives Affliction", aff = "sensitivity", available = true}
      Legacy.Settings.Basher.Classes["Magi"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Magi"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Monk" then
      Legacy.Settings.Basher.Classes["Monk"].spinningbackfist = {cmd = "sbp", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Monk"].scramble = {cmd = "mind scramble", rage = 22, desc = "Gives Affliction", aff = "clumsiness", available = true}
      Legacy.Settings.Basher.Classes["Monk"].splinterkick = {cmd = "spk ", rage = 17, desc = "Shieldbreak", available = true}
      Legacy.Settings.Basher.Classes["Monk"].tornadokick = {cmd = "tnk", rage = 36, desc = "Big Damage", available = true}
      Legacy.Settings.Basher.Classes["Monk"].mindblast = {cmd = "mind blast", rage = 25, desc = "Conditional", needs = {"weakness", "sensitivity"}, available = true}
      Legacy.Settings.Basher.Classes["Monk"].ripplestrike = {cmd = "rpst", rage = 25, desc = "Gives Affliction", aff = "inhibit", available = true}
      Legacy.Settings.Basher.Classes["Monk"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Monk"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Occultist" then
      Legacy.Settings.Basher.Classes["Occultist"].harry = {cmd = "harry @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Occultist"].temper = {cmd = "temper @tar", rage = 32, desc = "Gives Affliction", aff = "charm", available = true }
      Legacy.Settings.Basher.Classes["Occultist"].ruin = {cmd = "ruin @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Occultist"].chaosgate = {cmd = "chaosgate @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Occultist"].fluctuate = {cmd = "fluctuate @tar", rage = 25, desc = "Conditional", needs = {"fear", "amnesia"}, available = true}
      Legacy.Settings.Basher.Classes["Occultist"].stagnate = {cmd = "stagnate @tar", rage = 29, desc = "Gives Affliction", aff = "aeon", available = true }
      Legacy.Settings.Basher.Classes["Occultist"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Occultist"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Paladin" then
      Legacy.Settings.Basher.Classes["Paladin"].harrow = {cmd = "harrow @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Paladin"].regeneration = {cmd = "perform rite of regeneration", rage = 18, desc = "Buff", available = true }
      Legacy.Settings.Basher.Classes["Paladin"].faithrend = {cmd = "faithrend @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Paladin"].shock = {cmd = "perform rite of shock at @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Paladin"].punishment = {cmd = "perform rite of punishment at @tar", rage = 25, desc = "Conditional", needs = {"weakness", "clumsiness"}, available = true}
      Legacy.Settings.Basher.Classes["Paladin"].recovery = {cmd = "perform rite of recovery at @tar", rage = 31, desc = "Buff", available = true}
      Legacy.Settings.Basher.Classes["Paladin"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Paladin"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Pariah" then
      Legacy.Settings.Basher.Classes["Pariah"].boil = {cmd = "blood boil @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Pariah"].symphony = {cmd = "swarm feast @tar", rage = 18, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Pariah"].ascour = {cmd = "accursed scour @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Pariah"].feast = {cmd = "swarm feast @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Pariah"].spider = {cmd = "trace spider @tar", rage = 25, desc = "Conditional", needs = {"inhibit", "sensitivity"}, available = true}
      Legacy.Settings.Basher.Classes["Pariah"].wail = {cmd = "accursed wail @tar", rage = 32, desc = "Gives Affliction", aff = "clumsiness", available = true}
      Legacy.Settings.Basher.Classes["Pariah"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Pariah"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Priest" then
      Legacy.Settings.Basher.Classes["Priest"].torment = {cmd = "angel torment", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Priest"].incense = {cmd = "angel incense", rage = 19, desc = "Gives Affliction", aff = "recklessness", available = true }
      Legacy.Settings.Basher.Classes["Priest"].crack = {cmd = "crack @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Priest"].desolation = {cmd = "perform rite of desolation @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Priest"].hammer = {cmd = "hammer @tar", rage = 25, desc = "Conditional", needs = {"clumsiness", "amnesia"}, available = true}
      Legacy.Settings.Basher.Classes["Priest"].horrify = {cmd = "perform rite of horrify @tar", rage = 29, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Priest"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Priest"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Psion" then
      Legacy.Settings.Basher.Classes["Psion"].barbedblade = {cmd = "weave barbedblade @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Psion"].regrowth = {cmd = "enact regrowth @tar", rage = 24, desc = "Gives Affliction", aff = "inhibit", available = true }
      Legacy.Settings.Basher.Classes["Psion"].pulverise = {cmd = "weave pulverise @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Psion"].whirlwind = {cmd = "weave whirlwind @tar", rage = 25, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Psion"].terror = {cmd = "psi terror @tar", rage = 32, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Psion"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Psion"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Runewarden" then
      Legacy.Settings.Basher.Classes["Runewarden"].collide = {cmd = "collide @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Runewarden"].bulwark = {cmd = "bulwark", rage = 28, desc = "Buff", available = true }
      Legacy.Settings.Basher.Classes["Runewarden"].fragment = {cmd = "fragment @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Runewarden"].onslaught = {cmd = "onslaught @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Runewarden"].etch = {cmd = "etch rune at @tar", rage = 25, desc = "Conditional", needs = {"aeon", "stun"}, available = true }
      Legacy.Settings.Basher.Classes["Runewarden"].safeguard = {cmd = "safeguard ", rage = 28, desc = "Buff", available = true }
      Legacy.Settings.Basher.Classes["Runewarden"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Runewarden"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Sentinel" then
      Legacy.Settings.Basher.Classes["Sentinel"].pester = {cmd = "pester @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Sentinel"].tame = {cmd = "tame @tar", rage = 32, desc = "Gives Affliction", aff = "charm", available = true }
      Legacy.Settings.Basher.Classes["Sentinel"].bore = {cmd = "bore @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Sentinel"].skewer = {cmd = "skewer @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Sentinel"].swarm = {cmd = "swarm @tar", rage = 25, desc = "Conditional", needs = {"aeon", "clumsiness"}, available = true }
      Legacy.Settings.Basher.Classes["Sentinel"].tame = {cmd = "goad @tar", rage = 32, desc = "Gives Affliction", aff = "recklessness", available = true }
      Legacy.Settings.Basher.Classes["Sentinel"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Sentinel"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Serpent" then
	    Legacy.Settings.Basher.Classes["Serpent"].thrash = {cmd = "thrash @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Serpent"].flagellate = {cmd = "flagellate @tar", rage = 25, desc = "Gives Affliction", aff = "aeon", available = true }
      Legacy.Settings.Basher.Classes["Serpent"].excoriate = {cmd = "excoriate @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Serpent"].throatrip = {cmd = "throatrip @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Serpent"].snare = {cmd = "snare @tar", rage = 25, desc = "Conditional", needs = {"inhibit", "weakness"}, available = true }
      Legacy.Settings.Basher.Classes["Serpent"].obliviate = {cmd = "obliviate @tar", rage = 28, desc = "Gives Affliction", aff = "amnesia", available = true }
      Legacy.Settings.Basher.Classes["Serpent"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Serpent"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Shaman" then
	    Legacy.Settings.Basher.Classes["Shaman"].corruption = {cmd = "curse @tar corruption", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Shaman"].korkma = {cmd = "invoke korkma @tar", rage = 29, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Shaman"].vulnerability = {cmd = "curse @tar vulnerability", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Shaman"].haemorrhage = {cmd = "curse @tar haemorrhage", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Shaman"].vurus = {cmd = "invoke vurus @tar", rage = 25, desc = "Conditional", needs = {"sensitivity", "amnesia"}, available = true }
      Legacy.Settings.Basher.Classes["Shaman"].cesaret = {cmd = "invoke cesaret @tar", rage = 18, desc = "Gives Affliction", aff = "recklessness", available = true }
      Legacy.Settings.Basher.Classes["Shaman"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Shaman"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Sylvan" then
	    Legacy.Settings.Basher.Classes["Sylvan"].torrent = {cmd = "cast torrent at @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Sylvan"].sandstorm = {cmd = "cast sandstorm at @tar", rage = 29, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Sylvan"].thornpierce = {cmd = "thornpiece @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Sylvan"].stonevine = {cmd = "stonevine @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Sylvan"].leechroot = {cmd = "leechroot @tar", rage = 25, desc = "Conditional", needs = {"inhibit", "weakness"}, available = true }
      Legacy.Settings.Basher.Classes["Sylvan"].rockshot = {cmd = "cast rockshot at @tar", rage = 18, desc = "Gives Affliction", aff = "amnesia", available = true }
      Legacy.Settings.Basher.Classes["Sylvan"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Sylvan"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Unnamable" then
      Legacy.Settings.Basher.Classes["Unnamable"].shriek = {cmd = "unnamable shriek @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Unnamable"].dread = {cmd = "croon dread @tar", rage = 24, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Unnamable"].sunder = {cmd = "unnamable sunder @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Unnamable"].destroy = {cmd = "unnamable destroy @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Unnamable"].onslaught = {cmd = "unnamable onslaught @tar", rage = 25, desc = "Conditional", needs = {"stun", "sensitivity"}, available = true }
      Legacy.Settings.Basher.Classes["Unnamable"].entropy = {cmd = "croon entropy @tar", rage = 18, desc = "Gives Affliction", aff = "aeon", available = true }
      Legacy.Settings.Basher.Classes["Unnamable"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Unnamable"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Silver Dragon" then
      Legacy.Settings.Basher.Classes["Silver Dragon"].overwhelm = {cmd = "overwhelm @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Silver Dragon"].sizzle = {cmd = "sizzle @tar", rage = 25, desc = "Gives Affliction", aff = "sensitivity", available = true}
      Legacy.Settings.Basher.Classes["Silver Dragon"].splinter = {cmd = "splinter @tar", rage = 17, desc = "Shieldbreak", available = true}
      Legacy.Settings.Basher.Classes["Silver Dragon"].dragonspark = {cmd = "dragonspark @tar", rage = 36, desc = "Big Damage", available = true}
      Legacy.Settings.Basher.Classes["Silver Dragon"].stormflare = {cmd = "stormflare @tar", rage = 25, desc = "Conditional", needs = {"amnesia", "fear"}, available = true}
      Legacy.Settings.Basher.Classes["Silver Dragon"].galvanize = {cmd = "galvanize @tar", rage = 18, desc = "Gives Affliction", aff = "recklessness", available = true}
      Legacy.Settings.Basher.Classes["Silver Dragon"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Silver Dragon"].nrshieldbreak = {cmd = "tailsmash @tar", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Golden Dragon" then
    	Legacy.Settings.Basher.Classes["Golden Dragon"].overwhelm = {cmd = "overwhelm @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Golden Dragon"].deaden = {cmd = "deaden @tar", rage = 24, desc = "Gives Affliction", aff = "aeon", available = true }
      Legacy.Settings.Basher.Classes["Golden Dragon"].psishatter = {cmd = "psishatter @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Golden Dragon"].psiblast = {cmd = "psiblast @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Golden Dragon"].psistorm = {cmd = "psistorm @tar", rage = 25, desc = "Conditional", needs = {"stun", "weakness"}, available = true }
      Legacy.Settings.Basher.Classes["Golden Dragon"].psidaze = {cmd = "psidaze @tar", rage = 28, desc = "Gives Affliction", aff = "amnesia", available = true }
      Legacy.Settings.Basher.Classes["Golden Dragon"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Golden Dragon"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Black Dragon" then
      Legacy.Settings.Basher.Classes["Black Dragon"].dragonspit = {cmd = "dragonspit @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Black Dragon"].dragonsting = {cmd = "deaden @tar", rage = 25, desc = "Gives Affliction", aff = "sensitivity", available = true }
      Legacy.Settings.Basher.Classes["Black Dragon"].dissolve = {cmd = "dissolve @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Black Dragon"].override = {cmd = "override @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Black Dragon"].corrode = {cmd = "corrode @tar", rage = 25, desc = "Conditional", needs = {"clumsiness", "aeon"}, available = true }
      Legacy.Settings.Basher.Classes["Black Dragon"].dragonfear = {cmd = "psidaze @tar", rage = 28, desc = "Gives Affliction", aff = "fear", available = true }
      Legacy.Settings.Basher.Classes["Black Dragon"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Black Dragon"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Blue Dragon" then
      Legacy.Settings.Basher.Classes["Blue Dragon"].dragonchill = {cmd = "dragonchill @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Blue Dragon"].glaciate = {cmd = "glaciate @tar", rage = 26, desc = "Gives Affliction", aff = "stun", available = true }
      Legacy.Settings.Basher.Classes["Blue Dragon"].frostrive = {cmd = "frostrive @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Blue Dragon"].override = {cmd = "override @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Blue Dragon"].frostwave = {cmd = "frostwave @tar", rage = 25, desc = "Conditional", needs = {"recklessness", "amnesia"}, available = true }
      Legacy.Settings.Basher.Classes["Blue Dragon"].ague = {cmd = "auge @tar", rage = 28, desc = "Gives Affliction", aff = "clumsiness", available = true }
      Legacy.Settings.Basher.Classes["Blue Dragon"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Blue Dragon"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Red Dragon" then
      Legacy.Settings.Basher.Classes["Red Dragon"].overwhelm = {cmd = "overwhelm @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Red Dragon"].dragontaunt = {cmd = "glaciate @tar", rage = 26, desc = "Gives Affliction", aff = "recklessness", available = true }
      Legacy.Settings.Basher.Classes["Red Dragon"].melt = {cmd = "melt @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Red Dragon"].dragonblaze = {cmd = "dragonblaze @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Red Dragon"].flamebath = {cmd = "flamebath @tar", rage = 25, desc = "Conditional", needs = {"recklessness", "amnesia"}, available = true }
      Legacy.Settings.Basher.Classes["Red Dragon"].scorch = {cmd = "auge @tar", rage = 18, desc = "Gives Affliction", aff = "inhibit", available = true }
      Legacy.Settings.Basher.Classes["Red Dragon"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Red Dragon"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "Green Dragon" then
      Legacy.Settings.Basher.Classes["Green Dragon"].dragonspit = {cmd = "dragonspit @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["Green Dragon"].scour = {cmd = "scour @tar", rage = 18, desc = "Gives Affliction", aff = "recklessness", available = true }
      Legacy.Settings.Basher.Classes["Green Dragon"].deteriorate = {cmd = "deteriorate @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["Green Dragon"].override = {cmd = "override @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["Green Dragon"].slaver = {cmd = "slaver @tar", rage = 25, desc = "Conditional", needs = {"sensitivity", "clumsiness"}, available = true }
      Legacy.Settings.Basher.Classes["Green Dragon"].dragonsap = {cmd = "dragonsap @tar", rage = 22, desc = "Gives Affliction", aff = "inhibit", available = true }
      Legacy.Settings.Basher.Classes["Green Dragon"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["Green Dragon"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "water Elemental Lord" or gmcp.Char.Status.class == 'water Elemental Lady' then
      Legacy.Settings.Basher.Classes["water Elemental Lord "].icicles = {cmd = "manifest icicles @tar", rage = 14, desc = "Small Damage", available = true }
			Legacy.Settings.Basher.Classes["water Elemental Lady"].icicles = {cmd = "manifest icicles @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["water Elemental Lord "].dehydrate = {cmd = "manifest dehydrate @tar", rage = 14, desc = "Gives Affliction", aff = "clumsiness", available = true }
			Legacy.Settings.Basher.Classes["water Elemental Lady"].dehydrate = {cmd = "manifest dehydrate @tar", rage = 14, desc = "Gives Affliction", aff = "clumsiness", available = true }
      Legacy.Settings.Basher.Classes["water Elemental Lord "].aquahammer = {cmd = "manifest aquahammer @tar", rage = 17, desc = "Shieldbreak", available = true }
			Legacy.Settings.Basher.Classes["water Elemental Lady"].aquahammer = {cmd = "manifest aquahammer @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["water Elemental Lord "].needlerain = {cmd = "manifest needlerain @tar", rage = 36, desc = "Big Damage", available = true }
			Legacy.Settings.Basher.Classes["water Elemental Lady"].needlerain = {cmd = "manifest needlerain @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["water Elemental Lord "].waterfall = {cmd = "manifest waterfall @tar", rage = 25, desc = "Conditional", needs = {"weakness", "aeon"}, available = true }
			Legacy.Settings.Basher.Classes["water Elemental Lady"].waterfall = {cmd = "manifest waterfall @tar", rage = 25, desc = "Conditional", needs = {"weakness", "aeon"}, available = true }
      Legacy.Settings.Basher.Classes["water Elemental Lord "].swell = {cmd = "manifest swell @tar", rage = 30, desc = "Buff", available = true }
			Legacy.Settings.Basher.Classes["water Elemental Lady"].swell = {cmd = "manifest swell @tar", rage = 30, desc = "Buff", available = true }
      Legacy.Settings.Basher.Classes["water Elemental Lord "].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
			Legacy.Settings.Basher.Classes["water Elemental Lady"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["water Elemental Lord "].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
			Legacy.Settings.Basher.Classes["water Elemental Lady"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "air Elemental Lord" or gmcp.Char.Status.class == 'air Elemental Lady' then
      Legacy.Settings.Basher.Classes["air Elemental Lord "].bolt = {cmd = "manifest bolt @tar", rage = 14, desc = "Small Damage", available = true }
			Legacy.Settings.Basher.Classes["air Elemental Lady"].bolt = {cmd = "manifest bolt @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["air Elemental Lord "].vacuum = {cmd = "manifest vacuum @tar", rage = 18, desc = "Gives Affliction", aff = "inhibit", available = true }
			Legacy.Settings.Basher.Classes["air Elemental Lady"].vacuum = {cmd = "manifest vacuum @tar", rage = 18, desc = "Gives Affliction", aff = "inhibit", available = true }
      Legacy.Settings.Basher.Classes["air Elemental Lord "].drill = {cmd = "manifest drill @tar", rage = 17, desc = "Shieldbreak", available = true }
			Legacy.Settings.Basher.Classes["air Elemental Lady"].drill = {cmd = "manifest drill @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["air Elemental Lord "].pressurewave = {cmd = "manifest pressurewave @tar", rage = 36, desc = "Big Damage", available = true }
			Legacy.Settings.Basher.Classes["air Elemental Lady"].pressurewave = {cmd = "manifest pressurewave @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["air Elemental Lord "].compress = {cmd = "aero compress @tar", rage = 25, desc = "Conditional", needs = {"stunned", "sensitivity"}, available = true }
			Legacy.Settings.Basher.Classes["air Elemental Lady"].compress = {cmd = "aero compress @tar", rage = 25, desc = "Conditional", needs = {"stunned", "sensitivity"}, available = true }
      Legacy.Settings.Basher.Classes["air Elemental Lord "].suffocate = {cmd = "aero suffocate @tar", rage = 22, desc = "Gives Affliction", aff = "inhibit", available = true }
			Legacy.Settings.Basher.Classes["air Elemental Lady"].suffocate = {cmd = "aero suffocate @tar", rage = 22, desc = "Gives Affliction", aff = "inhibit", available = true }
      Legacy.Settings.Basher.Classes["air Elemental Lord "].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
			Legacy.Settings.Basher.Classes["air Elemental Lady"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["air Elemental Lord "].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
			Legacy.Settings.Basher.Classes["air Elemental Lady"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "fire Elemental Lord" or gmcp.Char.Status.class == 'fire Elemental Lady' then
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].engulf = {cmd = "manifest engulf @tar", rage = 14, desc = "Small Damage", available = true }
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].engulf = {cmd = "manifest engulf @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].scourge = {cmd = "manifest scourge @tar", rage = 25, desc = "Gives Affliction", aff = "sensitivity", available = true }
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].scourge = {cmd = "manifest scourge @tar", rage = 25, desc = "Gives Affliction", aff = "sensitivity", available = true }
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].wires = {cmd = "manifest wires @tar", rage = 17, desc = "Shieldbreak", available = true }
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].wires = {cmd = "manifest wires @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].devastation = {cmd = "manifest devastation @tar", rage = 36, desc = "Big Damage", available = true }
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].devastation = {cmd = "manifest devastation @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].cataclysm = {cmd = "manifest cataclysm @tar", rage = 25, desc = "Conditional", needs = {"stunned", "recklessness"}, available = true }
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].cataclysm = {cmd = "manifest cataclysm @tar", rage = 25, desc = "Conditional", needs = {"stunned", "recklessness"}, available = true }
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].bonds = {cmd = "manifest bonds @tar", rage = 30, desc = "Small Damage", available = true }
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].bonds = {cmd = "manifest bonds @tar", rage = 30, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["fire Elemental Lord "].nrshieldbreak = {cmd = "manifest superheat @tar", rage = 0, desc = "Raze"}
			Legacy.Settings.Basher.Classes["fire Elemental Lady"].nrshieldbreak = {cmd = "manifest superheat @tar", rage = 0, desc = "Raze"}
    elseif gmcp.Char.Status.class == "earth Elemental Lord" or gmcp.Char.Status.class == 'earth Elemental Lady' then
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].smash = {cmd = "terran smash @tar", rage = 14, desc = "Small Damage", available = true }
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].smash = {cmd = "terran smash @tar", rage = 14, desc = "Small Damage", available = true }
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].rockfall = {cmd = "manifest rockfall @tar", rage = 18, desc = "Gives Affliction", aff = "stun", available = true }
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].rockfall = {cmd = "manifest rockfall @tar", rage = 18, desc = "Gives Affliction", aff = "stun", available = true }
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].charge = {cmd = "terran charge @tar", rage = 17, desc = "Shieldbreak", available = true }
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].charge = {cmd = "terran charge @tar", rage = 17, desc = "Shieldbreak", available = true }
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].flurry = {cmd = "terran flurry @tar", rage = 36, desc = "Big Damage", available = true }
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].flurry = {cmd = "terran flurry @tar", rage = 36, desc = "Big Damage", available = true }
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].magmaburst = {cmd = "manifest magmaburst @tar", rage = 25, desc = "Conditional", needs = {"recklessness", "clumsiness"}, available = true }
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].magmaburst = {cmd = "manifest magmaburst @tar", rage = 25, desc = "Conditional", needs = {"recklessness", "clumsiness"}, available = true }
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].rampart = {cmd = "terran rampart @tar", rage = 22, desc = "Buff", available = true }
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].rampart = {cmd = "terran rampart @tar", rage = 22, desc = "Buff", available = true }
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].configRage = {bigDamage = 20, smallDamage = 0, affAttack = 100}
      Legacy.Settings.Basher.Classes["earth Elemental Lord "].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
			Legacy.Settings.Basher.Classes["earth Elemental Lady"].nrshieldbreak = {cmd = "", rage = 0, desc = "Raze"}
        
    end
  end 
end
 
end
registerAnonymousEventHandler("LegacyLoaded", "Basher_Setup")
