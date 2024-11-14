local item_sounds = require("__base__.prototypes.item_sounds")

prometheus_core.generateFuncCallFromArray = function(func, func_source)
		local func = func
		local func_source = func_source

		for _, params in ipairs(func_source) do
				func(table.unpack(params))
		end
end

prometheus_core.create_40mm_ammo = function(array)
		local item_type = array.item_type
		local name = array.name
		local piercing_damage = array.piercing_damage
		local ent_glow = array.ent_glow or false
		local stack = array.stack
		local magazine = array.magazine
		local order = array.order
		local cooldown_modifier = array.cooldown_modifier
		local range_modifier = array.range_modifier
		local direction_setup = array.direction_setup
		local target_type = array.target_type
		local collisions = array.collisions
		local collision_force = array.collision_force
		local projectile_is_empty = array.projectile_is_empty or false
		local projectile_light = array.projectile_light or nil
		local projectile_glow = array.projectile_glow or false
		local projectile_scale = array.projectile_scale
		local projectile_acc = array.projectile_acc
		local projectile_is_parented = array.projectile_is_parented
		local parent_name = array.parent_name
		local energy_required = array.energy_required
		local recipe_ingredients = array.recipe_ingredients
		local category_craft = array.category_craft
		local action = array.action
		local custom_shadow = array.custom_shadow
		local shadow_name = array.shadow_name
		local subgroup = array.subgroup
		local direction_only = direction_only
		local direction_deviation = direction_deviation
		local range_deviation = range_deviation
		local max_range = max_range
		local min_range = min_range

		if name then
				dash = "_"
				dot = "."
		else
				dash = ""
				dot = ""
		end
		if projectile_is_parented == true then
				subname = parent_name
		elseif array.clone then subname = array.clone
		else
				subname = name
		end
		if array.clone then clone_name = array.clone else clone_name = name end

		if not projectile_is_empty then
				if shadow_name then 
					shadow_folder = prometheus_core.anim_to_projectile_sprite(prometheus_core.weapon_assets, "40mm_gl_" .. shadow_name .. "_shadow", glow, true, projectile_scale)
							else 
								shadow_folder = prometheus_core.anim_to_projectile_sprite(prometheus_core.weapon_assets, "40mm_gl" .. "_shadow", glow, true, projectile_scale) 
				end

				if projectile_glow == true then
						anim_folder = {prometheus_core.anim_to_single_layer(prometheus_core.anim_to_projectile_sprite(prometheus_core.weapon_assets, "40mm_gl" .. dash .. (subname or ""),
								glow, shadow, projectile_scale), prometheus_core.anim_to_projectile_sprite(prometheus_core.weapon_assets,
								"40mm_gl" .. dash .. (subname or "") .. "_glow", true, shadow, projectile_scale))}

				else
						anim_folder = prometheus_core.anim_to_projectile_sprite(prometheus_core.weapon_assets, "40mm_gl" .. dash .. (subname or ""), glow, shadow,
								projectile_scale)
				end
		else
				anim_folder = nil
				shadow_folder = nil
		end

		if not action then
				action = gl_40mm_actions_list[clone_name] or gl_40mm_actions_list["frag"]
		end

		if collisions then
				collision_box = {{-0.35, -0.75}, {0.35, 0.75}}
				if collision_force == "collision_only_enemy" then
						force_condition = "enemy"
				elseif collision_force == "collisions_all" then
						force_condition = "all"
				elseif collision_force == "collisions_ally" then
						force_condition = "ally"
				elseif collision_force == "collisions_friend" then
						force_condition = "friend"
				elseif collision_force == "collisions_not_friend" then
						force_condition = "not-friend"
				elseif collision_force == "collisions_same" then
						force_condition = "same"
				elseif collision_force == "collisions_not_same" then
						force_condition = "not-same"
				end
				if collisions == "null_collisions" then
						collision_box = {{0, 0}, {0, 0}}
				end
		else
				collision_box = nil
		end
		if ent_glow == true then
				pic_folder = {prometheus_core.anim_to_single_layer(prometheus_core.assign_to_picture(prometheus_core.weapon_assets_40mm, (clone_name or "") .. dash .. "box"),
						prometheus_core.assign_to_picture(prometheus_core.weapon_assets_40mm, (clone_name or "") .. dash .. "box_glow", true, "additive"))}
		else
				pic_folder = prometheus_core.assign_to_picture(prometheus_core.weapon_assets_40mm, (clone_name or "") .. dash .. "box")
		end
		if direction_setup == "thermobaric_setup" then
				direction_only = true
				direction_deviation = 0.3
				range_deviation = 0.3
				max_range = 80
				min_range = 8
		elseif direction_setup == "base_setup" then
				direction_only = true
				direction_deviation = 0.5
				range_deviation = 0.2
				max_range = 60
				min_range = 6
		elseif direction_setup == "iron_fist_setup" then
				direction_only = false
				direction_deviation = 0.25
				range_deviation = 0.2
				max_range = 60
				min_range = 6
		elseif direction_setup == "uran_fist_setup" then
				direction_only = false
				direction_deviation = 0.25
				range_deviation = 0.2
				max_range = 80
				min_range = 6
		elseif direction_setup == "pluto_setup" then
				direction_only = false
				direction_deviation = 0.1
				range_deviation = 0.2
				max_range = 160
				min_range = 6
		elseif direction_setup == "sentry_eye_setup" then
				direction_only = false
				direction_deviation = 0.3
				range_deviation = 0.2
		end
		data:extend({{
				type = "projectile",
				name = "PLORD_40mm_grenade" .. dash .. (name or ""),
				flags = {"not-on-map"},
				collision_box = collision_box or nil,
				acceleration = projectile_acc or -0.00009,
				direction_only = direction_only or false,
				force_condition = force_condition or "all",
				light = projectile_light,
				animation = anim_folder,
				shadow = shadow_folder,
				piercing_damage = piercing_damage or 0,
				action = action
		}})
		if item_type == "ammo" then
				data:extend({
					{
						type = "ammo",
						name = "PLORD_40mm_gl" .. dash .. (name or ""),
						localised_name = {"item-name.PLORD_40mm_gl" .. dash .. (clone_name or "")},
						localised_description = {"item-description.PLORD_40mm_gl" .. dash .. (clone_name or "")},
						icon = prometheus_core.dir .. "graphics/icons/weapons/40mm_gl" .. dash .. (clone_name or "") .. ".png",
						icon_size = 128,
						
						magazine_size = magazine or 16,
						subgroup = subgroup or "PLORD_heavy_weapons_gl_ammo",
						order = order or nil,
						stack_size = stack or 50,
						pictures = pic_folder,
						ammo_category = "PLORD_40mm_grenade_ammo",
						ammo_type = {
								category = "PLORD_40mm_grenade_ammo",
								target_type = target_type or "position",
								cooldown_modifier = cooldown_modifier or nil,
								range_modifier = range_modifier or nil,
								action = {{
										type = "direct",
										action_delivery = {
												type = "projectile",
												projectile = "PLORD_40mm_grenade" .. dash .. (name or ""),
												starting_speed = 0.45,
												direction_deviation = direction_deviation or nil,
												range_deviation = range_deviation or nil,
												max_range = max_range or nil,
												min_range = min_range or nil
										}
								}, {
										type = "direct",
										action_delivery = {
												type = "instant",
												source_effects = {
														type = "create-entity",
														entity_name = "explosion-hit"
												},
												target_effects = {{
														type = "play-sound",
														sound = game_core.base_ent_sounds_path.throw_projectile
												}}
										}
								}}
						}
					}
			})
			if not array.clone then
				data:extend({
					{
							type = "recipe",
							name = "PLORD_40mm_gl" .. dash .. (name or ""),
							category = category_craft or nil,
							enabled = false,
							energy_required = energy_required or 5,
							ingredients = recipe_ingredients or {},
							results = {{type = "item", name = "PLORD_40mm_gl" .. dash .. (name or ""), amount = 1}},
					}
				})
			end
		end
		return
