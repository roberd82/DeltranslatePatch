if (instance_number(obj_gamecontroller) > 1)
{
    instance_destroy();
    exit;
}

is_connecting_controller = 3;
gamepad_active = 0;
gamepad_id = 0;
gamepad_shoulderlb_reassign = 0;
gamepad_type = "";

global.is_console = scr_is_switch_os() || os_type == os_ps4 || os_type == os_ps5;

if (!variable_global_exists("gamepad_type"))
    global.gamepad_type = "N/A";

if (variable_global_exists("lang_map"))
    return;
ossafe_ini_open("true_config.ini")
global.special_mode = ini_read_real("LANG", "special_mode", 0)
global.translated_songs = ini_read_real("LANG", "translated_songs", 1)
ossafe_ini_close()
global.lang_sprites = ds_map_create()
global.lang_sounds = ds_map_create()
global.font_map = ds_map_create()
global.langs_names = []
global.langs_settings = ds_map_create()
lang_changes_calls = ds_map_create()
lang_changes = ds_map_create()
cur_translation_versions = ds_map_create()
last_translation_versions = ds_map_create()
translation_versions_changes_files = ds_map_create()
translation_versions_descriptions = ds_map_create()

string_to_version = function(str) {
    var ver = [0, 0, 0]

    var major_pos = string_pos_ext(".", str, 1)
    var minor_pos = string_pos_ext(".", str, major_pos + 1)
    var patch_pos = string_pos_ext(".", str, minor_pos + 1)
    
    ver[0] = real(string_copy(str,             1,                      major_pos));
    ver[1] = real(string_copy(str, major_pos + 1,          minor_pos - major_pos));
    ver[2] = real(string_copy(str, minor_pos + 1, string_length(str) - minor_pos));

    return ver
}

version_to_string = function(ver) {
    return string(ver[0]) + "." + string(ver[1]) + "." + string(ver[2]);
}

is_version_greater = function(ver1, ver2) {
    return ver1[0] > ver2[0] ||
    (ver1[0] == ver2[0] && ver1[1] > ver2[1]) ||
    (ver1[0] == ver2[0] && ver1[1] == ver2[1] && ver1[2] > ver2[2])
}

update_lang_version = function(lang) {
    var version = string_to_version("0.0.0")
    if (file_exists(working_directory + "lang/" + lang + "/changes.json")) {
        var changes = scr_load_json(working_directory + "lang/" + lang + "/changes.json")
        var versions = ds_map_keys_to_array(changes)

        for (var i = 0; i < array_length(versions); i++) {
            var ver = string_to_version(versions[i])

            if (is_version_greater(ver, version)) {
                version = ver;
            }
        }
    }

    ds_map_set(cur_translation_versions, lang, version);
    ds_map_set(last_translation_versions, lang, version);
}

var i = 0
for (var filename = file_find_first(((working_directory + "lang/") + "*"), 16); filename != ""; filename = file_find_next())
{
    if (file_exists(working_directory + "lang/" + filename + "/settings.json") && file_exists(working_directory + "lang/" + filename + "/strings.json"))
    {
        global.langs_names[i] = filename
        i++
        ds_map_set(global.langs_settings, filename, scr_load_json((((working_directory + "lang/") + filename) + "/settings.json")))
        var url = ds_map_find_value(ds_map_find_value(global.langs_settings, filename), "files_url")

        if (!is_undefined(url)) {
            var call_id = http_get(url + "changes.json")
            ds_map_set(lang_changes_calls, filename, call_id);
        }

        update_lang_version(filename)
    }
}
if (i == 0) {
    global.langs_names = ["en"]
    ds_map_add(global.langs_settings, "en", json_decode("{\"name\": \"English\"}"))
}
file_find_close()
scr_init_localization()

_alpha = 0;

cur_dt_version = [0, 0, 0];
var file = file_text_open_read(working_directory + "version_dt.txt");

if (file != -1)
{
    str = file_text_read_string(file);
    file_text_close(file);

    cur_dt_version = string_to_version(str)
}

last_dt_version = cur_dt_version;
last_folded_text = scr_get_lang_string("List of changes. Press [Q] to expand.\n", "obj_gamecontroller_Create_1_0");
last_unfolded_text = scr_get_lang_string("List of changes. Press [Q] to fold.\n", "obj_gamecontroller_Create_2_0");
last_dt_description = last_unfolded_text;
dt_changes_call = http_get("https://github.com/Lazy-Desman/DeltranslatePatch/releases/download/latest/dt_changes.json");

desc_folded = true;
panel_visible = true;


loading_new_translation_files = false

files_in_upload = ds_map_create()
loaded_files = []
loading_error = ""

load_files = function() {
    files_in_upload = ds_map_create()
    loaded_files = []
    loading_error = ""

    var files = ds_map_find_value(translation_versions_changes_files, global.lang);
    for (var i = 0; i < array_length(files); i++) {
        ds_map_set(files_in_upload, files[i], http_get_file(get_lang_setting("files_url", "") + files[i], "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + files[i]));
    }
    if (!ds_map_exists(files_in_upload, "settings.json")) {
        ds_map_set(files_in_upload, "settings.json", http_get_file(get_lang_setting("files_url", "") + "settings.json", "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + "settings.json"));
    }
    if (!ds_map_exists(files_in_upload, "changes.json")) {
        ds_map_set(files_in_upload, "changes.json", http_get_file(get_lang_setting("files_url", "") + "changes.json", "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + "changes.json"));
    }
}

copy_files_from_tmp = function() {
    for (var i = 0; i < array_length(loaded_files); i++) {
        file_copy(
            "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + loaded_files[i],
            "\\\\?\\" + program_directory + "lang/" + global.lang + "/" + loaded_files[i],
        )

        ds_map_set(global.langs_settings, global.lang, scr_load_json((((working_directory + "lang/") + global.lang) + "/settings.json")))
        update_lang_version(global.lang);

        loading_new_translation_files = false
        scr_init_localization()
    }

    directory_destroy("\\\\?\\" + program_directory + "tmp")
}

clear_tmp = function() {
    directory_destroy("\\\\?\\" + program_directory + "tmp")
}