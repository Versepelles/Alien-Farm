require("config")
--require("other-mod-configs.config")

---------------------------------------------------------
-- Constants
local FPS = 60 -- frames per second, in case this varies 
local DOCILE = "docile" -- the force for docile aliens
local SLAUGHTER = "slaughter" -- the force for aliens about to be killed
local TRAINED = "trained" -- units commandable by the player via command capsules

local harvestTurretPeriod = 1 -- the number of seconds between harvester ticks
local incubatorPeriod = 1 -- the number of seconds between incubator ticks
local trainedUnitsPeriod = 3 -- the number of seconds between checking trained units

---------------------------------------------------------
-- Handle new players
function newPlayer(event)
  local player = game.players[event.player_index]
  
  ---- TEST ----
  --[[
  player.insert{name = "steel-axe", count = 50}
  player.insert{name = "stone-wall", count = 500}
  player.insert{name = "piercing-rounds-magazine", count = 500}
  player.insert{name = "small-biter-capsule", count = 50}
  player.insert{name = "train-capsule", count = 50}
  player.insert{name = "goto-capsule", count = 50}
  player.insert{name = "artificial-spawner", count = 50}
  player.insert{name = "incubator", count = 50}
  player.insert{name = "small-lamp", count = 50}
  player.insert{name = "harvester-turret", count = 50}
  player.insert{name = "laser-harvester", count = 50}
  player.insert{name = "alien-ovum", count = 50}
  player.insert{name = "alien-artifact", count = 50}
  
  player.insert{name = "long-handed-inserter", count = 50}
  player.insert{name = "solar-panel", count = 50}
  player.insert{name = "medium-electric-pole", count = 50}
  player.insert{name = "accumulator", count = 50}
  player.insert{name = "steel-chest", count = 50}
  player.insert{name = "fast-inserter", count = 50}
  player.insert{name = "fast-transport-belt", count = 50}
  player.insert{name = "assembling-machine-3", count = 50}
  player.insert{name = "roboport", count = 5}
  player.insert{name = "gun-turret", count = 50}
  player.insert{name = "laser-turret", count = 50}
  player.insert{name = "repair-pack", count = 350}
  player.insert{name = "construction-robot", count = 50}
  ]]--
end
script.on_event(defines.events.on_player_created, newPlayer)

---------------------------------------------------------
-- Process all ongoing events
function onTick()
	processHarvesterTurrets()
	processIncubators()
	processTrainedUnits()
end

---------------------------------------------------------
-- Initialize various objects
function onInit()
	if not game.forces[DOCILE] then game.create_force(DOCILE) end -- create "docile" force
	if not game.forces[SLAUGHTER] then game.create_force(SLAUGHTER) end -- create "slaughter" force
	if not game.forces[TRAINED] then game.create_force(TRAINED) end -- create "trained" force
	for __, force in pairs(game.forces) do -- make docile, slaughter, and trained forces peaceful to all, and vice-versa
		game.forces[DOCILE].set_cease_fire(force.name, true)
		game.forces[SLAUGHTER].set_cease_fire(force.name, true)
		game.forces[TRAINED].set_cease_fire(force.name, true)
		force.set_cease_fire(DOCILE, true)
		force.set_cease_fire(SLAUGHTER, true)
		force.set_cease_fire(TRAINED, true)
	end
	game.forces.player.set_cease_fire(SLAUGHTER, false) -- allow the player force to attack previously docile entities, and vice-versa
	game.forces[SLAUGHTER].set_cease_fire(game.forces.player, false)
	game.forces.enemy.set_cease_fire(TRAINED, false) -- allow the trained force to attack enemy entities, and vice-versa
	game.forces[TRAINED].set_cease_fire(game.forces.enemy, false)
	
	global.harvesterTurrets = global.harvesterTurrets or {}
	global.incubators = global.incubators or {}
	generateIncubationChances()
	global.trainedGroup = global.trainedGroup or {}
	
	script.on_event(defines.events.on_tick, onTick)
end
script.on_init(onInit)

-- This method generates the derived chancePerIncubationTick from incubationTime for AlienFarmDict
function generateIncubationChances()
	for __, alien in pairs(AlienFarmDict) do
		if not alien.chancePerIncubationTick then
			alien.chancePerIncubationTick = incubatorPeriod / alien.incubationTime
		end
	end
end

---------------------------------------------------------
-- On reload, make sure that various objects are initialized and that processing continues
function onLoad()
	generateIncubationChances()
	script.on_event(defines.events.on_tick, onTick)
end
script.on_load(onLoad)

---------------------------------------------------------
-- Keep track of built objects
function builtEntity(event)
	local ent = event.created_entity
	local name = ent.name
	if name == "harvester-turret" or name == "laser-harvester" then
		table.insert(global.harvesterTurrets, ent)
	elseif name == "incubator" then
		table.insert(global.incubators, ent)
	end
end
script.on_event(defines.events.on_built_entity, builtEntity)
script.on_event(defines.events.on_robot_built_entity, builtEntity)

