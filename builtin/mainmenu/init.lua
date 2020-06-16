-- disable the clouds to save gpu
core.set_clouds(false)

-- get paths
mainmenu_path = core.get_builtin_path() .. DIR_DELIM .. "/mainmenu/"

texture_path = mainmenu_path .. DIR_DELIM .. "/textures/"
sound_path   = mainmenu_path .. DIR_DELIM .. "/sounds/"

click = sound_path .. "click"


-- set the background
core.set_background("background", texture_path .. "dirt.png", true, 64)

<<<<<<< Updated upstream
tabs.settings = dofile(menupath .. DIR_DELIM .. "tab_settings.lua")
tabs.content  = dofile(menupath .. DIR_DELIM .. "tab_content.lua")
tabs.credits  = dofile(menupath .. DIR_DELIM .. "tab_credits.lua")
if menustyle == "simple" then
	tabs.simple_main = dofile(menupath .. DIR_DELIM .. "tab_simple_main.lua")
else
	tabs.local_game = dofile(menupath .. DIR_DELIM .. "tab_local.lua")
	tabs.play_online = dofile(menupath .. DIR_DELIM .. "tab_online.lua")
end
=======
-- enable client modding
core.settings:set("enable_client_modding", "true")
>>>>>>> Stashed changes

-- makes the world darker at night
core.settings:set("ambient_occlusion_gamma", "1.4")

--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[]"..
    "bgcolor[#00000000]"..
    "image[-1,0; 22.24324324324324, 4 ;"..core.formspec_escape(texture_path.."crafter.png").."]"..
    "button[5.55,4.5;5,2;singleplayer;singleplayer]"..
    "button[5.55,6.5;5,2;multiplayer;multiplayer]"..
    "button[5.55,8.5;5,2;options;options]"..
    "button[5.55,10.5;5,2;quit;quit game]"
)

core.sound_play(sound_path .. "lever", true)

<<<<<<< Updated upstream
		local found_singleplayerworld = false
		for i, world in ipairs(world_list) do
			if world.name == "singleplayerworld" then
				found_singleplayerworld = true
				world_index = i
				break
			end
		end

		if not found_singleplayerworld then
			core.create_world("singleplayerworld", 1)

			world_list = core.get_worlds()

			for i, world in ipairs(world_list) do
				if world.name == "singleplayerworld" then
					world_index = i
					break
				end
			end
		end

		gamedata.worldindex = world_index
	else
		menudata.worldlist = filterlist.create(
			core.get_worlds,
			compare_worlds,
			-- Unique id comparison function
			function(element, uid)
				return element.name == uid
			end,
			-- Filter function
			function(element, gameid)
				return element.gameid == gameid
			end
		)

		menudata.worldlist:add_sort_mechanism("alphabetic", sort_worlds_alphabetic)
		menudata.worldlist:set_sortmode("alphabetic")

		if not core.settings:get("menu_last_game") then
			local default_game = core.settings:get("default_game") or "minetest"
			core.settings:set("menu_last_game", default_game)
		end

		mm_texture.init()
	end

	-- Create main tabview
	local tv_main = tabview_create("maintab", {x = 12, y = 5.4}, {x = 0, y = 0})

	if menustyle == "simple" then
		tv_main:add(tabs.simple_main)
	else
		tv_main:set_autosave_tab(true)
		tv_main:add(tabs.local_game)
		tv_main:add(tabs.play_online)
	end

	tv_main:add(tabs.content)
	tv_main:add(tabs.settings)
	tv_main:add(tabs.credits)

	tv_main:set_global_event_handler(main_event_handler)
	tv_main:set_fixed_size(false)

	if menustyle ~= "simple" then
		local last_tab = core.settings:get("maintab_LAST")
		if last_tab and tv_main.current_tab ~= last_tab then
			tv_main:set_tab(last_tab)
		end
	end
	ui.set_default("maintab")
	tv_main:show()

	ui.update()

	core.sound_play("main_menu", true)
end

init_globals()
=======
--core.buttonhandler(fields)
>>>>>>> Stashed changes
