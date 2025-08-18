draw_set_color(c_gray);
draw_set_alpha(_alpha);
draw_set_font(_font);

if (_copyright_enabled)
    draw_text_transformed(x + 16, y + 16, _copyright_text, _scale, _scale, 0);

draw_text_transformed(x + 16, y + 32, _version_text, _scale, _scale, 0);
draw_text_transformed(x + 16, y + 48, 
    string(scr_get_lang_string("Deltranslate version - {0}", "gml_Object_obj_ui_version_Draw_0_1"),
        obj_gamecontroller.version_to_string(obj_gamecontroller.cur_dt_version)
    ), 
_scale, _scale, 0);
draw_set_color(c_white);
draw_set_alpha(1);
