local fps = core.settings:get("fps_max")
local fullscreen = core.settings:get("fullscreen")

local function get_frame_rate()
    if fps == "15" then
        return "button[5.5,8.5;5,2;button;FPS: Minecraft Mode]"
    elseif fps == "10000" then
        return "button[5.5,8.5;5,2;button;FPS: Unlimited]"
    else
        return "button[5.5,8.5;5,2;button;FPS: "..fps.."]"
    end
end

--visual settings
--[[
ultra fast
super fast
fast
nice
super nice
ultra nice
amazing
]]--

local function get_fullscreen()
    return "button[5.5,7;5,2;button;Fullscreen: "..fullscreen.."]"
end

--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[0.5,0.5]"..
    "bgcolor[#00000000]"..
    get_fullscreen()..
    get_frame_rate()..
    "button[5.5, 10 ;5,2;button;back]"
)

local fps_choices = {
    15,25,30,50,60,120,144,240,10000
}

function toggle_fps(button)
    button = string.gsub(button, "FPS: ", "")
    if button == "Minecraft Mode" then
        button = 15
    elseif button == "Unlimited" then
        button = 10000
    else
        button = tonumber(button)
    end
    local button_index
    for index,value in pairs(fps_choices) do
        if button == value then
            button_index = index + 1
            if button_index > table.getn(fps_choices) then
                button_index = 1
            end
            break
        end
    end
    if fps_choices[button_index] == nil then
        button_index = 1
    end

    core.settings:set("fps_max",fps_choices[button_index])
    core.settings:set("pause_fps_max",fps_choices[button_index])
end

function toggle_fullscreen(button)
    button = string.gsub(button, "Fullscreen: ", "")
    local screen = core.get_screen_info()
    if button == "true" then
        button = "false"
        core.settings:set("screen_w",screen.display_width/2)
        core.settings:set("screen_h",screen.display_height/2)
    elseif button == "false" then
        core.settings:set("screen_w",screen.display_width)
        core.settings:set("screen_h",screen.display_height)
        button = "true"
    end

    core.settings:set("fullscreen", button)
end

core.button_handler = function(event)
    if event.button then
        core.sound_play("button", false)
        if string.match(event.button,"FPS: ") then
            toggle_fps(event.button)
            dofile(mainmenu_path .. "options.lua")
        elseif string.match(event.button,"Fullscreen: ") then
            toggle_fullscreen(event.button)
            dofile(mainmenu_path .. "options.lua")
        elseif event.button == "back" then
            dofile(mainmenu_path .. "init.lua")
        end
    elseif event.name then
        if string.match(event.name, "CHG") then
            core.sound_play("button", false)
            local last_selected_world = tonumber(string.match(event.name, ":(.*)"))
            core.settings:set("last_selected_world",last_selected_world)
        end
    end    
end

core.event_handler = function(event)
    if event == "MenuQuit" then
        core.settings:set("page","mainmenu")
        core.sound_play("button", false)
        dofile(mainmenu_path .. "init.lua")
    end
end