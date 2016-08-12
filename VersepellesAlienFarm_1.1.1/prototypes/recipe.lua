data:extend(
{
  ---------------------------------------------------------
  -- Alien Ovum
  {
    type = "recipe",
    name = "alien-ovum",
	enabled = "false",
    energy_required = 5,
	category = "alien-breeding",
	ingredients = 
    {
		{"alien-artifact", 1},
	},
	result = "alien-ovum",
	result_count = 10,
  },
  -- Alien Artifact (Reverse Ovum)
  {
    type = "recipe",
    name = "alien-ovum-artifact",
	enabled = "false",
    energy_required = 5,
	category = "alien-breeding",
	ingredients = 
    {
		{"alien-ovum", 10},
	},
	result = "alien-artifact",
  },
  -- Artificial Spawner
  {
    type = "recipe",
    name = "artificial-spawner",
	enabled = "false",
	ingredients = 
    {
		{"alien-artifact", 10},
		{"electronic-circuit", 5},
		{"iron-plate", 7},
		{"steel-plate", 5},
	},
	result = "artificial-spawner",
  },
  -- Incubator
  {
    type = "recipe",
    name = "incubator",
	enabled = "false",
	ingredients = 
    {
		{"alien-ovum", 20},
		{"electronic-circuit", 3},
		{"iron-plate", 3},
		{"stone-brick", 4},
	},
	result = "incubator",
  },
  -- Harvester Turret
  {
    type = "recipe",
    name = "harvester-turret",
	enabled = "false",
    energy_required = 10,
	ingredients = 
    {
		{"alien-ovum", 5},
		{"iron-plate", 20},
		{"copper-plate", 10},
		{"iron-gear-wheel", 10},
	},
	result = "harvester-turret",
  },
  -- Laser Harvester
  {
    type = "recipe",
    name = "laser-harvester",
	enabled = "false",
    energy_required = 20,
	ingredients = 
    {
		{"alien-ovum", 5},
		{"steel-plate", 20},
		{"electronic-circuit", 20},
		{"battery", 12},
	},
	result = "laser-harvester",
  },
  -- Reinforced Transport Belt
  {
    type = "recipe",
    name = "reinforced-transport-belt",
	enabled = "false",
	ingredients = 
    {
		{"fast-transport-belt", 1},
		{"iron-gear-wheel", 5},
		{"steel-plate", 1},
	},
	result = "reinforced-transport-belt",
  },
  
  ---------------------------------------------------------
  -- Capture Capsules
  {
    type = "recipe",
    name = "capture-capsule-1",
	enabled = "false",
	ingredients = 
    {
		{"electronic-circuit", 1},
		{"iron-plate", 1},
		{"copper-cable", 2},
	},
	result = "capture-capsule-1"
  },
  {
    type = "recipe",
    name = "capture-capsule-2",
	enabled = "false",
	ingredients = 
    {
		{"advanced-circuit", 1},
		{"iron-plate", 1},
		{"red-wire", 2},
	},
	result = "capture-capsule-2"
  },
  {
    type = "recipe",
    name = "capture-capsule-3",
	enabled = "false",
	ingredients = 
    {
		{"advanced-circuit", 1},
		{"iron-plate", 1},
		{"battery", 1},
		{"red-wire", 2},
	},
	result = "capture-capsule-3"
  },
  {
    type = "recipe",
    name = "capture-capsule-4",
	enabled = "false",
	ingredients = 
    {
		{"processing-unit", 1},
		{"iron-plate", 1},
		{"battery", 1},
		{"red-wire", 1},
		{"green-wire", 1},
		{"alien-artifact", 1},
	},
	result = "capture-capsule-4"
  },
  {
    type = "recipe",
    name = "recapture-capsule",
	enabled = "false",
	ingredients = 
    {
		{"electronic-circuit", 2},
		{"iron-plate", 3},
		{"green-wire", 3},
	},
	result = "recapture-capsule",
	result_count = 10
  },
  
  ---------------------------------------------------------
  -- Command Capsules
  {
    type = "recipe",
    name = "train-capsule",
	enabled = "false",
	ingredients = 
    {
		{"electronic-circuit", 1},
		{"copper-plate", 1},
		{"red-wire", 1},
	},
	result = "train-capsule",
	result_count = 10
  },
  {
    type = "recipe",
    name = "goto-capsule",
	enabled = "false",
	ingredients = 
    {
		{"electronic-circuit", 1},
		{"copper-plate", 1},
		{"red-wire", 1},
	},
	result = "goto-capsule",
	result_count = 10
  },
})