function scr_draw_screen_border(arg0)
{
    var border_id = arg0;
    draw_enable_alphablend(false);
    /* Wide added in CodeChanges.txt */
    if (border_id == "Dynamic" || border_id == "ダイナミック")
    {
        if (!loaded)
        {
            obj_time.border_alpha = 0;
            loaded = true;
        }
        obj_time.border_fade_value = 0.025;
        var room_id = room;
        var _border_image = global.darkzone ? border_dark : border_light;
        if (room_id == room_legend || room_id == 321 || room_id == PLACE_MENU || room_id == PLACE_LOGO)
            _border_image = border_dark;
        if (asset_get_index("border_dw_field") != -1 && asset_get_index("border_dw_forest") != -1)
        {
            if ((room_id >= room_field_forest && room_id < room_forest_savepoint1) || room_id == room_shop1 || (room_id == room_field_start && global.flag[209] == 1))
                _border_image = border_dw_field;
            if ((room_id >= room_forest_savepoint1 && room_id < room_cc_prison_cells) || room_id == room_man)
                _border_image = border_dw_forest;
            if ((room_id >= room_cc_prison_cells && room_id < PLACE_DOG) || room_id == room_shop2)
                _border_image = bg_border_line_1080;
        }
        
        if (room_id == PLACE_CONTACT || room_id == 317 || room_id == PLACE_MENU || room_id == room_splashscreen || room_id == room_gameover || room_id == PLACE_DOG || room_id == room_dark1a || room_id == room_dark_eyepuzzle)
            obj_time.border_alpha = 0;
        else if (room_id == room_insidecloset || room_id == room_cc_fountain || (asset_get_index("border_dw_field") != -1 && room_id == room_field_start && global.flag[209] == 0))
            obj_time.border_fade_out = obj_time.border_alpha > 0;
        else if (room_id == room_town_krisyard || room_id == room_castle_town || room_id == room_town_school
            || room_id == room_field1
            || room_id == room_field3
            || room_id == room_forest_savepoint1
            || room_id == room_forest_savepoint2
            || room_id == room_forest_fightsusie
            || room_id == room_forest_castlefront
            || room_id == room_cc_entrance
            || room_id == room_cc_prison_cells)
            obj_time.border_fade_in = obj_time.border_alpha < 1;
        else if (instance_exists(obj_savepoint))
            obj_time.border_alpha = 1;
        if (room_id == room_school_unusedroom)
        {
            if (instance_exists(obj_unusedclassevent))
            {
                if (obj_unusedclassevent.lightsoff == 0)
                    obj_time.border_fade_in = obj_time.border_alpha < 1;
                else
                    obj_time.border_alpha = 0;
            }
        }
        if (room_id == room_krisroom)
        {
            if (instance_exists(obj_krisroom))
            {
                if (obj_krisroom.con >= 50)
                    obj_time.border_fade_out = obj_time.border_alpha > 0;
                else
                    obj_time.border_alpha = (global.plot <= 10) ? 0 : 1;
            }
        }
        if (room_id == PLACE_FAILURE)
        {
            if (instance_exists(DEVICE_FAILURE))
            {
                if (DEVICE_FAILURE.EVENT >= 27 && !instance_exists(obj_writer))
                    obj_time.border_alpha = 0;
            }
        }
        var game_won = false;
        if (ossafe_file_exists("filech1_3"))
            game_won = true;
        if (ossafe_file_exists("filech1_4"))
            game_won = true;
        if (ossafe_file_exists("filech1_5"))
            game_won = true;
        if ((room_id == room_legend || room_id == 321 || room_id == PLACE_MENU) && game_won == true)
        {
            _border_image = border_dark;
            obj_time.border_alpha = 1;
        }
        scr_draw_background_ps4(_border_image, 0, 0);
        global.disable_border = obj_time.border_alpha != 1;
    }
    else if (border_id == "Simple" || border_id == "シンプル")
    {
        var room_id = room;
        if (instance_exists(obj_savepoint))
            obj_time.border_alpha = 1;
        if (room_id == room_ed)
        {
            if (instance_exists(obj_credits))
            {
                if (obj_credits.timer >= 1560)
                {
                    obj_time.border_fade_value = 0.01;
                    obj_time.border_fade_out = obj_time.border_alpha > 0;
                }
            }
        }
        scr_draw_background_ps4(bg_border_line_1080, 0, 0);
        global.disable_border = obj_time.border_alpha != 1;
    }
    draw_set_alpha(1);
    draw_enable_alphablend(true);
}
