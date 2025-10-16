local data_util = {}

function data_util.recipe_require_tech(recipe_name, tech_name)
  if data.raw.recipe[recipe_name] and data.raw.technology[tech_name] then
    data_util.disable_recipe(recipe_name)
    for _, tech in pairs(data.raw.technology) do
      if tech.effects then
        data_util.remove_recipe_from_effects(tech.effects, recipe_name)
      end
    end
    local already = false
    data.raw.technology[tech_name].effects = data.raw.technology[tech_name].effects or {}
    for _, effect in pairs(data.raw.technology[tech_name].effects) do
      if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
        already = true
        break
      end
    end
    if not already then
      table.insert(data.raw.technology[tech_name].effects, { type = "unlock-recipe", recipe = recipe_name})
    end
  end
end


function data_util.remove_recipe_from_effects(effects, recipe)
  local index = 0
  for _,_item in ipairs(effects) do
    if _item.type == "unlock-recipe" and _item.recipe == recipe then
      index = _
      break
    end
  end
  if index > 0 then
    table.remove(effects, index)
  end
end

function data_util.disable_recipe(recipe_name)
  data_util.conditional_modify({
    type = "recipe",
    name = recipe_name,
    enabled = false,
    normal = {
      enabled = false
    },
    expensive = {
      enabled = false
    }
  })
end


function data_util.conditional_modify(prototype)
  -- pass in a partial prototype that includes .type and .name
  -- overwrite sections of the raw prototype with the new one
  if data.raw[prototype.type] and data.raw[prototype.type][prototype.name] then
    local raw = data.raw[prototype.type][prototype.name]

    -- update to new spec
    if not raw.normal then
      raw.normal = {
        enabled = raw.enabled,
        energy_required = raw.energy_required,
        hidden = raw.hidden,
        ingredients = raw.ingredients,
        results = raw.results,
        result = raw.result,
        result_count = raw.result_count,
        allow_as_intermediate = raw.allow_as_intermediate,
        allow_decomposition = raw.allow_decomposition,
        allow_inserter_overload = raw.allow_inserter_overload,
        allow_intermediates = raw.allow_intermediates,
        always_show_made_in = raw.always_show_made_in,
        always_show_products = raw.always_show_products,
        hide_from_player_crafting = raw.hide_from_player_crafting,
        overload_multiplier = raw.overload_multiplier,
        requester_paste_multiplier = raw.requester_paste_multiplier,
        show_amount_in_title = raw.show_amount_in_title
      }
      raw.enabled = nil
      raw.energy_required = nil
      raw.requester_paste_multiplier = nil
      raw.hidden = nil
      raw.ingredients = nil
      raw.results = nil
      raw.result = nil
      raw.result_count = nil
    end
    if not raw.expensive then
      raw.expensive = table.deepcopy(raw.normal)
    end
    if not raw.normal.results and raw.normal.result then
      data_util.result_to_results(raw.normal)
    end
    if not raw.expensive.results and raw.expensive.result then
      data_util.result_to_results(raw.expensive)
    end

    for key, property in pairs(prototype) do
      if key == "ingredients" then
        raw.normal.ingredients = property
        raw.expensive.ingredients = property
      elseif key ~= "normal" and key ~= "expensive" then
        raw[key] = property
      end
    end

    if prototype.normal then
      for key, property in pairs(prototype.normal) do
        raw.normal[key] = property
      end
    end

    if prototype.expensive then
      for key, property in pairs(prototype.expensive) do
        raw.expensive[key] = property
      end
    end

  end
end


-- transform result style definition to full results definition for a given prototype section
-- recipe_section is either the recipe prrototype, recipe.normal, or recipe.difficult
function data_util.result_to_results(recipe_section)
  if not recipe_section.result then return end
  local result_count = recipe_section.result_count or 1
  if type(recipe_section.result) == "string" then
    recipe_section.results = {{type="item", name= recipe_section.result, amount = result_count}}
  elseif recipe_section.result.name then
    recipe_section.results = {recipe_section.result}
  elseif recipe_section.result[1] then
    result_count = recipe_section.result[2] or result_count
    recipe_section.results = {{type="item", name= recipe_section.result[1], amount = result_count}}
  end
  recipe_section.result = nil
end

return data_util