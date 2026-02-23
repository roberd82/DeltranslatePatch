function snd_init(arg0)
{
    var dir = "mus/";
    
    if (global.launcher)
    {
        if (os_type == os_android)
            dir = global.savepath + "mus/";
        else
            dir = working_directory + "../mus/";
    }
    
    if (os_type == os_android)
        dir = global.savepath + "mus/";
    else
        dir = working_directory + "../mus/";
    
    initsongvar = dir + arg0;
    var flag = true;
    
    for (var i = 0; i < array_length(global.songs_list); i++)
    {
        if (global.songs_list[i] == arg0 || (global.songs_list[i] + ".ogg") == arg0)
        {
            flag = false;
            break;
        }
    }
    
    if (global.translated_songs || flag)
    {
        var lang_path = get_lang_folder_path() + "chapter1/sounds/";
        
        if (file_exists(lang_path + arg0))
            initsongvar = lang_path + arg0;
        
        if (global.special_mode && file_exists(lang_path + "sp_" + arg0))
            initsongvar = lang_path + "sp_" + arg0;
    }
    
    _mystream = audio_create_stream(initsongvar);
    _astream = instance_create(0, 0, obj_astream);
    _astream.mystream = _mystream;
    _astream.songname = arg0;
    return _mystream;
}
