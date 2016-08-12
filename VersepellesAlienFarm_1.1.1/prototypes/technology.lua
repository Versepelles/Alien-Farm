data:extend(
{
	-- Capture capsules 1, 2, 3, 4
	{
		type = "technology",
		name = "capture-capsules",
		icon = "__VersepellesAlienFarm__/graphics/icons/capture-capsules-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "capture-capsule-1"
			},
			{
				type = "unlock-recipe",
				recipe = "capture-capsule-2"
			},
			{
				type = "unlock-recipe",
				recipe = "capture-capsule-3"
			},
			{
				type = "unlock-recipe",
				recipe = "capture-capsule-4"
			},
			{
				type = "unlock-recipe",
				recipe = "recapture-capsule"
			},
		},
		prerequisites = {},
		unit =
		{
			count = 20,
			ingredients =
			{
				{"science-pack-1", 1},
			},
			time = 10
		},
		order = "a[alien-farming]-a[capture-capsules]"
	},
	-- Command Capsules
	{
		type = "technology",
		name = "command-capsules",
		icon = "__VersepellesAlienFarm__/graphics/icons/command-capsules-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "train-capsule"
			},
			{
				type = "unlock-recipe",
				recipe = "goto-capsule"
			},
		},
		prerequisites = {"capture-capsules"},
		unit =
		{
			count = 50,
			ingredients =
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
			},
			time = 30
		},
		order = "a[alien-farming]-b[command-capsules]"
	},
	-- Breeding supplies
	-- Laser harvesters unlocked with laser turrets
	{
		type = "technology",
		name = "alien-breeding",
		icon = "__VersepellesAlienFarm__/graphics/icons/alien-breeding-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "alien-ovum"
			},
			{
				type = "unlock-recipe",
				recipe = "alien-ovum-artifact"
			},
			{
				type = "unlock-recipe",
				recipe = "artificial-spawner"
			},
			{
				type = "unlock-recipe",
				recipe = "incubator"
			},
			{
				type = "unlock-recipe",
				recipe = "harvester-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "reinforced-transport-belt"
			},
		},
		prerequisites = {"capture-capsules", "turrets", "automation"},
		unit =
		{
			count = 100,
			ingredients =
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
			},
			time = 20
		},
		order = "a[alien-farming]-c[alien-breeding]"
	},
})