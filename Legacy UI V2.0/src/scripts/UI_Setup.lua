function UI_Setup()
--if not Legacy then return end

  Legacy.UI = Legacy.UI or {}
  Legacy.UI.borderColor = Legacy.UI.borderColor or "DimGrey"
  Legacy.Settings.UI = Legacy.Settings.UI or {}
  Legacy.Settings.UI.Chatbox = Legacy.Settings.UI.Chatbox or {}
  Legacy.Settings.UI.Chatbox.ignoreMobs = Legacy.Settings.UI.Chatbox.ignoreMobs or false
  Legacy.Settings.UI.whoInfo = Legacy.Settings.UI.whoInfo or "class"
  Legacy.UI[gmcp.Char.Status.name] = Legacy.UI[gmcp.Char.Status.name] or {}
  

  --Build the Containers/Labels/Consoles

--Where Here
  Legacy.UI.WhoHereContainer = Adjustable.Container:new({
    name = "WhoHere",
    x=0, y="-35%",                 
    width = 300, height= 300, 
  })

  WhoLabel = Geyser.Label:new({
    name = "WhoLabel",
    x = "0%", y = "0%",
    width = "100%", height = "100%",
  },Legacy.UI.WhoHereContainer)

  WhoLabel:setStyleSheet([[
    background-color: black;
    border-width: 3px;
    border-style: solid;
    border-color: ]]..Legacy.UI.borderColor..[[;
    border-radius: 10px;
  ]])

Who = Geyser.MiniConsole:new({
  name='Who',
  color='black',
  x='7', y='7',
  width = '100%-10', height = '100%-10',
  fontSize = 10,
  font = "Bitstream Vera Sans Mono",
  autoWrap = true
}, WhoLabel)


--Map

Legacy.UI.Map = Adjustable.Container:new({
  name = "Map",
  x = "30%", y = "30%",
  width = 400, height = 300,
})

wilderness_map_container = Adjustable.Container:new({
  name = "Wilderness Map",
  x = "50%", y = "30%",
  width = 400, height = 300,
}) 

MapLabel = Geyser.Label:new({
    name = "MapLabel",
    x=0, y=0,
    width = "100%", height = "100%"

}, Legacy.UI.Map)

MapLabel:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
  qproperty-wordWrap: false;
]])


Map = Geyser.Mapper:new({
  name = "Map",
  x = 3, y = 3,
  width = "100%-8", height = "100%-10",
}, Legacy.UI.Map)

Wilderness = Geyser.MiniConsole:new({
  name='Wilderness',
  color='black',
  x=3, y=3,
  width = '100%-10', height = '100%-10',
  fontSize = 10,
  scrollbar = true,
  font = "Bitstream Vera Sans Mono",
  autoWrap = false
}, wilderness_map_container)

Ocean = Geyser.MiniConsole:new({
  name='Ocean',
  color='black',
  x=3, y=3,
  width = '100%-18', height = '100%-10',
  fontSize = 10,
  scrollbar = true,
  font = "Bitstream Vera Sans Mono",
  autoWrap = false
}, wilderness_map_container)

Ocean:hide()
Wilderness:hide()
Map:show()


--Mobs
Legacy.UI.Denizens = Adjustable.Container:new({
  name = "left_container_top",
  x=0, y=0,                     
  width = 300, height="33%",
})              

MobLabel = Geyser.Label:new({
  name = "MobLabel",
  x = "0%", y = "0%",
  width = "100%", height = "100%"
}, Legacy.UI.Denizens)



MobLabel:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
]])

Mobs = Geyser.MiniConsole:new({
  name='Mobs',
  color='black',
  x='7', y='7',
  width = '100%-10', height = '100%-10',
  fontSize = 10,
  font = "Bitstream Vera Sans Mono",
  autoWrap = false
}, MobLabel)

MobTitle = Geyser.Label:new({
  name = "MobTitle",
  x = "0%", y = "0%",
  width = "100%", height = 25,
  fgColor = "Gold",
  message = [[<center>DENIZENS</center>]]
}, MobLabel)

MobTitle:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
]])



