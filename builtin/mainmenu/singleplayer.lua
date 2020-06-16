local texture = core.formspec_escape(texture_path.."crafter.png")




--dofile(mainmenu_path .."minetest/init.lua")
core.update_formspec(
    "size[16,12]"..
    "position[]"..
    "bgcolor[#00000000]"
    --"image[1.2,0; 16.68243243243243, 3 ;"..core.formspec_escape(texture).."]"..
    --generate_random_welcomes()..
    --"field[5.8,4.5;5,2;name;;"..core.formspec_escape(get_name()).."]"..
    --"button[5.5,5.5;5,2;button;singleplayer]"..
    --"button[5.5,7 ;5,2;button;multiplayer]"..
    --"button[5.5,8.5;5,2;button;options]"..
    --"button[5.5,10;5,2;button;quit game]"
)