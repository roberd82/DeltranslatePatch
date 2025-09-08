draw_set_font(scr_get_font("fnt_main"))
draw_set_halign(fa_center)
draw_set_color(c_white)
draw_text_transformed(xx_mid, 10 * scale, config_text, 2 * scale, 2 * scale, 0)
draw_set_halign(fa_left)

for (var i = 0; i < options_count; i++) {
    draw_set_color((option == i ? c_yellow : c_white))

    if (options[i] == "language") {
        draw_text_transformed(xx_options, yy_options + yyoff_options * i, lang_choice_text, scale, scale, 0)
        var xx_off = string_width(lang_choice_text) * scale
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, "< ", scale, scale, 0)
        xx_off += string_width("< ") * scale

        if (option == i) {
            var link = get_lang_setting("link", "")
            if (link != "")
                draw_rectangle_color(xx_options + xx_off, yy_options + 14 * scale, xx_options + xx_off + string_width(get_lang_setting("name")) * scale, yy_options + 14 * scale + 1, c_blue, c_blue, c_blue, c_blue, false)
        }
        
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, get_lang_setting("name"), scale, scale, 0)
        
        xx_off += string_width(get_lang_setting("name")) * scale
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, " >", scale, scale, 0)

        draw_text_transformed(xx_options, yy_options + yyoff_options * i + yyoff_options / 3 * 2, 
            string(scr_get_lang_string("Current version - {0}; Latest available - {1}", "obj_lang_settings_10_0"), 
                obj_gamecontroller.version_to_string(variable_struct_get(obj_gamecontroller.cur_translation_versions, global.lang)),
                obj_gamecontroller.version_to_string(variable_struct_get(obj_gamecontroller.last_translation_versions, global.lang)),
            )
        , scale * 0.5, scale * 0.5, 0)

        if (option == i) {
            var lang_desc = get_lang_setting("description", "")
            draw_set_halign(fa_center)
            draw_set_color(c_gray)
            draw_text_transformed(xx_mid, yy_options + yyoff_options * options_count, lang_desc, scale, scale, 0)
            draw_set_color(c_white)
            draw_set_halign(fa_left)
        }
    } else

    if (options[i] == "language_not_downloaded") {
        var lang_info = global.languages_list[non_downloaded_langs[cur_lang_ind - array_length(global.langs_names)]]
        var lang_name = string(variable_struct_get(lang_info, "name"))
        var lang_desc = string(variable_struct_get(lang_info, "description"))

        draw_text_transformed(xx_options, yy_options + yyoff_options * i, lang_choice_text, scale, scale, 0)
        var xx_off = string_width(lang_choice_text) * scale
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, "< ", scale, scale, 0)
        xx_off += string_width("< ") * scale

        if (option == i) {
            var link = string(get_struct_field(lang_info, "link", ""))
            if (link != "")
                draw_rectangle_color(xx_options + xx_off, yy_options + 14 * scale, xx_options + xx_off + string_width(get_lang_setting("name")) * scale, yy_options + 14 * scale + 1, c_blue, c_blue, c_blue, c_blue, false)
        }
        
        draw_set_font(scr_get_font("fnt_placeholder"))
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, lang_name, scale, scale, 0)
        xx_off += string_width(lang_name) * scale
        
        draw_set_font(scr_get_font("fnt_main"))
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, " >", scale, scale, 0)
        xx_off += string_width(" >") * scale

        draw_set_color(c_gray)
        draw_text_transformed(xx_options + xx_off, yy_options + yyoff_options * i, " (Not downloaded!)", scale, scale, 0)
        draw_set_halign(fa_center)
        draw_set_color(c_gray)
        if (language_downloading) {
            draw_text_transformed(xx_mid, room_height / 2, string("Downloading language pack\n{0}/{1} Mb",
                string(downloaded_size / 1024 / 1024),
                string(lang_file_size / 1024 / 1024)
            ), scale, scale, 0)
        } else
        if (unzipping) {
            draw_text_transformed(xx_mid, room_height / 2, string("Language pack unizpping"), scale, scale, 0)
        } else {
            if (loading_error == "") {
                draw_set_font(scr_get_font("fnt_placeholder"))
                draw_text_transformed(xx_mid, room_height / 2, lang_desc, scale, scale, 0)
                draw_set_font(scr_get_font("fnt_main"))
            } else {
                draw_text_transformed(xx_mid, room_height / 2, string("Something went wrong\nHTTP error - {0}", loading_error), scale, scale, 0)
            }
        }
        draw_set_halign(fa_left)
        draw_set_color(c_white)
    } else

    if (options[i] == "download") {
        draw_set_font(scr_get_font("fnt_placeholder"))
        draw_text_transformed(xx_options, yy_options + yyoff_options * i, "↓ ", scale, scale, 0)
        var xx_offset = string_width("↓ ") * scale
        draw_set_font(scr_get_font("fnt_main"))
        draw_text_transformed(xx_options + xx_offset, yy_options + yyoff_options * i, "Download", scale, scale, 0)
        xx_offset += string_width("Download") * scale
        draw_set_font(scr_get_font("fnt_placeholder"))
        draw_text_transformed(xx_options + xx_offset, yy_options + yyoff_options * i, " ↓", scale, scale, 0)
        draw_set_font(scr_get_font("fnt_main"))
    } else 
        
    if (options[i] == "special_mode") {
        draw_text_transformed(xx_options, yy_options + yyoff_options * i, spec_mode_text, scale, scale, 0)
        draw_text_transformed(xx_options + string_width(spec_mode_text) * scale, yy_options + yyoff_options * i, (global.special_mode ? yes_text : no_text), scale, scale, 0)
        if (option == i) {
            draw_set_halign(fa_center)
            draw_set_color(c_gray)
            draw_text_transformed(xx_mid, yy_options + yyoff_options * options_count, (global.special_mode ? spec_mode_desc_enabled : spec_mode_desc_disabled), scale, scale, 0)
            draw_set_halign(fa_left)
        }
    } else
    
    if (options[i] == "enable_translated_songs_switch") {
        draw_text_transformed(xx_options, yy_options + yyoff_options * i, tr_songs_text, scale, scale, 0)
        draw_text_transformed(xx_options + string_width(tr_songs_text) * scale, yy_options + yyoff_options * i, (global.translated_songs ? yes_text : no_text), scale, scale, 0)
    }
}

draw_set_halign(fa_center)
draw_set_color((option == options_count ? c_yellow : c_white))
draw_text_transformed(xx_mid, yy_return, return_text, scale, scale, 0)
draw_set_halign(fa_left)

if (option < options_count) {
    draw_sprite_ext(spr_heart, 0, xx_options - xxoff_heart, (yy_options + 4 * scale + option * yyoff_options), scale, scale, 0, c_white, 1)
} else {
    draw_sprite_ext(spr_heart, 0, (room_width - string_width(return_text) * 2) / 2 - xxoff_heart, yy_return + 4 * scale, scale, scale, 0, c_white, 1)
}



