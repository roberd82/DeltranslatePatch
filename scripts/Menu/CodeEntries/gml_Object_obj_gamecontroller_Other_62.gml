if (ds_map_find_value(async_load, "id") == dt_changes_call)
{
    if (ds_map_find_value(async_load, "status") == 0) {
        dt_changes = json_parse(ds_map_find_value(async_load, "result"));
        update_last_dt_description(global.lang);
    }
}

var langs_loading = variable_struct_get_names(lang_changes_calls);

for (var ind = 0; ind < array_length(langs_loading); ind++)
{
    if (ds_map_find_value(async_load, "id") == variable_struct_get(lang_changes_calls, langs_loading[ind]))
    {
        if (ds_map_find_value(async_load, "status") == 0)
        {
            var lang_change;

            try
            {
                lang_change = json_parse(ds_map_find_value(async_load, "result"));
            }
            catch (err)
            {
                break;
            }

            if (__yy_continueEx0)
            {
            }
            else
            {
                if (__yy_breakEx0)
                    break;

                variable_struct_set(lang_changes, langs_loading[ind], lang_change);
                var versions = variable_struct_get_names(lang_change);
                var lang_change_desc = "";
                var cur_version = variable_struct_get(cur_translation_versions, langs_loading[ind]);
                var last_version = variable_struct_get(last_translation_versions, langs_loading[ind]);
                var files_mp = {};

                for (var i = 0; i < array_length(versions); i++)
                {
                    var str = versions[i];

                    if (!is_valid_version(str))
                        continue;

                    var ver = string_to_version(str);

                    if (is_version_greater(ver, cur_version))
                    {
                        var name = variable_struct_get(variable_struct_get(lang_change, str), "name");
                        var desc = variable_struct_get(variable_struct_get(lang_change, str), "description");
                        lang_change_desc += string("{0}{1}:\n{2}\n", str, is_undefined(name) ? "" : string(" ({0})", name), is_undefined(desc) ? "" : desc);
                        var files_list = variable_struct_get(variable_struct_get(lang_change, str), "files");

                        if (!is_undefined(files_list))
                        {
                            for (var ii = 0; ii < array_length(files_list); ii++)
                                variable_struct_set(files_mp, files_list[ii]);
                        }
                    }

                    if (is_version_greater(ver, last_version))
                    {
                        last_version[0] = ver[0];
                        last_version[1] = ver[1];
                        last_version[2] = ver[2];
                    }
                }

                variable_struct_set(translation_versions_descriptions, langs_loading[ind], lang_change_desc);
                variable_struct_set(last_translation_versions, langs_loading[ind], last_version);
                variable_struct_set(translation_versions_changes_files, langs_loading[ind], variable_struct_get_names(files_mp));
            }
        }
    }
}

var filenames = variable_struct_get_names(files_in_upload);

for (var ind = 0; ind < array_length(filenames); ind++)
{
    if (ds_map_find_value(async_load, "id") == variable_struct_get(files_in_upload, filenames[ind]))
    {
        if (ds_map_find_value(async_load, "status") == 0)
        {
            var file_buffer = buffer_load("\\\\?\\" + program_directory + "tmp/" + global.lang + "/" + filenames[ind]);

            if (buffer_get_size(file_buffer) == 0)
            {
                loading_error = "408";
                loading_new_translation_files = false;
            }

            if (loading_error == "")
            {
                array_push(loaded_files, filenames[ind]);

                if (array_length(loaded_files) == array_length(filenames))
                    copy_files_from_tmp();
            }
            else
            {
                clear_tmp();
            }
        }
        else if (ds_map_find_value(async_load, "status") < 0)
        {
            loading_error = string(ds_map_find_value(async_load, "http_status"));
            loading_new_translation_files = false;
            clear_tmp();
        }
    }
}

if (ds_map_find_value(async_load, "id") == languages_list_call)
{
    if (ds_map_find_value(async_load, "status") == 0)
    {
        var languages_list_res = json_parse(ds_map_find_value(async_load, "result"));
        var languages_list = variable_struct_get(languages_list_res, "languages");
        global.languages_list = [];
        languages_list_calls = [];

        for (var i = 0; i < array_length(languages_list); i++)
        {
            var lang_info = languages_list[i];
            array_push(global.languages_list, lang_info);
            var url = variable_struct_get(lang_info, "info_url");

            if (!is_undefined(url))
            {
                var call_id = http_get(url);
                array_push(languages_list_calls, call_id);
            }
            else
            {
                array_push(languages_list_calls, -1);
            }
        }

        if (instance_exists(obj_lang_settings))
            obj_lang_settings.get_non_downloaded_langs();
    }
}

for (var ind = 0; ind < array_length(languages_list_calls); ind++)
{
    if (ds_map_find_value(async_load, "id") == languages_list_calls[ind])
    {
        if (ds_map_find_value(async_load, "status") == 0)
        {
            var lang_info;

            try
            {
                lang_info = json_parse(ds_map_find_value(async_load, "result"));
            }
            catch (err)
            {
                break;
            }

            if (__yy_continueEx1)
            {
            }
            else
            {
                if (__yy_breakEx1)
                    break;

                var name = variable_struct_get(lang_info, "name");
                var description = variable_struct_get(lang_info, "description");
                var download_url = variable_struct_get(lang_info, "download_url");

                if (!is_undefined(name))
                    variable_struct_set(global.languages_list[ind], "name", name);

                if (!is_undefined(description))
                    variable_struct_set(global.languages_list[ind], "description", description);

                if (!is_undefined(download_url))
                    variable_struct_set(global.languages_list[ind], "download_url", download_url);
            }
        }
    }
}
