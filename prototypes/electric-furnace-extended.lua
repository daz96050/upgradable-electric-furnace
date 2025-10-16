local data_util = require('__space-exploration__/data_util')
local make_recipe = data_util.make_recipe

make_recipe({
  name = "stone-brick-crushed",
  ingredients = {
    { name = "stone-brick", amount = 1, type = "item"}
  },
  results = {
    { type = "item", name = "stone", amount = 1},
  },
  energy_required = 0.2,
  category = "pulverising",
  enabled = false,
  always_show_made_in = false
})
data_util.tech_lock_recipes("se-pulveriser",{"stone-brick-crushed"})
make_recipe({
  name = "electric-stone-furnace-upgrade",
  ingredients = {
    {name = "electric-stone-furnace", amount = 1, type = "item"},
    {name = "electronic-circuit", amount = 6, type = "item"},
    {name = "steel-plate", amount = 6, type = "item"}
  },
  results = {
    { type = "item", name = "electric-steel-furnace", amount = 1}
  },
  energy_required = 3,
  enabled = false
})
make_recipe({
  name = "electric-steel-furnace-upgrade",
  ingredients = {
    {name = "electric-steel-furnace", amount = 1, type = "item"},
    {name = "advanced-circuit", amount = 5, type = "item"},
    {name = "steel-plate", amount = 5, type = "item"},
    {name = "se-heat-shielding", amount = 1, type = "item"}
  },
  results = {
    { type = "item", name = "electric-furnace", amount = 1},
  },
  energy_required = 3,
  enabled = false
})
data_util.recipe_require_tech("electric-stone-furnace-upgrade", "advanced-material-processing")
data_util.recipe_require_tech("electric-steel-furnace-upgrade", "advanced-material-processing-2")

--
----Fix that electric furnaces don't allow any kiln recipes (namely Stone Bricks)
--local function find_furnace(name)
--  if data.raw.furnace[name] then return data.raw.furnace[name] end
--  if data.raw["assembling-machine"][name] then return data.raw["assembling-machine"][name] end
--  if data.raw[name] then return data.raw[name] end
--end

--local furnaces = {
--  stone_furnace = find_furnace("electric-stone-furnace"),
--  steel_furnace = find_furnace("electric-steel-furnace"),
--  elect_furnace_2 = find_furnace("electric-furnace-2"),
--  elect_furnace_3 = find_furnace("electric-furnace-3")
--}
--
--for _,value in pairs(furnaces) do
--  table.insert(value.crafting_categories, "kiln")
--end