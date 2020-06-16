-- disable the clouds to save gpu
core.set_clouds(false)

-- get paths
mainmenu_path = core.get_builtin_path() .. DIR_DELIM .. "/mainmenu/"

texture_path = mainmenu_path .. DIR_DELIM .. "/textures/"
sound_path   = mainmenu_path .. DIR_DELIM .. "/sounds/"

click = sound_path .. "click.ogg"


-- set the background
core.set_background("background", texture_path .. "dirt.png", true, 64)

-- enable client modding
core.settings:set("enable_client_modding", "true")

-- makes the world darker at night
core.settings:set("ambient_occlusion_gamma", "1.4")

--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[]"..
    "bgcolor[#00000000]"..
    "image[1.2,0; 16.68243243243243, 3 ;"..core.formspec_escape(texture_path.."crafter.png").."]"..
    "button[5.5,4.5;5,2;button;singleplayer]"..
    "button[5.5,6.5;5,2;button;multiplayer]"..
    "button[5.5,8.5;5,2;button;options]"..
    "button[5.5,10.5;5,2;button;quit game]"
)

core.sound_play("button", false)

core.button_handler = function(event)
    if event.button then
        core.sound_play("button", false)
        if event.button == "singleplayer" then
            print("oh wow singlep layer")
        end
    end
	--if ui.handle_events(event) then
	--	ui.update()
	--	return
	--end

    
	--if event == "Refresh" then
	--	ui.update()
	--	return
	--end
end

core.button_handler = function(fields)
    if fields["btn_reconnect_yes"] then
		gamedata.reconnect_requested = false
		gamedata.errormessage = nil
		gamedata.do_reconnect = true
		core.start()
		return
	elseif fields["btn_reconnect_no"] or fields["btn_error_confirm"] then
		gamedata.errormessage = nil
		gamedata.reconnect_requested = false
		ui.update()
		return
	end

	if ui.handle_buttons(fields) then
		ui.update()
	end
end