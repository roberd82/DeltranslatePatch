function change_language(argument0) //gml_Script_change_language
{
    var target_lang = argument0;
    global.lang = target_lang
    scr_init_localization()
    ossafe_ini_open("true_config.ini")
    ini_write_string("LANG", "LANG_DT", global.lang)
    ossafe_ini_close()
    ossafe_savedata_save()
}