--Items
Legacy.UI.Item = Adjustable.Container:new({
  name = "Items",
  x=0, y="31.5%",                     -- this container occupies the top, so it starts top-left as well
  width = 300, height= 300, -- but only uses up half of the height
})              -- this is the important bit - it says that left_container_top should be inside left_container

ItemLabel = Geyser.Label:new({
  name = "ItemLabel",
  x = "0%", y = "0%",
  width = "100%", height = "100%"
}, Legacy.UI.Item)



ItemLabel:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
  qproperty-wordWrap: false;
]])

Items = Geyser.MiniConsole:new({
  name='Items',
  color='black',
  x='7', y='7',
  width = '100%-10', height = '100%-10',
  fontSize = 10,
  scrollbar = true,
  font = "Bitstream Vera Sans Mono",
  autoWrap = false
}, ItemLabel)

ItemTitle = Geyser.Label:new({
  name = "ItemTitle",
  x = "0%", y = "0%",
  width = "100%", height = 25,
  fgColor = "Gold",
  message = [[<center>ITEMS</center>]]
}, ItemLabel)

ItemTitle:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
]])

--Chatbox
Legacy.UI.Chatbox = {
  tabs = {"All", "Direct", "Tells", "Says", "Party", "City", "Clans", "Market", "House", "Newbie"},
  height = "30%",
  width  = "30%",
  current = "All",
  color1  = Legacy.UI.borderColor,
  color2  = "black",
}

Legacy.UI.Chatbox.current = Legacy.UI.Chatbox.current or Chatbox.tabs[1]

Legacy.UI.Chatbox.container = Adjustable.Container:new({
  name = "Chatbox",
  x = "69%", y = "-30%",
  width = Legacy.UI.Chatbox.width,
  height = Legacy.UI.Chatbox.height,
})

Legacy.UI.Chatbox.header = Geyser.HBox:new({
  name = "Chatbox.header",
  x = 0, y = 0,
  width = "100%",
  height = "10%",
},Legacy.UI.Chatbox.container)

Legacy.UI.Chatbox.footer = Geyser.Label:new({
  name = "Chatbox.footer",
  x = 0, y = "10%",
  width = "100%",
  height = "90%",
},Legacy.UI.Chatbox.container)


Legacy.UI.Chatbox.center = Geyser.Label:new({
  name = "Chatbox.center",
  x = 0, y = 0,
  width = "100%",
  height = "100%",
},Legacy.UI.Chatbox.footer)

Legacy.UI.Chatbox.center:setStyleSheet([[
  background-color: ]]..Legacy.UI.Chatbox.color2..[[;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
]])



for k,v in pairs(Legacy.UI.Chatbox.tabs) do
--echo(v.."\n")
Legacy.UI.Chatbox[v.."tab"] = Geyser.Label:new({
    name = "Chatbox."..v.."tab",
  },Legacy.UI.Chatbox.header)
  
  Legacy.UI.Chatbox[v.."tab"]:setStyleSheet([[
    background-color: ]]..Legacy.UI.Chatbox.color1..[[;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    margin-right: 1px;
    margin-left: 1px;
  ]])
  Legacy.UI.Chatbox[v] = Geyser.MiniConsole:new({
    name = "Chatbox."..v,
    x = 7, y = 0,
    width = "99%",
    height = "99%",
    autoWrap = true,
    color = "black",
    scrollBar = true,
    fontSize = 10,
  },Legacy.UI.Chatbox.footer)

Legacy.UI.Chatbox[v.."tab"]:echo("<center>"..v)
Legacy.UI.Chatbox[v.."tab"]:setClickCallback("Legacy.Settings.UI.tabs", v)
Legacy.UI.Chatbox[v]:hide()
Legacy.UI.Chatbox.All:show()
end

  function Legacy.Settings.UI.tabs(tab)
   Legacy.UI.Chatbox[Legacy.UI.Chatbox.current]:hide()
    Legacy.UI.Chatbox[Legacy.UI.Chatbox.current.."tab"]:setStyleSheet([[
    background-color: ]]..Legacy.UI.Chatbox.color1..[[;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    margin-right: 1px;
    margin-left: 1px;
    ]])
    Legacy.UI.Chatbox.current = tab
    Legacy.UI.Chatbox[tab.."tab"]:setStyleSheet([[
    background-color: black;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    margin-right: 1px;
    margin-left: 1px;
  ]])
    Legacy.UI.Chatbox[Legacy.UI.Chatbox.current]:show()
  end
  
  
  --Player Info Card
  Legacy.UI.PlayerInfo = Adjustable.Container:new({
  name = "PlayerInfo",
  x = "30%", y = "30%",
  width = 550, height = 200,
})

