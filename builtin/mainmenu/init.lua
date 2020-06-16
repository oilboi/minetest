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
    "button[5.5,4.5;5,2;singleplayer;singleplayer]"..
    "button[5.5,6.5;5,2;multiplayer;multiplayer]"..
    "button[5.5,8.5;5,2;options;options]"..
    "button[5.5,10.5;5,2;quit;quit game]"
)

core.sound_play("button", false)

function core.buttonhandler(fields)

    print("test")
end

function core.event_handler(event)
    print("test")
end

function core.buttonhandler(fields)
    print("test")
end