---------------------------------------------------------
-- Keep track of capsule-created objects
function triggerEntity(event)
	local ent = event.entity
	local name = ent.name
	if AlienFarmCapsules[name] then -- if this is a capture-capsule, try to catch something
		captureAlien(ent)
	elseif AlienFarmDict[name] then -- if this is a spawned alien, set its force to docile
		ent.force = game.forces[DOCILE]
	elseif AlienFarmCommands[name] then -- if this is a command, process it appropriately 
		processCommand(ent)
	end
end
script.on_event(defines.events.on_trigger_created_entity, triggerEntity)

---------------------------------------------------------
-- Handle alien deaths
function entityDied(event)
	local ent = event.entity
	if ent.force.name == SLAUGHTER and AlienFarmDict[ent.name] then -- if this was an artificially spawned alien
		local dropRate = AlienFarmDict[ent.name].dropRate
		if math.random() <= dropRate then -- randomly drop an artifact
			ent.surface.spill_item_stack(ent.position, {name = "alien-artifact", count = 1})
		end
	end
end
script.on_event(defines.events.on_entity_died, entityDied)

---------------------------------------------------------
-- Capture Capsule: Use a capture capsule to catch wild aliens!
function captureAlien(capsule)
	local r = 1 -- capture radius (it's a box)
	local posx = capsule.position.x
	local posy = capsule.position.y
	local capturePotentials, capturePotentials2
	if capsule.name == "recapture-capsule" then -- recapture capsules only work on player-spawned entities (docile and trained)
		capturePotentials = capsule.surface.find_entities_filtered{area = {{posx - r, posy - r}, {posx + r, posy + r}}, force = DOCILE}
		capturePotentials2 = capsule.surface.find_entities_filtered{area = {{posx - r, posy - r}, {posx + r, posy + r}}, force = TRAINED}
		for k, v in pairs(capturePotentials2) do capturePotentials[k] = v end -- merge all captured potentials into one table
	else
		capturePotentials = capsule.surface.find_entities{{posx - r, posy - r}, {posx + r, posy + r}}
	end
	for __, potentialAlien in pairs(capturePotentials) do
		-- if the entity is an alien, try to catch it
		if AlienFarmDict[potentialAlien.name] then
			local catchRate = AlienFarmCapsules[capsule.name].efficiency * AlienFarmDict[potentialAlien.name].catchRate -- the catch rate is (capsule efficieny) * (alien catch rate)
			
			-- handle behemoths who require a master capsule
			if AlienFarmDict[potentialAlien.name].requiresMaster and capsule.name ~= "capture-capsule-4" then 
				catchRate = 0
			end
			
			-- if successful catch, destroy the alien and give the player the appropriate spawn capsule
			if math.random() <= catchRate then
				game.players[1].insert{name = (potentialAlien.name .. "-capsule"), count = 1}
				potentialAlien.surface.create_entity({name = "flying-text", position = potentialAlien.position, text = "caught!", color = {r = 1, g = 0, b = 0}})
				potentialAlien.destroy()
			else
				potentialAlien.surface.create_entity({name = "flying-text", position = potentialAlien.position, text = "miss", color = {r = 1, g = 1, b = 1}})
			end
			return 																													-- only allow one capture attempt per capsule
		end
	end
end

---------------------------------------------------------
-- Harvest Turret: Changes entities' force from docile to slaughter within range
local turretR = 5 -- the box radius of the turret to detect entities
function processHarvesterTurrets()
	if (game.tick % (FPS * harvestTurretPeriod) == 0)  then
		for index, turret in pairs(global.harvesterTurrets) do
			if turret and turret.valid then
				local pos = turret.position
				local docileEnts = turret.surface.find_entities_filtered{area = {{pos.x - turretR, pos.y - turretR}, {pos.x + turretR, pos.y + turretR}}, force = DOCILE}
				for __, docileEnt in pairs(docileEnts) do
					if docileEnt and docileEnt.valid then
						docileEnt.force = game.forces[SLAUGHTER] -- change docile entities to slaughter
					end
				end
			else
				table.remove(global.harvesterTurrets, index)
			end
		end
	end
end

---------------------------------------------------------
-- Incubator: Hatch aliens near the incubator
function processIncubators()
	if (game.tick % (FPS * incubatorPeriod) == 0) then
		for index, incubator in pairs(global.incubators) do
			if incubator and incubator.valid then
				local incubatorInfo = getIncubatorInfo(incubator)
				if incubatorInfo.validIncubation then
					if math.random() <= AlienFarmDict[incubatorInfo.alienName].chancePerIncubationTick then -- check if ovum hatches this tick
						local success
						
						-- if the alien has a chance to evolve, spawn its evolution nearby.
						-- else, spawn the alien nearby
						local evolveRate = AlienFarmDict[incubatorInfo.alienName].evolveRate
						if evolveRate and math.random() <= evolveRate then
							success = generateIncubatedAlien(AlienFarmDict[incubatorInfo.alienName].evolveResult, incubator)
						else
							success = generateIncubatedAlien(incubatorInfo.alienName, incubator)
						end
						
						if success then
							incubator.get_inventory(1).remove({name = "alien-ovum", count = 1}) -- remove one ovum if we spawned an alien
						end
					end
				end
			else
				table.remove(global.incubators, index)
			end
		end
	end
end

--  This method returns a table like:
--	{
--		boolean validIncubation, -- whether the incubation can produce an alien
--		string alienName,  -- what alien to produce
--	}
function getIncubatorInfo(incubator)
	if incubator.name ~= "incubator" then return nil end -- check if we actually got an incubator
	local valid, potentialName  -- elements to return
	local inventory = incubator.get_inventory(1)
	
	-- search for a "...-capsule" item
	for itemName, __ in pairs(inventory.get_contents()) do
		if not potentialName then
			potentialName = getResultAlien(itemName)
		end
	end
	
	valid = (potentialName ~= nil) and (inventory.get_item_count("alien-ovum") > 0)
	return {["validIncubation"] = valid, ["alienName"] = potentialName}
end

-- This function returns the name of a alien that can be incubated from an item, or nil if none can
-- We expect capsules to be named like "small-biter-capsules"
local capsuleSuffix = "-capsule"
local capsuleSuffixLen = string.len(capsuleSuffix)
function getResultAlien(itemName)
	itemNameLen = string.len(itemName)
	if itemNameLen <= capsuleSuffixLen then return nil end -- return nil if the item name is too short
	if not string.sub(itemName, itemNameLen - capsuleSuffixLen + 1, itemNameLen) == capsuleSuffix then -- check if the item name ends with "-capsule"
		return nil
	else
		local potentialName = string.sub(itemName, 1, itemNameLen - capsuleSuffixLen) -- the item name without "-capsule"
		if AlienFarmDict[potentialName] == nil then -- check if the name is a valid alien
			return nil
		else
			return potentialName
		end
	end
end

-- This function creates an alien from incubation near the given position
-- Returns true if an alien was spawned, false if not
local incubatorR = 2 -- the box radius of the incubator to spawn entities
function generateIncubatedAlien(alienName, incubator)
	local surface = incubator.surface
	local pos = incubator.position
	local openPositions = {}
	-- search for potential spawn points around the incubator
	for i = -incubatorR, incubatorR do
		for j = -incubatorR, incubatorR do
			if surface.can_place_entity{name = alienName, position = {pos.x + i, pos.y + j}} then
				table.insert(openPositions, {pos.x + i, pos.y + j})
			end
		end
	end
	
	-- if a alien can be created, then do so and return true. If not, return false.
	if #openPositions == 0 then
		return false
	else
		local randomPosition = openPositions[math.random(#openPositions)]
		incubator.surface.create_entity{name = alienName, force = game.forces[DOCILE], position = randomPosition}
		return true
	end
end

---------------------------------------------------------
-- Command Capsules: Manage the training and commands of player aliens
local trainR = 5 -- the box radius of units to train
local gotoR = 3 -- the box radius of the area to goto
local attackR = 7 -- the radius of the area to attack
function processCommand(commandCapsule)
	if not AlienFarmCommands[commandCapsule.name] then return end -- make sure we have a command
	local command = AlienFarmCommands[commandCapsule.name].command
	local pos = commandCapsule.position

	-- remove entities from trainedGroup if they are no longer valid
	for index, alien in pairs(global.trainedGroup) do
		if not (alien and alien.valid) then
			global.trainedGroup[index] = nil
		end
	end
	
	if command == "train" then
		potentials = commandCapsule.surface.find_entities_filtered{area = {{pos.x - trainR, pos.y - trainR}, {pos.x + trainR, pos.y + trainR}}, force = DOCILE}
		for __, alien in pairs(potentials) do 
			alien.force = game.forces[TRAINED]
			table.insert(global.trainedGroup, alien)
			alien.surface.create_entity({name = "flying-text", position = alien.position, text = "trained!", color = {r = 0, g = 0.7, b = 0}})
		end
	elseif command == "goto" then
		for index, alien in pairs(global.trainedGroup) do
			alien.set_command{type = defines.command.go_to_location, destination = pos}
		end
	end
end

-- Trained units become docile if farther away than the threshold (set in config.lua)
function processTrainedUnits()
	if (game.tick % (FPS * trainedUnitsPeriod) == 0)  then
		for index, alien in pairs(global.trainedGroup) do
			if alien and alien.valid then
				if distanceBetween(game.players[1].position, alien.position) > MaxTrainedRange then -- if far away from player, remove the trained unit from the group and set it to docile
					alien.force = game.forces[DOCILE]
					global.trainedGroup[index] = nil
				elseif IndicateTrainedUnits then -- indicate trained units as marked in config.lua
					alien.surface.create_entity({name = "flying-text", position = alien.position, text = "!", color = {r = 0, g = 0.7, b = 0}})
				end
			else
				table.remove(global.trainedGroup, index)
			end
		end
	end
end

-- Utility function for regular L-2 norm distance
function distanceBetween(pos1, pos2)
	return math.sqrt(math.pow((pos1.x - pos2.x), 2) + math.pow((pos1.y - pos2.y), 2))
end
