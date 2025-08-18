if (!instance_exists(obj_CHAPTER_SELECT))
    exit;

var update_string = ""

var can_tr_be_loaded = false

if (array_length(loaded_files) > 0 && !loading_new_translation_files) {
    if (loading_error == "") {
        update_string = string(
            scr_get_lang_string("Succesfully updated to version {0}.\nHave a nice play.", "obj_gamecontroller_Draw_73_4_0"), 
            version_to_string(ds_map_find_value(cur_translation_versions, global.lang)),
        ) 
    } else {
        update_string = string(
            scr_get_lang_string("Something went wrong.\nHTTP error - {0}.", "obj_gamecontroller_Draw_73_4_1"), 
            loading_error,
        )
    }
    if (!panel_visible) {
        update_string = ""
    }

}

if (is_version_greater(ds_map_find_value(last_translation_versions, global.lang), ds_map_find_value(cur_translation_versions, global.lang)))
{
    can_tr_be_loaded = true;

    update_string = string(
        scr_get_lang_string("Found new version {0} of translation.\nYour current version is {1}.\nPress [G] to download new version.", "obj_gamecontroller_Draw_73_1_0"), 
        version_to_string(ds_map_find_value(last_translation_versions, global.lang)),
        version_to_string(ds_map_find_value(cur_translation_versions, global.lang)),
    ) + "\n" + (desc_folded ? last_folded_text : last_unfolded_text + ds_map_find_value(translation_versions_descriptions, global.lang));
}

if (is_version_greater(last_dt_version, cur_dt_version))
{
    can_tr_be_loaded = false;

    update_string = string(
        scr_get_lang_string("Found new version {0} of Deltranslate.\nYour current version is {1}.\nIt's advised to install\nnew version via installer.", "obj_gamecontroller_Draw_73_2_0"), 
        version_to_string(last_dt_version),
        version_to_string(cur_dt_version),
    ) + "\n" + (desc_folded ? last_folded_text : last_dt_description);
}


if (update_string != "") {
    draw_set_alpha(_alpha);
    _alpha = lerp(_alpha, instance_exists(obj_screen_transition) ? 0 : 0.6, instance_exists(obj_screen_transition) ? 0.18 : 0.06);
    
    if (!loading_new_translation_files) {
        if (panel_visible)
        {
            update_string += "\n" + string(scr_get_lang_string("To close press: [P]", "obj_gamecontroller_Draw_73_3_0"));
        }
        else
        {
            update_string = "[P]";
        }
    } else {
        var loading_string = scr_get_lang_string("Loading", "obj_gamecontroller_Draw_73_5_0")
        for (var i = 0; i < floor(current_time / (1000 * 1)) % 3 + 1; i++) {
            loading_string += "."
        }

        loading_string += "\n"
        for (var i = 0; i < array_length(loaded_files); i++) {
            loading_string += string(scr_get_lang_string("Loaded {0}", "obj_gamecontroller_Draw_73_6_0"), loaded_files[i]) + "\n"
        }

        update_string = loading_string
    }
    
    var w = 280;
    var h = 160;
    var xdispl = 0;
    var ydispl = 0;

    draw_set_font(scr_get_font("fnt_main"));
    
    if (panel_visible)
    {
        w = max(280, string_width(update_string) + 16);
        // h = 160;
        h = string_height(update_string) + 16
        var w_small = 0;
        var h_small = 0;
    }
    else
    {
        w = 40;
        h = 40;
        var w_small = 0;
        var h_small = 0;
    }
    
    var yy = (240 + 96) - h / 2;
    var xx = ((room_width / 2) - (w / 2)) + 48;
    
    if (panel_visible)
    {
        xdispl = 0;
        ydispl = 0;
    }
    else
    {
        yy = ((room_height / 2) * 1) + 16;
        xdispl = (xx / 4) + (xx / 5);
        ydispl = (yy / 4) + (yy / 5);
    }
    
    xx += xdispl;
    yy += ydispl;
    draw_rectangle_colour(xx, yy, xx + w, yy + h, c_white, c_white, c_white, c_white, false);
    draw_rectangle_colour(xx + 2, yy + 2, (xx + w) - 2, (yy + h) - 2, c_black, c_black, c_black, c_black, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_text(xx + (w / 2), yy + (h / 2), update_string);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);

    if (!loading_new_translation_files) {
        if (keyboard_check_pressed(ord("P")))
            panel_visible = !panel_visible;

        if (keyboard_check_pressed(ord("Q")))
            desc_folded = !desc_folded;

        if (panel_visible && can_tr_be_loaded && keyboard_check_pressed(ord("G"))) {
            loading_new_translation_files = true;
            load_files();
        }
    }
}