PlayerLabel = Geyser.Label:new({
    name = "PlayerLabel",
    x = 0, y = 0,
    width = "100%", height = "100%",
}, Legacy.UI.PlayerInfo)

PlayerLabel:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
]])

PlayerTitleLabel = Geyser.Label:new({
  name = "PlayerTitle",
  x = 3, y = 3,
  width = math.floor((#gmcp.Char.Status.fullname)*6), height = 25,
}, PlayerLabel)

PlayerMsgsLabel = Geyser.Label:new({
  name = "PlayerMsgs",
  x = math.floor((#gmcp.Char.Status.fullname*6) + 2), y = 3,
  width = "100%-"..math.floor((#gmcp.Char.Status.fullname*6) + 5), height = 25,
}, PlayerLabel)

PlayerTitleLabel:setStyleSheet([[
  background-color: rgb(32,32,32);
  border-width: 1px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 1px;
]])

PlayerMsgsLabel:setStyleSheet([[
  background-color: rgb(32,32,32);
  border-width: 1px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 1px;
]])


PlayerStatusConsole = Geyser.MiniConsole:new({
  name = "PlayerConsole",
  color='black',
  x=5, y= 28,
  width = '100%-9', height = '100%-32',
  fontSize = 10,
  scrollbar = true,
  font = "Bitstream Vera Sans Mono",
  autoWrap = false
    
}, PlayerLabel)

function TitleCard()
PlayerTitleLabel = Geyser.Label:new({
  name = "PlayerTitle",
  x = 3, y = 3,
  width = math.floor((#gmcp.Char.Status.fullname)*6), height = 25,
}, PlayerLabel)

PlayerMsgsLabel = Geyser.Label:new({
  name = "PlayerMsgs",
  x = math.floor((#gmcp.Char.Status.fullname*6) + 2), y = 3,
  width = "100%-"..math.floor((#gmcp.Char.Status.fullname*6) + 5), height = 25,
}, PlayerLabel)
PlayerStatusConsole:clear()
PlayerTitleLabel:cecho("<gold>"..gmcp.Char.Status.fullname)
PlayerMsgsLabel:cecho("<gold>Msgs: <white>"..gmcp.Char.Status.unread_msgs.."     <gold>News: <white>"..gmcp.Char.Status.unread_news.."  <gold>Gold: <white>"..gmcp.Char.Status.gold.."  <gold>Banked:<white> "..gmcp.Char.Status.bank)
PlayerStatusConsole:cecho("\n<gold>Level: <white>"..gmcp.Char.Status.level)
PlayerStatusConsole:cecho("     <gold>Class: <white>"..gmcp.Char.Status.class)
PlayerStatusConsole:cecho("\n\n<gold>Race: <white>"..gmcp.Char.Status.gender:title().." "..gmcp.Char.Status.race.." "..gmcp.Char.Status.specialisation)
PlayerStatusConsole:cecho("\n\n<gold>Endurance: <magenta>"..math.floor((tonumber(gmcp.Char.Vitals.ep)/tonumber(gmcp.Char.Vitals.maxep))* 100).."%".."  <gold>Willpower: <yellow>"..math.floor((tonumber(gmcp.Char.Vitals.wp)/tonumber(gmcp.Char.Vitals.maxwp))* 100).."%")
end
registerAnonymousEventHandler("gmcp.Char.Vitals", "TitleCard")
  


--Bars
function Build_Bars()
  if not gmcp.Char or not gmcp.Room then
    tempTimer(3, [[Build_Bars()]])
    return
  end
  HPContainer = HPContainer or Adjustable.Container:new({
    name = "HPContainer",
    x = "30%", y = "30%",
    width = 400, height = 100
  })


  HPBarBack = Geyser.Label:new({
    name = "HPBack",
    x= 0, y=0,
    width = "100%", height = "100%",
  }, HPContainer)

  HPBarBack:setStyleSheet([[
    background-color: black;
    border-width: 3px;
    border-style: solid;
    border-color: ]]..Legacy.UI.borderColor..[[;
    border-radius: 10px;
  ]])

HPBar = Geyser.Gauge:new({
  name="HPBar",
  x=3, y=3,
  width="100%-7", height="100%-7",
}, HPBarBack)


HPBar.front:setStyleSheet([[background-color: green;
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 7;
    padding: 3px;
]])
HPBar.back:setStyleSheet([[background-color: DimGrey;
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 7;
    padding: 3px;
]])


HPBar:setValue(tonumber(gmcp.Char.Vitals.maxhp) ,tonumber(gmcp.Char.Vitals.maxhp))

MPContainer = Adjustable.Container:new({
  name = "MPContainer",
  x = "30%", y = "30%",
  width = 400, height = 100
})


MPBarBack = Geyser.Label:new({
  name = "MPBack",
  x= 0, y=0,
  width = "100%", height = "100%",
}, MPContainer)

MPBarBack:setStyleSheet([[
  background-color: black;
  border-width: 3px;
  border-style: solid;
  border-color: ]]..Legacy.UI.borderColor..[[;
  border-radius: 10px;
]])

MPBar = Geyser.Gauge:new({
  name="MPBar",
  x=3, y=3,
  width="100%-7", height="100%-7",
}, MPBarBack)


MPBar.front:setStyleSheet([[background-color: DeepSkyBlue;
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 7;
    padding: 3px;
]])

MPBar.back:setStyleSheet([[background-color: pink;
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 7;
    padding: 3px;
]])


MPBar:setValue(tonumber(gmcp.Char.Vitals.maxmp) ,tonumber(gmcp.Char.Vitals.maxmp))
end
registerAnonymousEventHandler("LegacyLoaded", "Build_Bars")
Build_Bars() 

  
  function Legacy.UI.WhoHere()
    Who:clear()
    if gmcp.Room.Info.area == "" and gmcp.Room.Info.num == -2 and gmcp.Room.Info.environment == "Vessel" then
      Who:cecho("<gold>Area<white>: <ansi_white>A Ship!\n")
      Who:cecho("<gold>Room<white>: <ansi_white>"..gmcp.Room.Info.name.."\n") 
    else
      Who:cecho("<gold>Area<white>: <ansi_white>"..gmcp.Room.Info.area.."\n")
      Who:cecho("<gold>Room<white>: <ansi_white>"..gmcp.Room.Info.name.." <DimGrey>(<gold>"..gmcp.Room.Info.num.."<DimGrey>)\n") 
    end
    
    Who:cecho("\n<OrangeRed>Who Here: <OrangeRed>(<white>"..math.floor(table.size(Legacy.Room.players) - 1).."<OrangeRed>)\n")
    
     Legacy.UI.isDead = {}
    for k,v in pairs(Legacy.Room.players) do
      if table.contains(gmcp.Room.Players, "the soul of "..k) then
       table.insert(Legacy.UI.isDead, k)
      end
    end

  for k, v in pairs(Legacy.Room.players) do
    local info = Legacy.Settings.UI.whoInfo
    if Legacy.NDB.db[tostring(k)] == nil then
      Legacy.NDB.lookup(tostring(k))
    elseif Legacy.NDB.db[tostring(k)].city:lower() == nil then
    elseif Legacy.NDB.db[tostring(k)].city:lower() == Legacy.NDB.db[gmcp.Char.Status.name].city:lower() and tostring(k) == gmcp.Char.Status.name then
    elseif Legacy.NDB.db[tostring(k)].city then
      if table.contains(Legacy.UI.isDead, tostring(k)) then
        Who:cechoLink("<"..Legacy.Settings.NDB.Config[Legacy.NDB.db[tostring(k)].city:lower()].color..">"..tostring(k).." <DimGrey>(<red><b>DEAD</b><DimGrey>)", function() expandAlias("ndb "..tostring(k)) end, "Click to show NDB Info.", true) if info ~= "none" then Who:cecho(" <DimGrey>(") Who:cechoPopup(Legacy.NDB.db[tostring(k)][info], {function() Legacy.Settings.UI.whoInfo = "class" raiseEvent("UI Update") end, function() Legacy.Settings.UI.whoInfo = "level" raiseEvent("UI Update") end, function() Legacy.Settings.UI.whoInfo = "ArmyRank" raiseEvent("UI Update") end}, {"Click to show class.", "Click to show level.", "Click to show Army Rank"}, true) Who:cecho("<DimGrey>)") end Who:echo("\n")
      else
        Who:cechoLink("<"..Legacy.Settings.NDB.Config[Legacy.NDB.db[tostring(k)].city:lower()].color..">"..tostring(k), function() expandAlias("ndb "..tostring(k)) end, "Click to show NDB Info.", true) if info ~= "none" then Who:cecho(" <DimGrey>(") Who:cechoPopup(Legacy.NDB.db[tostring(k)][info], {function() Legacy.Settings.UI.whoInfo = "class" raiseEvent("UI Update") end, function() Legacy.Settings.UI.whoInfo = "level" raiseEvent("UI Update") end, function() Legacy.Settings.UI.whoInfo = "ArmyRank" raiseEvent("UI Update") end}, {"Click to show class.", "Click to show level.", "Click to show Army Rank"}, true) Who:cecho("<DimGrey>)") end Who:echo("\n")
      end 
    elseif not city then
      Who:cecho("<orange>"..tostring(k).."\n")
    else
      Who:cecho("<orange>"..tostring(k).."\n")
    end
   end
  Who:echo("\n")
  end
registerAnonymousEventHandler("gmcp.Room.Players", "Legacy.UI.WhoHere")
  
  
  
  
  function Legacy.UI.Mobs()
    Mobs:clear()
    Mobs:echo("\n\n")
      for k,v in pairs(Legacy.Room.mobs) do
        local thing = v
        local id = k
        if Legacy.Basher then
          if Legacy.Settings.Basher.status == true then
            if Legacy.Settings.Basher.currentTar == k then
              Mobs:cecho("<ansi_white>[<SeaGreen>T<ansi_white>] ")
            end
            if table.contains(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower()) then
              Mobs:cechoPopup("<ansi_red>"..v, {function() 
                if not table.contains(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower()) then
                  table.insert(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower())
                  Legacy.echo("Added '<gold>"..v.."<white>' to hunting targets in <gold>"..gmcp.Room.Info.area)
                  send("ql")
                  PrioUpdate()
                end
              end, function() send("attack "..id) end,}, {"Add "..thing.." to hunting targets in "..gmcp.Room.Info.area, "Attack "..thing}, true) Mobs:echo("\n")
            elseif table.contains(Legacy.Settings.Basher.Ignore, v:lower()) then
              Mobs:cechoPopup("<ansi_green>"..v, {function() 
                if not table.contains(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower()) then
                  table.insert(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower())
                  Legacy.echo("Added '<gold>"..v.."<white>' to hunting targets in <gold>"..gmcp.Room.Info.area)
                  send("ql")
                  PrioUpdate()
                end
            end, function() send("attack "..id) end,}, {"Add "..thing.." to hunting targets in "..gmcp.Room.Info.area, "Attack "..thing}, true) Mobs:echo("\n")
            else
              Mobs:cechoPopup("<ansi_light_yellow>"..v, {function() 
                if not table.contains(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower()) then
                  table.insert(Legacy.Basher.Targets[gmcp.Room.Info.area], v:lower())
                  Legacy.echo("Added '<gold>"..v.."<white>' to hunting targets in <gold>"..gmcp.Room.Info.area)
                  send("ql")
                  PrioUpdate()
                end
            end, function() send("attack "..id) end,}, {"Add "..thing.." to hunting targets in "..gmcp.Room.Info.area, "Attack "..thing}, true) Mobs:echo("\n")
          end
          else
            Mobs:cechoPopup("<ansi_white>"..v, {function() send("greet "..id) end, function() send("attack "..id) end, function() send("get "..id) end}, {"Greet "..thing, "Attack "..thing, "Get "..thing}, true) Mobs:echo("\n")
          end
        else
            Mobs:cechoPopup("<ansi_white>"..v, {function() send("greet "..id) end, function() send("attack "..id) end, function() send("get "..id) end}, {"Greet "..thing, "Attack "..thing, "Get "..thing}, true) Mobs:echo("\n")
        end
      end
  end
-- registerAnonymousEventHandler("gmcp.Room.Players", "Legacy.UI.Mobs")
  
  -- function Legacy.UI.Mobs()
    -- Mobs:clear()
    -- Mobs:echo("\n\n")
     -- local ThingsIWantColored = {
     -- ["Elode, an Arcadian maiden"] = "<green>",
     -- 
     -- }
     -- MobCountTable = {} 
      -- for k,v in pairs(Legacy.Room.mobs) do
        -- if MobCountTable[v] == nil then
          -- MobCountTable[v] = {}
          -- MobCountTable[v].count = 1
        -- else
          -- MobCountTable[v].count = MobCountTable[v].count + 1
        -- end
        -- 
        -- 
      -- end
      -- table.sort(MobCountTable)
      -- for k,v in pairs(MobCountTable) do
          -- if MobCountTable[k].count > 1 then
            -- Mobs:cecho((ThingsIWantColored[k] or "<white>")..k.." <white>x"..MobCountTable[k].count.."\n")
          -- else
            -- Mobs:cecho((ThingsIWantColored[k] or "<white>")..k.."\n")
          -- end
        -- end
     -- end
registerAnonymousEventHandler("gmcp.Char.Items", "Legacy.UI.Mobs")
  
  function Legacy.UI.Items()
    Items:clear()
    Items:echo("\n\n")
    for k,v in pairs(Legacy.Room.items) do
      if v == "a large wall of ice" then
        Items:cecho("<DeepSkyBlue>"..v.."\n")
      elseif v == "a scorching wall of fire" then
        Items:cecho("<firebrick>"..v.."\n")
      elseif v == "a large wall of stone" then
        Items:cecho("<DimGrey>"..v.."\n")
      elseif v == "a ballista" then
        Items:cecho("<DarkViolet>"..v.."\n")
      elseif v == "an onager" then
        Items:cecho("<steel_blue>"..v.."\n")
      elseif v:match("the corpse of ") then
        local person = v:gsub("the corpse of ", "")
        Items:cecho("<DimGrey>the corpse of <"..(Legacy.Settings.NDB.Config[Legacy.NDB.db[person].city:lower()].color or "white")..">"..person.."\n")
      elseif v == "a tall stone beacon" then
        Items:cecho("<ansiLightMagenta>"..v.."\n")
      elseif v == "an Arcanian arm thrower" then
        Items:cecho("<DarkOrange>"..v.."\n")
      elseif v:match("a shrine of ") then
        Items:cechoPopup("<green>"..v, {function() send("queue add freestand get "..k) end, function() send("queue add freestand generosity") send("queue add freestand offer corpses") send("queue add freestand selfishness") end}, {"Probe "..v, "Offer corpses to "..v:gsub("a shrine of ", "")}, true) Items:echo("\n")
      elseif v:match("a metal tank") then
        Items:cechoPopup("<red>"..v, {function() send("queue add freestand curing off") send("queue add freestand dissarm "..k) end, function() send("queue add freestand curing off") send("queue add freestand capture "..k) end}, {"Dissarm tank", "Capture Tank"}, true) Items:echo("\n")
      elseif v:match("a sewer grate") then
        Items:cechoPopup("<yellow>"..v, {function() send("queue add freestand enter "..k) end, }, {"Enter "..v}, true) Items:echo("\n")
      elseif v:match("a group of") then
        Items:cechoPopup("<white>"..v, {function() send("queue add freestand get group "..k) end, function() send("queue add freestand probe "..k) end}, {"Get "..v, "Probe "..v}, true) Items:echo("\n")
      elseif v:match("sigil") then
        Items:cechoPopup("<cyan>"..v, {function() send("queue add freestand get "..k) end, function() send("queue add freestand probe "..k) end, function() send("attatch flame to "..k) end}, {"Get "..v,"Probe "..v, "Attatch a flame to "..v}, true) Items:echo("\n")
      elseif v:match("chest") then
        Items:cechoPopup("<magenta>"..v, {function() send("queue add freestand probe "..k) end, function() send("queue add freestand open "..k) end, function() send("queue add freestand close "..k) end}, {"Probe "..v, "Open "..v, "Close "..v}, true) Items:echo("\n")
      elseif v:match("a runic totem") then
        Items:cechoPopup("<forest_green>"..v, {function() send("queue add freestand probe "..k) end, function() send("queue add freestand smudge "..k) end}, {"Probe "..v, "Smudge "..v}, true) Items:echo("\n")
      else
        Items:cechoPopup("<white>"..v, {function() send("queue add freestand get "..k) end, function() send("queue add freestand probe "..k) end}, {"Get "..v, "Probe "..v}, true) Items:echo("\n")
      end
    end
  end
registerAnonymousEventHandler("gmcp.Char.Vitals", "Legacy.UI.Items")


function Legacy.UI.Bars()
  if HPBar == nil then return end
  if MPBar == nil then return end
    if tonumber(gmcp.Char.Vitals.hp) > tonumber(gmcp.Char.Vitals.maxhp) then
      HPBar:setValue(tonumber(gmcp.Char.Vitals.maxhp) ,tonumber(gmcp.Char.Vitals.maxhp))
      HPBar:setColor("orange")
      HPBar:setBold(true)
      HPBar:setFontSize("13")
      HPBar:setFgColor("black")
      HPBar:setText("<center>Health "..gmcp.Char.Vitals.hp.."/"..gmcp.Char.Vitals.maxhp)
    elseif math.floor((tonumber(gmcp.Char.Vitals.hp)/tonumber(gmcp.Char.Vitals.maxhp)* 100)) < 50 then
      HPBar:setColor("red")
      HPBar:setValue(tonumber(gmcp.Char.Vitals.hp) ,tonumber(gmcp.Char.Vitals.maxhp))
      HPBar:setBold(true)
      HPBar:setFontSize("13")
      HPBar:setFgColor("black")
      HPBar:setText("<center>Health "..gmcp.Char.Vitals.hp.."/"..gmcp.Char.Vitals.maxhp.." "..math.floor((tonumber(gmcp.Char.Vitals.hp)/tonumber(gmcp.Char.Vitals.maxhp)* 100)).."%")
    else
      HPBar:setValue(tonumber(gmcp.Char.Vitals.hp) ,tonumber(gmcp.Char.Vitals.maxhp))
      HPBar:setColor("forest_green")
      HPBar:setBold(true)
      HPBar:setFontSize("13")
      HPBar:setFgColor("black")
      HPBar:setText("<center>Health "..gmcp.Char.Vitals.hp.."/"..gmcp.Char.Vitals.maxhp.." "..math.floor((tonumber(gmcp.Char.Vitals.hp)/tonumber(gmcp.Char.Vitals.maxhp)* 100)).."%")

    end
    
    if tonumber(gmcp.Char.Vitals.mp) > tonumber(gmcp.Char.Vitals.maxmp) then
      MPBar:setValue(tonumber(gmcp.Char.Vitals.maxmp) ,tonumber(gmcp.Char.Vitals.maxmp))
      MPBar:setBold(true)
      MPBar:setFontSize("13")
      MPBar:setFgColor("black")
      MPBar:setText("<center>Mana "..gmcp.Char.Vitals.mp.."/"..gmcp.Char.Vitals.maxmp)
    else
      MPBar:setValue(tonumber(gmcp.Char.Vitals.mp) ,tonumber(gmcp.Char.Vitals.maxmp))
      MPBar:setBold(true)
      MPBar:setFontSize("13")
      MPBar:setFgColor("black")
      MPBar:setText("<center>Mana "..gmcp.Char.Vitals.mp.."/"..gmcp.Char.Vitals.maxmp.." "..math.floor((tonumber(gmcp.Char.Vitals.mp)/tonumber(gmcp.Char.Vitals.maxmp)* 100)).."%")
    end
  end
   registerAnonymousEventHandler("gmcp.Char.Vitals", "Legacy.UI.Bars")
   
  function Legacy.UI.Update()
    --setBorderLeft(310)
    --setWindowWrap(100)
    Legacy.UI.WhoHere()
    Legacy.UI.Items()
    Legacy.UI.Mobs()
    Legacy.UI.Bars()
  end
  registerAnonymousEventHandler("UI Update", "Legacy.UI.Update")
end
registerAnonymousEventHandler("LegacyLoaded", "UI_Setup")
