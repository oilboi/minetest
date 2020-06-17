local texture = core.formspec_escape(texture_path.."crafter.png")
worlds = core.get_worlds()
world_list = {}

crafter_index = nil

for index,data in pairs(core.get_games()) do
    if data and data.id and string.match(string.lower(data.id), "crafter") then
        crafter_index = index
        break
    end
end


local get_selection_list = function()
    local list = "textlist[5.5,3.5;4.79,5.5;name;"
    local count = 0
    for _,data in pairs(worlds) do
        if string.lower(data.gameid) == "crafter" then
            list = list.. data.name..","
            count = count + 1
        end
    end
    local selection = core.settings:get("last_selected_world") or 0
    selection = tonumber(selection)
    if selection and selection > count then
        selection = count
    end
    core.settings:set("last_selected_world",count)
    if selection and selection == 0 then
        selection = ""
    end
    list = list:sub(1, -2) .. ";"..selection.."]"
    return list
end


--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[0.5,0.5]"..
    get_selection_list()..
    "field[5.8,0.4;5,2;world_name;name;]"..
    "field[5.8,1.5;5,2;world_seed;seed;]"..
    "button[5.5, 2.1 ;5,2;button;create new world]"..
    --"bgcolor[#00000000]"..
    --"image[1.2,0; 16.68243243243243, 3 ;"..core.formspec_escape(texture).."]"..
    --generate_random_welcomes()..
    --"field[5.8 ,4.5;5,2;name;;"..core.formspec_escape(get_name()).."]"..
    --"button[5.5,5.5;5,2;button;singleplayer]"..
    --"button[5.5,7  ;5,2;button;multiplayer]"..
    "button[5.5, 8.75;2,2;button;delete]"..
    "button[8.51,8.75;2,2;button;play]"..
    "button[5.5, 10 ;5,2;button;back]"
)


local function set_world_seed(name,seed)
    for _,data in pairs(core.get_worlds()) do
        if data.name == name then
            local path = data.path .. "/map_meta.txt"
            local map_meta = ""
            local string_found = false
            for line in io.lines(path) do
                if string_found == false and string.match(line,"seed") then
                    map_meta = map_meta .. "seed = "..seed.."\n"
                    string_found = true
                else
                    map_meta = map_meta .. line.."\n"
                end
            end
            
            local f = io.open(path,"w")
            f:write(map_meta)
            f:close()
            break
        end
    end
end


core.button_handler = function(event)
    if event.button then
        core.sound_play("button", false)
        if event.button == "singleplayer" then
            --[[
            gamedata = {
                playername     = playername,
                singleplayer   = false,
            }
            core.start()
            ]]--
        elseif event.button == "create new world" then
            if event.world_name then
                local seed
                if event.world_seed then
                    seed = event.world_seed
                else
                    seed = math.random(0,9999999999999999)
                end
                core.create_world(event.world_name,crafter_index)
                set_world_seed(event.world_name,seed)

                dofile(mainmenu_path .. "singleplayer.lua")
            end
        elseif event.button == "delete" then
            local selected = core.settings:get("last_selected_world")
            if selected then
                core.delete_world(selected)
                dofile(mainmenu_path .. "singleplayer.lua")
            end
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
        core.sound_play("button", false)
        dofile(mainmenu_path .. "init.lua")
    end
end