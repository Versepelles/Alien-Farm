local ent  -- placeholder for building each entity

-- Artificial Spawner
ent = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
ent.name = "artificial-spawner"
ent.minable.result = "artificial-spawner"
ent.icon = "__VersepellesAlienFarm__/graphics/icons/artificial-spawner.png"
ent.animation =
	{
      filename = "__VersepellesAlienFarm__/graphics/entity/artificial-spawner/artificial-spawner.png",
      priority = "high",
      width = 142,
      height = 113,
      frame_count = 1,
      line_length = 1,
      shift = {0.84, -0.09}
    }
ent.crafting_categories = {"alien-breeding"}
ent.crafting_speed = 1
data:extend({ent})

-- Incubator
ent = util.table.deepcopy(data.raw["container"]["wooden-chest"])
ent.name = "incubator"
ent.minable.result = "incubator"
ent.icon = "__VersepellesAlienFarm__/graphics/icons/incubator.png"
ent.collision_box = {{-0.15, -0.15}, {0.15, 0.15}}
ent.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
ent.picture = 
	{
      filename = "__VersepellesAlienFarm__/graphics/entity/incubator/incubator.png",
      priority = "extra-high",
      width = 62,
      height = 62,
      axially_symmetrical = false,
      shift = {-0.12, 0.25}
    }
ent.inventory_size = 2
data:extend({ent})

-- Harvester Turret
ent = util.table.deepcopy(data.raw["ammo-turret"]["gun-turret"])
ent.name = "harvester-turret"
ent.minable.result = "harvester-turret"
ent.icon = "__VersepellesAlienFarm__/graphics/icons/harvester-turret.png"
ent.base_picture.layers[1].filename = "__VersepellesAlienFarm__/graphics/entity/harvester-turret/harvester-turret-base.png"
ent.base_picture.layers[2].filename = "__VersepellesAlienFarm__/graphics/entity/harvester-turret/harvester-turret-base-mask.png"
ent.attack_parameters.range = 5
data:extend({ent})

-- Laser Harvester
function laser_harvester_extension(inputs)
return
{
  filename = "__VersepellesAlienFarm__/graphics/entity/laser-harvester/laser-harvester-gun-start.png",
  priority = "medium",
  width = 66,
  height = 67,
  frame_count = inputs.frame_count and inputs.frame_count or 15,
  line_length = inputs.line_length and inputs.line_length or 0,
  run_mode = inputs.run_mode and inputs.run_mode or "forward",
  axially_symmetrical = false,
  direction_count = 4,
  shift = {0.0625, -0.984375}
}
end

ent = util.table.deepcopy(data.raw["electric-turret"]["laser-turret"])
ent.name = "laser-harvester"
ent.minable.result = "laser-harvester"
ent.icon = "__VersepellesAlienFarm__/graphics/icons/laser-harvester.png"
ent.base_picture.layers[1].filename = "__VersepellesAlienFarm__/graphics/entity/laser-harvester/laser-harvester-base.png"
ent.prepared_animation.layers[1].filename = "__VersepellesAlienFarm__/graphics/entity/laser-harvester/laser-harvester-gun.png"
ent.folded_animation.layers[1] = laser_harvester_extension{frame_count=1, line_length = 1}
ent.preparing_animation.layers[1] = laser_harvester_extension{}
ent.folding_animation.layers[1] = laser_harvester_extension{run_mode = "backward"}
ent.attack_parameters.range = 5
data:extend({ent})

-- Reinforced Transport Belt
local reinforced_belt_horizontal =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32
  }
local reinforced_belt_vertical =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 40
  }
local reinforced_belt_ending_top =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 80
  }
local reinforced_belt_ending_bottom =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 120
  }
local reinforced_belt_ending_side =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 160
  }
local reinforced_belt_starting_top =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 200
  }
local reinforced_belt_starting_bottom =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 240
  }
local reinforced_belt_starting_side =
  {
    filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png",
    priority = "extra-high",
    width = 40,
    height = 40,
    frame_count = 32,
    y = 280
  }

ent = util.table.deepcopy(data.raw["transport-belt"]["fast-transport-belt"])
ent.name = "reinforced-transport-belt"
ent.minable.result = "reinforced-transport-belt"
ent.icon = "__VersepellesAlienFarm__/graphics/icons/reinforced-transport-belt.png"
ent.max_health = 400
ent.animations.filename = "__VersepellesAlienFarm__/graphics/entity/reinforced-transport-belt/reinforced-transport-belt.png"
ent.belt_horizontal = reinforced_belt_horizontal
ent.belt_vertical = reinforced_belt_vertical
ent.ending_top = reinforced_belt_ending_top
ent.ending_bottom = reinforced_belt_ending_bottom
ent.ending_side = reinforced_belt_ending_side
ent.starting_top = reinforced_belt_starting_top
ent.starting_bottom = reinforced_belt_starting_bottom
ent.starting_side = reinforced_belt_starting_side
data:extend({ent})