end

prometheus_core.shot_sound = function()
		return
			{
				aggregation = {max_count = 4, remove = true},
				allow_random_repeat = true,
				variations = 
				{
					{filename = prometheus_core.dir .. "sound/grenade_launcher_shot_01.ogg", min_speed = 0.8, max_speed = 1.2, volume = 1.0},
					{filename = prometheus_core.dir .. "sound/grenade_launcher_shot_02.ogg", min_speed = 0.8, max_speed = 1.2, volume = 1.0},
					{filename = prometheus_core.dir .. "sound/grenade_launcher_shot_03.ogg", min_speed = 0.8, max_speed = 1.2, volume = 1.0},
				}
			}
end
cyrus_core.generate_icon = function(path_type, name, size)
	return
	{{icon = path_type .. name .. ".png", icon_size = size, icon_mipmaps = 4}}
end
cyrus_core.generate_icon_tech = function(path_type, name, size)
	return
	{
		{
			icon = path_type .. name .. ".png",
			icon_size = size or 256, 
		},
		{
			icon = "__core__/graphics/icons/technology/constants/constant-equipment.png",
			icon_size = 128,
			scale = 0.5,
			shift = {50, 50}
		}
	}
end
cyrus_core.generate_picture = function(path_type, name, size, scale)
	return
		{
		{
			layers =
				{
					{filename=path_type .. name .. ".png", size = size, scale = scale},
					{filename=path_type .. "equip_gl_glow.png", blend_mode = "additive", draw_as_light = true, size = size, scale = scale,
					flags = {"light"}}
				}
		}
		}
