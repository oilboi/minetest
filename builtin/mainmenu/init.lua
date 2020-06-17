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

-- for debugging - remove
core.settings:set("enable_console", "true")

-- enable a better key layout
if not core.settings:get("crafter_keymap_set") then
    core.settings:set("keymap_special1",    "KEY_KEY_R")
    core.settings:set("keymap_inventory",   "KEY_KEY_E")
    core.settings:set("keymap_rangeselect", "KEY_KEY_I")
end


-- make entity selectionboxes invisible
core.settings:set("show_entity_selectionbox", "false")

-- makes the world darker at night
core.settings:set("ambient_occlusion_gamma", "1.4")

-- get the player's name
playername = core.settings:get("name")

local welcomes = {
    "Welcome back!",
    "It's nice seeing you again!",
    "How's it hanging?",
    "Welcome back! Ready to fight some monsters?",
    "Nice seeing you again :)",
    "Didn't get enough last time, huh?",
    "Man this game was empty without you!",
}

local questions = {
    "What do you go by?",
    "What's your name, bud?",
    "Tell me your name! :D",
    "Who's there?",
    "What do they call you?",
    "This is where you put your name!",
    "You're unfamiliar. Who are you?",
    "Name please!"
}
local function generate_random_welcomes()
    math.randomseed( os.time() )
    local name = core.settings:get("name")
    if not name or name == "" then
        return "label[5.5,4.25;"..questions[math.random(1,table.getn(questions))].."]"
    else
        if not name_set then
            return "label[5.5,4.25;"..welcomes[math.random(1,table.getn(welcomes))].."]"
        else
            return "label[5.5,4.25;Your name is now "..playername.."!]"
        end
    end
end

local function get_name()
    local name = core.settings:get("name")
    if not name or name == "" then
        return "Name here!"
    else
        return name
    end
end


local texture = core.formspec_escape(texture_path.."crafter.png")
--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[0.5,0.5]"..
    "bgcolor[#00000000]"..
    "image[1.2,0; 16.68243243243243, 3 ;"..core.formspec_escape(texture).."]"..
    generate_random_welcomes()..
    "field[5.8,4.5;5,2;name;;"..core.formspec_escape(get_name()).."]"..
    "button[5.5,5.5;5,2;button;singleplayer]"..
    "button[5.5,7 ;5,2;button;multiplayer]"..
    "button[5.5,8.5;5,2;button;options]"..
    "button[5.5,10;5,2;button;quit game]"
)

core.button_handler = function(event)
    --print(dump(event))
    if event.button then
        core.sound_play("button", false)
        if event.button == "singleplayer" then
            dofile(mainmenu_path .. "singleplayer.lua")
            --[[
            gamedata = {
                playername     = playername,
                singleplayer   = false,
            }
            core.start()
            ]]--
        elseif event.button == "multiplayer" then
            gamedata = {
                playername     = playername,
                address        = "crafter.minetest.land",
                port           = "30000",
                selected_world = 0, -- 0 for client mode
                singleplayer   = false,
            }
            core.start()
        elseif event.button == "quit game" then
            core.close()
        end
    elseif event.key_enter_field then
        if event.name and event.name ~= "" then
            core.sound_play("button", false)
            core.settings:set("name", event.name)
            playername = event.name
            name_set = true
            dofile(mainmenu_path .. "init.lua")
        end
    end
end

core.event_handler = function(event)
    if event == "MenuQuit" then
        core.close()
    end
end

name_set = false