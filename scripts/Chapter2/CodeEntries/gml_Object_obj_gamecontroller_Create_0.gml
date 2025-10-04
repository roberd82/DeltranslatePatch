if (instance_number(obj_gamecontroller) > 1)
{
    instance_destroy();
    exit;
}

global.lang_folder = working_directory + "../lang/"

global.lang = "en"
global.orig_en = false

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
global.lang_settings = {};

global.used_strings = ds_map_create()
global.changed_strings = ds_map_create()
global.lang_to_orig = ds_map_create()
global.orig_to_lang = ds_map_create()

if (file_exists(global.lang_folder + "settings.json")) {
    var settings = scr_load_json(global.lang_folder + "settings.json")

    var lang_code = variable_struct_get(settings, "lang_code")
    if (is_undefined(lang_code))
        lang_code = "en"

    global.lang = lang_code
    global.lang_settings = settings
} else {
    global.lang_settings = json_parse("{\"name\": \"English\"}");
}

file_find_close();
scr_init_localization();

update_on_room_end = false