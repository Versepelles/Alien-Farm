-- Base Changes --

-- if laser turrets tech exists, add laser harvester to the laser turrets tech, else add it to the alien-breeding tech
if data.raw["technology"]["laser-turrets"] then
	table.insert(data.raw["technology"]["laser-turrets"].effects, {type = "unlock-recipe", recipe = "laser-harvester"})
else
	table.insert(data.raw["technology"]["alien-breeding"].effects, {type = "unlock-recipe", recipe = "laser-harvester"})
end