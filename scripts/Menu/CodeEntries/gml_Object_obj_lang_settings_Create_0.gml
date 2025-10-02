instance_deactivate_all(true)
instance_activate_object(obj_input)
instance_activate_object(obj_gamecontroller)

option = 0

scale = 2
xx_options = 25 * scale
xxoff_heart = 15 * scale
yy_options = 50 * scale
yyoff_options = 25 * scale
xx_mid = 160 * scale

yy_return = (205 + 12) * scale

cur_lang_ind = 0
last_lang = global.lang
for (i = 0; i < array_length(global.langs_names); i++) {
    if (global.langs_names[i] == global.lang) {
        cur_lang_ind = i
        break
    }
}

get_non_downloaded_langs = function() {
    non_downloaded_langs = []
    langs_amount = array_length(global.langs_names)
    for (var i = 0; i < array_length(global.languages_list); i++) {
        var flag = true;
        for (var j = 0; j < array_length(global.langs_names); j++) {
            if (variable_struct_get(global.languages_list[i], "code") == global.langs_names[j]) {
                flag = false;
            }
        }

        if (variable_struct_get(global.languages_list[i], "not_public") == true) {
            flag = false;
        }

        if (flag) {
            array_push(non_downloaded_langs, i)
            langs_amount++
        }
    }
}
get_non_downloaded_langs()

update_strings = function() {
    config_text = stringsetloc("LANGUAGE CONFIG", "obj_lang_settings_1_0")
    return_text = stringsetloc("Return", "obj_lang_settings_2_0")
    yes_text = stringsetloc("Yes", "obj_lang_settings_3_0")
    no_text = stringsetloc("No", "obj_lang_settings_4_0")
    lang_choice_text = stringsetloc("Language", "obj_lang_settings_5_0") + ": "
    spec_mode_text = stringsetloc("Special Mode", "obj_lang_settings_6_0") + ": "
    tr_songs_text = stringsetloc("Translated Songs", "obj_lang_settings_7_0") + ": "
    spec_mode_desc_disabled = stringsetloc("Special Mode disabled\ndescription (leave space\nif no need)", "obj_lang_settings_8_0")
    spec_mode_desc_enabled = stringsetloc("Special Mode enabled\ndescription (leave space\nif no need)", "obj_lang_settings_9_0")
    version_text = stringsetloc("Current version - {0}; Latest available - {1}", "obj_lang_settings_10_0")

    options = ["language"]

    spec_mode_switch = false
    translated_songs_switch = false

    if (get_lang_setting("special_mode")) {
        array_push(options, "special_mode")
        spec_mode_switch = true
    }

    if (get_lang_setting("enable_translated_songs_switch")) {
        array_push(options, "enable_translated_songs_switch")
        translated_songs_switch = true
    }

    options_count = array_length(options)
}

update_strings()

language_downloading = false
language_downloading_call = -1

unzipping = false

loading_error = ""
unzipping_error = ""

lang_file_size = 0
downloaded_size = 0

update_languages = function() {
    var lang_code = variable_struct_get(global.languages_list[non_downloaded_langs[cur_lang_ind - array_length(global.langs_names)]], "code")

    obj_gamecontroller.update_languages()
    change_language(lang_code)
    room_restart()
}