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

        if (flag) {
            array_push(non_downloaded_langs, i)
            langs_amount++
        }
    }

    non_downloaded_langs = []
    langs_amount = array_length(global.langs_names)
}
get_non_downloaded_langs()

update_strings = function() {
    config_text = scr_get_lang_string("LANGUAGE CONFIG", "obj_lang_settings_1_0")
    return_text = scr_get_lang_string("Return", "obj_lang_settings_2_0")
    yes_text = scr_get_lang_string("Yes", "obj_lang_settings_3_0")
    no_text = scr_get_lang_string("No", "obj_lang_settings_4_0")
    lang_choice_text = scr_get_lang_string("Language", "obj_lang_settings_5_0") + ": "
    spec_mode_text = scr_get_lang_string("Special Mode", "obj_lang_settings_6_0") + ": "
    tr_songs_text = scr_get_lang_string("Translated Songs", "obj_lang_settings_7_0") + ": "
    spec_mode_desc_disabled = scr_get_lang_string("Special Mode disabled\ndescription (leave space\nif no need)", "obj_lang_settings_8_0")
    spec_mode_desc_enabled = scr_get_lang_string("Special Mode enabled\ndescription (leave space\nif no need)", "obj_lang_settings_9_0")
    
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