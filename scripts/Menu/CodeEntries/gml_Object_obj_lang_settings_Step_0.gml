if (keyboard_check_released(ord("R"))) {
    room_restart()
}

if (down_p()) {
    option = (option + 1) % (options_count + 1)
    audio_play_sound(snd_menumove, 50, 0)
}

if (up_p()) {
    option = (option + options_count) % (options_count + 1)
    audio_play_sound(snd_menumove, 50, 0)
}

if (!language_downloading) {
    if (option < options_count) {
        if (options[option] == "language" || options[option] == "language_not_downloaded") {
            if (right_p() || left_p()) {
                audio_play_sound(snd_menumove, 50, 0)

                cur_lang_ind = (cur_lang_ind + (right_p() - left_p()) + langs_amount) % langs_amount;
                if (cur_lang_ind < array_length(global.langs_names)) {
                    change_language(global.langs_names[cur_lang_ind])
                    last_lang = global.lang

                    update_strings()
                    options_count = array_length(options)
                } else {
                    change_language("pseudo_en")

                    update_strings()
                    options = ["language_not_downloaded", "download"]
                    options_count = array_length(options)
                }
            }
            if (button1_p()) {
                if (cur_lang_ind < array_length(global.langs_names)) {
                    var link = get_lang_setting("link", "")
                    if (link != "") {
                        audio_play_sound(snd_menumove, 50, 0)
                        url_open(link)
                    }
                }
            }
        } else

        if (options[option] == "special_mode") {
            if (left_p() || right_p() || button1_p()) {
                ossafe_ini_open("true_config.ini")
                global.special_mode = !global.special_mode
                ini_write_string("LANG", "special_mode", global.special_mode)
                ossafe_ini_close()
                ossafe_savedata_save()

                audio_play_sound(snd_menumove, 50, 0)
            }
        } else

        if (options[option] == "enable_translated_songs_switch") {
            if (left_p() || right_p() || button1_p()) {
                ossafe_ini_open("true_config.ini")
                global.translated_songs = !global.translated_songs
                ini_write_string("LANG", "translated_songs", global.translated_songs)
                ossafe_ini_close()
                ossafe_savedata_save()

                audio_play_sound(snd_menumove, 50, 0)
            }
        } else

        if (options[option] == "download") {
            if (button1_p()) {
                audio_play_sound(snd_menumove, 50, 0)
                
                language_downloading = true
                loading_error = ""
                unzipping_error = ""
                var url =  variable_struct_get(global.languages_list[non_downloaded_langs[cur_lang_ind - array_length(global.langs_names)]], "download_url")

                language_downloading_call = http_get_file(url, "\\\\?\\" + program_directory + "tmp/lang.zip")
            }
        }
    } else

    if (option == options_count && button1_p()) {
        audio_play_sound(snd_menumove, 50, 0)
        change_language(last_lang)
        room_restart()
    }
} else {
    if (button1_p()) {
        audio_play_sound(snd_swing, 50, 0)
    }
}