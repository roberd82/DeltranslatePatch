if (ds_map_find_value(async_load, "id") == dt_changes_call)
{
    if (ds_map_find_value(async_load, "status") == 0) {
        dt_changes = json_decode(ds_map_find_value(async_load, "result"));
        var versions = ds_map_keys_to_array(dt_changes)
        for (var i = 0; i < array_length(versions); i++) {
            var str = versions[i]
            var ver = string_to_version(str)

            if (is_version_greater(ver, cur_dt_version)) {
                var name = ds_map_find_value(ds_map_find_value(dt_changes, str), "name_" + global.lang)
                var desc = ds_map_find_value(ds_map_find_value(dt_changes, str), "description_" + global.lang)
                if (is_undefined(name))
                    name = ds_map_find_value(ds_map_find_value(dt_changes, str), "name")
                if (is_undefined(desc))
                    desc = ds_map_find_value(ds_map_find_value(dt_changes, str), "description")
                    
                last_dt_description += string("{0}{1}:\n{2}\n", 
                    str, 
                    (is_undefined(name) ? "" : string(" ({0})", name)), 
                    (is_undefined(desc) ? "" : desc)
                );
            }

            if (is_version_greater(ver, last_dt_version)) {
                last_dt_version[0] = ver[0]
                last_dt_version[1] = ver[1]
                last_dt_version[2] = ver[2]
            }
        }
    }
}

var langs_loading = ds_map_keys_to_array(lang_changes_calls);
for (var ind = 0; ind < array_length(langs_loading); ind++) {
    if (ds_map_find_value(async_load, "id") == ds_map_find_value(lang_changes_calls, langs_loading[ind]))
    {
        if (ds_map_find_value(async_load, "status") == 0) {
            var lang_change = json_decode(ds_map_find_value(async_load, "result"));
            ds_map_set(lang_changes, langs_loading[ind], lang_change)

            var versions = ds_map_keys_to_array(lang_change)
            var lang_change_desc = ""
            var cur_version = ds_map_find_value(cur_translation_versions, langs_loading[ind])
            var last_version = ds_map_find_value(last_translation_versions, langs_loading[ind])
            var files_mp = ds_map_create()

            for (var i = 0; i < array_length(versions); i++) {
                var str = versions[i]
                var ver = string_to_version(str)

                if (is_version_greater(ver, cur_version)) {
                    var name = ds_map_find_value(ds_map_find_value(lang_change, str), "name")
                    var desc = ds_map_find_value(ds_map_find_value(lang_change, str), "description")
                        
                    lang_change_desc += string("{0}{1}:\n{2}\n", 
                        str, 
                        (is_undefined(name) ? "" : string(" ({0})", name)), 
                        (is_undefined(desc) ? "" : desc)
                    );

                    var files_list = ds_map_find_value(ds_map_find_value(lang_change, str), "files")
                    if (!is_undefined(files_list)) {
                        for (var ii = 0; ii < ds_list_size(files_list); ii++) {
                            ds_map_set(files_mp, ds_list_find_value(files_list, ii))
                        }
                    }
                }

                if (is_version_greater(ver, last_version)) {
                    last_version[0] = ver[0]
                    last_version[1] = ver[1]
                    last_version[2] = ver[2]
                }
            }

            ds_map_set(translation_versions_descriptions, langs_loading[ind], lang_change_desc);
            ds_map_set(last_translation_versions, langs_loading[ind], last_version);
            ds_map_set(translation_versions_changes_files, langs_loading[ind], ds_map_keys_to_array(files_mp));
        }
    }
}

var filenames = ds_map_keys_to_array(files_in_upload);
for (var ind = 0; ind < array_length(filenames); ind++) {
    if (ds_map_find_value(async_load, "id") == ds_map_find_value(files_in_upload, filenames[ind]))
    {
        if (ds_map_find_value(async_load, "status") == 0) {
            if (loading_error == "") {
                array_push(loaded_files, filenames[ind])
                if (array_length(loaded_files) == array_length(filenames)) {
                    copy_files_from_tmp()
                }
            } else {
                clear_tmp()
            }
        } else if (ds_map_find_value(async_load, "status") < 0) {
            loading_error = string(ds_map_find_value(async_load, "http_status"));
            loading_new_translation_files = false;
            
            clear_tmp()
        }
    }
}