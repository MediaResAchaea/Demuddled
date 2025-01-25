local settings = Legacy.Settings.Basher.Classes[gmcp.Char.Status.class] --import Legacy settings to local
--Legacy.Settings.Basher.Rage()
--Legacy basher clickable settings
cecho("\n<white>- <gold>Legacy Basher settings for: <cyan>"..gmcp.Char.Status.class)
cechoLink("\n<white>- <cyan>Attack set to:            <ansi_yellow>"..settings.attack, function() appendCmdLine("battack ") end, "Click for cmd to add your own attack", true)
cechoLink("\n<white>- <cyan>Prepend set to:           <ansi_yellow>"..settings.pre, function() appendCmdLine("pre ") end, "Click to change presend. Use your game side cmd separator", true)
cechoLink("\n<white>- <cyan>Shieldbreak set to:       <ansi_yellow>"..(settings.nrshieldbreak.cmd or ""), function() appendCmdLine("bshield ") end, "Click for cmd to add shield attack", true)
cechoLink("\n<white>- <cyan>Will use rage atks:       <ansi_yellow>"..tostring(Legacy.Settings.Basher.useRage), function() appendCmdLine("lrage") end, "Click for cmd to toggle using rage", true)
cechoLink("\n<white>- <cyan>Will flee when low:       <ansi_yellow>"..tostring(Legacy.Settings.Basher.flee), function() expandAlias("bflee") end, "Click for cmd to toggle fleeing", true)
cechoLink("\n<white>- <cyan>Will use Rainbow Crits:   <ansi_yellow>"..tostring(Legacy.Settings.Basher.rainbows), function() if Legacy.Settings.Basher.rainbows ~= true then Legacy.Settings.Basher.rainbows = true Legacy.echo("will now use Rainbow Crits!") else Legacy.Settings.Basher.rainbows = false Legacy.echo("Boring Criticals enabled!") end end, "Click for cmd to toggle fleeing", true)
--Gold tracker clickable display
if Legacy.Settings.Basher.goldtrack == false then
cechoLink("\n\n\n<white>- <cyan>Gold tracking: <red>Off       <ansi_yellow> Click to start tracking", function() expandAlias("gtrack") end, "Click to start tracking gold", true)
elseif Legacy.Settings.Basher.goldtrack == true then
cechoLink("\n\n\n<white>- <cyan>Gold tracking: <green>On", function() expandAlias("gtrack") end, "Click to stop tracking gold", true)
cecho("     ")
cechoLink("<red>    Reset", function() appendCmdLine("greset") end, "Click for cmd to completely reset gold tracking", true)
cecho("\n<white>- <cyan>Current group:")
cechoLink("<LightSeaGreen> + ", function() appendCmdLine("add <name> to group") end, "Add person to group", true)
cechoLink("<firebrick> - ", function() appendCmdLine("remove <name> from group") end, "Remove person from group", true)
echo("      ")
local counter = 0
for k, v in pairs(Legacy.Settings.Basher.Group) do
  counter = counter + 1
  if counter == table.size(Legacy.Settings.Basher.Group) then
    cechoLink("<ansi_yellow>"..k, function() appendCmdLine("remove "..k.." from group") end, "Remove "..k.." from group", true)
  else
    cechoLink("<ansi_yellow>"..k..", ", function() appendCmdLine("remove "..k.." from group") end, "Remove "..k.." from group", true)
  end
end
cecho("\n<white>- <cyan>Total gold tracked:       <ansi_yellow>"..Legacy.Settings.Basher.Gold.."  ")
cechoLink("<LightSeaGreen> + ", function() appendCmdLine("gadd ") end, "Click and enter amount of gold to add to total", true)
cecho(" ")
cechoLink("<firebrick> - ", function() appendCmdLine("gsub ") end, "Click and enter amount of gold to subtrack from total", true)
local splitammount = math.floor(Legacy.Settings.Basher.Gold / table.size(Legacy.Settings.Basher.Group))
cechoLink("\n<white>- <cyan>Amount to split:          <ansi_yellow>"..splitammount, function() expandAlias("gsplit") end, "Click to split gold in group", true)
cechoLink("\n<white>- <cyan>Gold container:           <ansi_yellow>"..(Legacy.Settings.Basher.goldContainer or "<red>CLICK TO SET!"), function() appendCmdLine("gpack ") end, "Click to set gold container for storing gold till split", true)
end