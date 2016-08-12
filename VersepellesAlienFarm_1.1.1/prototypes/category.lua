data:extend(
{
  -- Recipe Categories
  {
    type = "recipe-category",
    name = "alien-breeding"
  },
  
  -- Item Categories
  {
    type = "item-group",
    name = "alien-farm",
    order = "e[alien-farm]",
	inventory_order = "z",
	icon = "__VersepellesAlienFarm__/graphics/icons/alien-farm-group.png",
  },
  {
    type = "item-subgroup",
    name = "breeding",
    group = "alien-farm",
    order = "a[breeding]",
  },
  {
    type = "item-subgroup",
    name = "farm-capsules",
    group = "alien-farm",
    order = "b[farm-capsules]",
  },
  {
    type = "item-subgroup",
    name = "alien-capsules",
    group = "alien-farm",
    order = "c[alien-capsules]",
  },
  {
    type = "item-subgroup",
    name = "command-capsules",
    group = "alien-farm",
    order = "c[command-capsules]",
  },
})
