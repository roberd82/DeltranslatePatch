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

global.lang_folder = working_directory + "lang/"

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
global.langs_settings = {}
global.languages_list = []
lang_changes_calls = {}
lang_changes = {}
cur_translation_versions = {}
last_translation_versions = {}
translation_versions_changes_files = {}
translation_versions_descriptions = {}

is_valid_version = function(str) {
    if (is_undefined(str))
        str = "";

    var major_pos = string_pos_ext(".", str, 1)
    var minor_pos = string_pos_ext(".", str, major_pos + 1)
    
    return major_pos != 0 && minor_pos != 0
}

string_to_version = function(str) {
    if (is_undefined(str))
        str = "0.0.0";

    try {
        var ver = [0, 0, 0]

        var major_pos = string_pos_ext(".", str, 1)
        var minor_pos = string_pos_ext(".", str, major_pos + 1)
        
        ver[0] = real(string_copy(str,             1,                      major_pos));
        ver[1] = real(string_copy(str, major_pos + 1,          minor_pos - major_pos));
        ver[2] = real(string_copy(str, minor_pos + 1, string_length(str) - minor_pos));
    } catch (err) {
        return [-1, -1, -1]
    }

    return ver
}

version_to_string = function(ver) {
    if (is_undefined(ver))
        ver = [0, 0, 0];

    return string(ver[0]) + "." + string(ver[1]) + "." + string(ver[2]);
}

is_version_greater = function(ver1, ver2) {
    if (is_undefined(ver1))
        ver1 = [0, 0, 0];
    if (is_undefined(ver2))
        ver2 = [0, 0, 0];

    return ver1[0] > ver2[0] ||
    (ver1[0] == ver2[0] && ver1[1] > ver2[1]) ||
    (ver1[0] == ver2[0] && ver1[1] == ver2[1] && ver1[2] > ver2[2])
}

update_lang_version = function(lang) {
    var version = string_to_version("0.0.0")
    if (file_exists(global.lang_folder + lang + "/changes.json")) {
        var changes = scr_load_json(global.lang_folder + lang + "/changes.json")
        var versions = variable_struct_get_names(changes)

        for (var i = 0; i < array_length(versions); i++) {
            var ver = string_to_version(versions[i])

            if (is_version_greater(ver, version)) {
                version = ver;
            }
        }
    }

    variable_struct_set(cur_translation_versions, lang, version);
    variable_struct_set(last_translation_versions, lang, version);
}

update_languages = function() {
    global.langs_names = []

    if (file_exists(global.lang_folder + "langs_list.json")) {
        global.langs_names = scr_load_json(global.lang_folder + "langs_list.json")
    }

    global.langs_settings = {}

    var i = 0
    for (var filename = file_find_first(((global.lang_folder) + "*"), 16); filename != ""; filename = file_find_next())
    {
        if (file_exists(global.lang_folder + filename + "/settings.json") && file_exists(global.lang_folder + filename + "/strings.json"))
        {
            global.langs_names[i] = filename
            i++
        }    
    }

    for (var g = 0; g < array_length(global.langs_names); g++) {
        variable_struct_set(global.langs_settings, global.langs_names[g], scr_load_json(global.lang_folder + global.langs_names[g] + "/settings.json"));
        update_lang_version(global.langs_names[g])
    }



    if (array_length(global.langs_names) == 0) {
        global.langs_names = ["en"]
        variable_struct_set(global.langs_settings, "en", json_parse("{\"name\": \"English\"}"))
    }
    variable_struct_set(global.langs_settings, "pseudo_en", json_parse("{\"name\": \"Pseudo english\"}"))
}

update_languages()

for (var i = 0; i < array_length(global.langs_names); i++) {
    var filename = global.langs_names[i]
    var url = variable_struct_get(variable_struct_get(global.langs_settings, filename), "files_url")

    if (!is_undefined(url)) {
        var call_id = http_get(url + "changes.json")
        variable_struct_set(lang_changes_calls, filename, call_id);
    }
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
last_dt_description = "";
dt_changes_call = http_get("https://github.com/Lazy-Desman/DeltranslatePatch/releases/download/latest/dt_changes.json");

desc_folded = true;
panel_visible = true;


loading_new_translation_files = false

files_in_upload = {}
loaded_files = []
loading_error = ""

load_files = function() {
    files_in_upload = {}
    loaded_files = []
    loading_error = ""

    var files = variable_struct_get(translation_versions_changes_files, global.lang);
    for (var i = 0; i < array_length(files); i++) {
        var file = string_replace_all(files[i], "..", "")
        variable_struct_set(files_in_upload, file, http_get_file(get_lang_setting("files_url", "") + files[i], "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + file));
    }
    if (!variable_struct_exists(files_in_upload, "settings.json")) {
        variable_struct_set(files_in_upload, "settings.json", http_get_file(get_lang_setting("files_url", "") + "settings.json", "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + "settings.json"));
    }
    if (!variable_struct_exists(files_in_upload, "changes.json")) {
        variable_struct_set(files_in_upload, "changes.json", http_get_file(get_lang_setting("files_url", "") + "changes.json", "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + "changes.json"));
    }
}

copy_files_from_tmp = function() {
    for (var i = 0; i < array_length(loaded_files); i++) {
        file_copy(
            "\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + loaded_files[i],
            "\\\\?\\" + program_directory + "lang/" + global.lang + "/" + loaded_files[i],
        )

        variable_struct_set(global.langs_settings, global.lang, scr_load_json((((global.lang_folder) + global.lang) + "/settings.json")))
        update_lang_version(global.lang);

        loading_new_translation_files = false
        scr_init_localization()
    }

    directory_destroy("\\\\?\\" + program_directory + "tmp")
}

clear_tmp = function() {
    directory_destroy("\\\\?\\" + program_directory + "tmp")
}

update_last_dt_description = function(lang) {
    if (is_undefined(dt_changes)) {
        last_dt_description = "";
        return;
    }

    var text = scr_get_lang_string("List of changes. Press [Q] to fold.\n", "obj_gamecontroller_Create_2_0");
    var versions = variable_struct_get_names(dt_changes);

    for (var i = 0; i < array_length(versions); i++) {
        var str = versions[i];
        if (!is_valid_version(str)) continue;

        var ver = string_to_version(str);

        if (is_version_greater(ver, cur_dt_version)) {
            var entry = variable_struct_get(dt_changes, str);

            var name = variable_struct_get(entry, "name_" + lang);
            var desc = variable_struct_get(entry, "description_" + lang);

            if (is_undefined(name)) name = variable_struct_get(entry, "name");
            if (is_undefined(desc)) desc = variable_struct_get(entry, "description");

            text += string("{0}{1}:\n{2}\n",
                str,
                (is_undefined(name) ? "" : string(" ({0})", name)),
                (is_undefined(desc) ? "" : desc)
            );
        }

        if (is_version_greater(ver, last_dt_version)) {
            last_dt_version[0] = ver[0];
            last_dt_version[1] = ver[1];
            last_dt_version[2] = ver[2];
        }
    }

    last_dt_description = text;
};

languages_list_call = -1
// Закомментить чтобы убрать подкачку языков
languages_list_call = http_get("https://raw.githubusercontent.com/Lazy-Desman/DeltranslatePatch/refs/heads/main/languages_list.json");

languages_list_calls = []