end
cyrus_core.generate_sprite = function(name, size, scale)
	return
		{
			filename = prometheus_core.weapon_icons .. name .. ".png",
			width = size,
			height = size,
			scale = scale,
			priority = "medium",
			hr_version = {
				filename =  prometheus_core.technologies_icons .. "tech_" .. name .. ".png",
				width = size * 2,
				height = size * 2,
				priority = "medium",
				scale = scale * 0.5
			}
		}
end

--[[ (name, action, cd, range, min_range, dmgmod, energy_consumption, buffer_capacity, gun_sounds, order, recipe_energy, recipe_count, tech_on, tech_ing, requirenments, tech_count, tech_time, tech_order)]]--
cyrus_core.create_cyrus_launcher = function(array)
	local name = array.name or nil
	local action = array.action
	local cooldown = array.cooldown
	local range = array.range
	local min_range = array.min_range
	local damage_modifier = array.damage_modifier
	local energy_consumption = array.energy_consumption
	local buffer_capacity = array.buffer_capacity
	local gun_sounds = array.gun_sounds
	local order = array.order
	local recipe_energy = array.recipe_energy
	local recipe_count = array.recipe_count 
	local tech_on = array.tech_on
	local tech_ing = array.tech_ing
	local requirenments = array.requirenments
	local tech_count = array.tech_count
	local tech_time = array.tech_time
	local tech_order = array.tech_order

	if name then dash = "_" else dash = "" end
	data:extend({{
		type = "active-defense-equipment",
		name = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or ""),
		sprite = cyrus_core.generate_sprite("equip_gl" .. dash .. (name or "_frag"), 128, 0.5 * 1.25),
		shape = 
		{
			width = 2,
			height = 2,
			type = "full"
		},
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-input",
			buffer_capacity = buffer_capacity or "500kJ"
		},

		attack_parameters =
		{
			type = "projectile",
			projectile_center = {0.083, 0},
			projectile_creation_distance = 0.5,
			cooldown = cooldown or 200,
			range = range or 50,
			min_range = min_range or 30,
			damage_modifier = damage_modifier or 1.25,
			sound = gun_sounds or prometheus_core.shot_sound(),
			ammo_category = "PLORD_40mm_grenade_ammo",
			ammo_type =
			{
				energy_consumption = energy_consumption or "570kJ",
				action = action or data.raw["ammo"]["PLORD_40mm_gl" .. dash .. (array.name or "")].ammo_type.action,
			}
		},
		
		automatic = true,
    categories = {"armor"}
		},
		{
			type = "item",
			name = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or ""),
			icons = cyrus_core.generate_icon(prometheus_core.weapon_icons, "equip_gl" .. dash .. (name or "_frag"), 128),
			pictures = cyrus_core.generate_picture(prometheus_core.weapon_icons, "equip_gl" .. dash .. (name or "_frag"), 128, 0.17),
			place_as_equipment_result = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or ""),
			subgroup = "PLORD_heavy_weapons_gl_equip",
			order = order,
			default_request_amount = 5,
			inventory_move_sound = item_sounds.turret_inventory_move,
			pick_sound = item_sounds.turret_inventory_pickup,
			drop_sound = item_sounds.turret_inventory_move,
			stack_size = 20,
			weight = 180*kg
		},
		{
			type = "recipe",
			name = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or ""),
			enabled = false,
			energy_required = recipe_energy or 10,
			ingredients =
			{
				{type = "item", name = "PLORD_40mm_gl" .. dash .. (name or ""), amount = recipe_count or 20},
				{type = "item", name = "processing-unit", amount = 20},
				{type = "item", name = "low-density-structure", amount = 5},
				{type = "item", name = "PLORD_gl_40mm_turret", amount = 5},
			},
			results = {{type = "item", name = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or ""), amount = 1}},
		},
	})
	if tech_on == true then
	data:extend({{
			type = "technology",
			name = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or ""),
			icons = cyrus_core.generate_icon_tech(prometheus_core.technologies_icons, "tech_equip_gl" .. dash .. (name or "_frag")),
			localised_description = array.localised_description or {"", {"technology-description.personal-laser-defense-equipment"}},
			prerequisites = requirenments,
			effects =
			{
				{
					type = "unlock-recipe",
					recipe = "PLORD_personal_shoulder_gl40mm" .. dash .. (name or "")
				}
			},
			unit =
			{
				count = tech_count or 100,
				ingredients = tech_ing or {},
				time = tech_time or 35
			},
			order = tech_order or "g-m-b"
		}})
	end
		return
