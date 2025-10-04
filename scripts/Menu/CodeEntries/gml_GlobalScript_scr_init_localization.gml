var flag, i, spr_arr, snd_arr;
function scr_init_localization() //gml_Script_scr_init_localization
{
    if (!variable_global_exists("lang_loaded")) {
        global.lang_loaded = "";
        global.loaded_sprites = [];
        global.loaded_sounds = [];
        global.loaded_fonts = [];
        global.chemg_sprite_map = ds_map_create();
    }
    if (global.lang_loaded != global.lang)
    {
	    global.lang_loaded = global.lang
        ds_map_destroy(global.font_map)
        ds_map_destroy(global.lang_sprites)
        ds_map_destroy(global.lang_sounds)
        ds_map_destroy(global.chemg_sprite_map)
        global.font_map = ds_map_create()
        global.lang_sprites = ds_map_create()
        global.lang_sounds = ds_map_create()
        global.chemg_sprite_map = ds_map_create();
        var fonts_arr = [["fnt_main", 12], ["fnt_mainbig", 24]]
        font_add_enable_aa(false)
        for (i = 0; i < array_length(fonts_arr); i++) {
            add_font(fonts_arr[i][0], fonts_arr[i][1])
        }

        ds_map_add(global.font_map, "fnt_placeholder", font_add("Calibri", 10, 1, 0, 32, 70000))

        global.lang_map = ds_map_create()
        scr_lang_load()
    }
}

