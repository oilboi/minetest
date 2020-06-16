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

local texture = core.formspec_escape(texture_path.."crafter.png")
--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[]"..
    "bgcolor[#00000000]"..
    "image[1.2,0; 16.68243243243243, 3 ;"..core.formspec_escape(texture).."]"..
    "button[5.5,4.5;5,2;button;singleplayer]"..
    "button[5.5,6.5;5,2;button;multiplayer]"..
    "button[5.5,8.5;5,2;button;options]"..
    "button[5.5,10.5;5,2;button;quit game]"..
    "button[13,10.5;3,2;button;minetest mode]"
)

core.sound_play("button", false)

core.button_handler = function(event)
    if event.button then
        core.sound_play("button", false)
        if event.button == "singleplayer" then
            gamedata = {
                playername     = "oilboi",
                singleplayer   = true,
            }
            core.start()
        elseif event.button == "multiplayer" then
            gamedata = {
                playername     = tostring(math.random(0,100000000)),
                address        = "crafter.minetest.land",
                port           = "30000",
                selected_world = 0, -- 0 for client mode
                singleplayer   = false,
            }
            core.start()
        elseif event.button == "minetest mode" then
            dofile(mainmenu_path .. DIR_DELIM .. "/minetest/init.lua")
        elseif event.button == "quit game" then
            core.close()
        end
    end
end

core.event_handler = function(event)
    if event == "MenuQuit" then
        core.close()
    end
end