end


prometheus_core.apply_flags_to_entity = function(force_name, ent_type, ent_name, ent_class, lvl, ...)
	local force_name = false
	local lvl = lvl
	local flags = {}
	for e_name, entity in pairs(data.raw[ent_type]) do 
		if (force_name == false and ((ent_name and e_name:find(ent_name)) or (not ent_name))) or (force_name == true and ((ent_name and (e_name == ent_name)) or (not ent_name))) then
			if (ent_class and e_name:find(ent_class)) or (not ent_class) then 
				if (lvl and e_name:find(lvl)) or (not lvl) then
						for i=1, select("#", ...), 1 do
							local flag = select(i, ...)
							if not entity.flags then entity.flags = {} end
							flags = flag
							entity.flags[i] = flags
						end
				end
			end
		end
	end
end

prometheus_core.apply_resistance = function(array)
		local force_name = array.force_name or false
		local lvl = array.lvl or nil
		local resistances = {}

		for e_name, entity in pairs(data.raw[array.ent_type]) do
			local forceCheck = (not force_name or (force_name and e_name == array.ent_name))
			local nameCheck = (array.ent_name and e_name:find(array.ent_name)) or (not array.ent_name)
			local classCheck = (array.ent_class and e_name:find(array.ent_class)) or (not array.ent_class)
			local lvlCheck = (array.lvl and e_name:find(array.lvl)) or (not array.lvl)
			
			if forceCheck and nameCheck and classCheck and lvlCheck then
						if #array.resistances > 0 then
								if not entity.resistances then entity.resistances = {} end
								for i, resist_data in ipairs(array.resistances) do
										local resist_type, resist_decrs, resist_count = resist_data[1], resist_data[2], resist_data[3]
										local resistances = {type = resist_type, decrease = resist_decrs, percent = resist_count}
										table.insert(entity.resistances, resistances)
								end
						end
				end
		end
end

prometheus_core.anim_to_single_layer = function(...)
	for i=1, select("#", ...), 1 do
	animation = {layers = {select(i, ...)}}
	return animation
	end
end

prometheus_core.anim_to_projectile_sprite = function(asset, file_name, glow, shadow, scale, width, wmult, height, hmult)
		return
			{
					filename = asset .. file_name .. ".png",
					draw_as_glow = glow or false,
					draw_as_shadow = shadow or false,
					width = width or 64,
					height = height or 64,
					priority = "high",
					scale = scale or 0.2,
					hr_version =
					{
						filename = asset .. file_name .. "_hr.png",
						draw_as_glow = glow or false,
						draw_as_shadow = shadow or false,
						width = width or 128,
						height = height or 128,
						priority = "high",
						scale = (scale or 0.2) * 0.5,
					}
			}
end

prometheus_core.assign_to_picture = function(asset, file_name, glow, blend, scale, size)
	return
	{filename = asset .. file_name .. ".png", blend_mode = blend or "normal", draw_as_light = glow or false, size = size or 128, scale = scale or 0.17}
end

