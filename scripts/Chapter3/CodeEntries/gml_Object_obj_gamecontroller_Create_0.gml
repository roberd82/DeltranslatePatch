if (instance_number(obj_gamecontroller) > 1)
{
    instance_destroy();
    exit;
}

global.lang_folder = working_directory + "../lang/"
if (os_type == os_android) {
    global.lang_folder = working_directory + "lang/"
    global.savepath = (os_type == os_android) ? get_external_files_dir() : "";
}

global.is_console = scr_is_switch_os() || os_type == os_ps4 || os_type == os_ps5;
var launch_data = scr_init_launch_parameters();
global.launcher = launch_data.is_launcher;
is_connecting_controller = 3;
gamepad_active = 0;
gamepad_id = 0;
gamepad_shoulderlb_reassign = 0;
gamepad_type = "";
_load_enabled = false;

if (!variable_global_exists("gamepad_type"))
    global.gamepad_type = "N/A";

enable_loading = function()
{
    _load_enabled = true;
};


ossafe_ini_open("true_config.ini");
global.translator_mode = 0;
speed_mode = 0;
global.special_mode = ini_read_real("LANG", "special_mode", 0);
global.translated_songs = ini_read_real("LANG", "translated_songs", 1);
ossafe_ini_close();
global.lang_sprites = ds_map_create();
global.lang_sounds = ds_map_create();
global.lang_fonts = ds_map_create();
global.langs_names = [];
global.langs_settings = {};

global.used_strings = ds_map_create()
global.changed_strings = ds_map_create()

if (file_exists(global.lang_folder + "langs_list.json")) {
    global.langs_names = scr_load_json(global.lang_folder + "langs_list.json")
}

var i = 0;
var filename = file_find_first(global.lang_folder + "*", 16);
while (filename != "")
{
    if (file_exists(global.lang_folder + filename + "/settings.json"))
    {
        if (!array_includes(filename)) {
            global.langs_names[i] = filename;
            i++;
        }
    }
    
    filename = file_find_next();
}

for (var g = 0; g < array_length(global.langs_names); g++) {
    variable_struct_set(global.langs_settings, global.langs_names[g], scr_load_json(global.lang_folder + global.langs_names[g] + "/settings.json"));
}

if (array_length(global.langs_names) == 0)
{
    global.langs_names = ["en"];
    variable_struct_set(global.langs_settings, "en", json_parse("{\"name\": \"English\"}"));
}

file_find_close();
scr_init_localization();



