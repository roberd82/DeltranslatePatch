function get_lang_setting(argument0, argument1) //gml_Script_get_lang_setting
{
    var ls = variable_struct_get(global.langs_settings, global.lang)
    if (is_undefined(ls))
        return argument1
    return get_struct_field(ls, argument0, argument1)
}