prometheus_core.replaceIngredient = function(array)
		for _, recipe in pairs(data.raw.recipe) do
				if recipe.name == array.recipe then
						if array.ingredients then
								local filteredIngredients = {}
								for _, ingredient in pairs(array.ingredients) do
										if type(ingredient) == "table" then
												for _, subIngredient in ipairs(ingredient) do
														if type(subIngredient) == "table" then
																if subIngredient.type == "fluid" and data.raw.fluid[subIngredient.name] then
																		table.insert(filteredIngredients, subIngredient)
																		break
																elseif #subIngredient == 2 and
																		(data.raw.ammo[subIngredient[1]] or data.raw.capsule[subIngredient[1]] or
																				data.raw.item[subIngredient[1]]) then
																		table.insert(filteredIngredients, {
																				type = "item",
																				name = subIngredient[1],
																				amount = subIngredient[2]
																		})
																		break
																elseif #subIngredient > 2 and #subIngredient % 2 == 0 then
																		for i = 1, #subIngredient, 2 do
																				if (data.raw.ammo[subIngredient[i]] or data.raw.capsule[subIngredient[i]] or
																						data.raw.item[subIngredient[i]]) then
																						table.insert(filteredIngredients, {
																								type = "item",
																								name = subIngredient[i],
																								amount = subIngredient[i + 1]
																						})
																						break
																				end
																		end
																end
														end
												end
												if ingredient.type == "fluid" and data.raw.fluid[ingredient.name] then
														table.insert(filteredIngredients, ingredient)
												elseif #ingredient == 2 and
														(data.raw.ammo[ingredient[1]] or data.raw.capsule[ingredient[1]] or
																data.raw.item[ingredient[1]]) then
														table.insert(filteredIngredients, {
																type = "item",
																name = ingredient[1],
																amount = ingredient[2]
														})
												elseif #ingredient > 2 and #ingredient % 2 == 0 then
														for i = 1, #ingredient, 2 do
																if (data.raw.ammo[ingredient[i]] or data.raw.capsule[ingredient[i]] or
																		data.raw.item[ingredient[i]]) then
																		table.insert(filteredIngredients, {
																				type = "item",
																				name = ingredient[i],
																				amount = ingredient[i + 1]
																		})
																		break
																end
														end
												end
										elseif type(ingredient) == "string" and
												(data.raw.ammo[ingredient] or data.raw.capsule[ingredient] or data.raw.item[ingredient]) then
												table.insert(filteredIngredients, {
														type = "item",
														name = ingredient,
														amount = 1
												})
										end

								end
								recipe.ingredients = filteredIngredients
						else
								if (data.raw.ammo[array.ingredient[1]] or data.raw.capsule[array.ingredient[1]] or
										data.raw.item[array.ingredient[2]]) ~= nil then
										for i, ingredient in pairs(recipe.ingredients) do
												if ingredient[1] == array.ingredient[1] then
														recipe.ingredients[i] = {
																type = "item",
																name = array.ingredient[2],
																amount = array.ingredient[3]
														}
												end
										end
								end
						end
				end
		end
end



prometheus_core.setIngredient = function(array)
	local filteredIngredients = {}
	for _, ingredient in pairs(array) do
		if type(ingredient) == "table" then
			for _, subIngredient in ipairs(ingredient) do
					if type(subIngredient) == "table" then
							if subIngredient.type == "fluid" and data.raw.fluid[subIngredient.name] then
									table.insert(filteredIngredients, subIngredient)
									break
							elseif #subIngredient == 2 and (data.raw.ammo[subIngredient[1]] or data.raw.capsule[subIngredient[1]] or data.raw.item[subIngredient[1]]) then
									table.insert(filteredIngredients, subIngredient)
									break
							elseif #subIngredient > 2 and #subIngredient % 2 == 0 then
									for i = 1, #subIngredient, 2 do
											if (data.raw.ammo[subIngredient[i]] or data.raw.capsule[subIngredient[i]] or data.raw.item[subIngredient[i]]) then
													table.insert(filteredIngredients, {subIngredient[i], subIngredient[i + 1]})
													break
											end
									end
							end
					end
			end
			if ingredient.type == "fluid" and data.raw.fluid[ingredient.name] then
				table.insert(filteredIngredients, ingredient)
			elseif #ingredient == 2 and (data.raw.ammo[ingredient[1]] or data.raw.capsule[ingredient[1]] or data.raw.item[ingredient[1]]) then
				table.insert(filteredIngredients, ingredient)
			elseif #ingredient > 2 and #ingredient % 2 == 0 then
				for i = 1, #ingredient, 2 do
					if (data.raw.ammo[ingredient[i]] or data.raw.capsule[ingredient[i]] or data.raw.item[ingredient[i]]) then
						table.insert(filteredIngredients, {ingredient[i], ingredient[i + 1]})
						break
					end
				end
			end
		elseif type(ingredient) == "string" and (data.raw.ammo[ingredient] or data.raw.capsule[ingredient] or data.raw.item[ingredient]) then
			table.insert(filteredIngredients, ingredient)
		end

	end
	return filteredIngredients
end