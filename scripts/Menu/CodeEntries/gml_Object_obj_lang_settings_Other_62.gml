if (ds_map_find_value(async_load, "id") == language_downloading_call)
{
    if (ds_map_find_value(async_load, "status") == 0)
    {
        var file_buffer = buffer_load("\\\\?\\" + program_directory + "tmp/lang.zip");
        
        language_downloading = false;
        lang_file_size = 0;
        downloaded_size = 0;

        if (buffer_get_size(file_buffer) == 0)
        {
            loading_error = "408";
            obj_gamecontroller.clear_tmp();
        } else {
            unzipping = true
            var unzipping_status = zip_unzip(
                "\\\\?\\" + program_directory + "tmp/lang.zip",
                "\\\\?\\" + program_directory + "lang/"
            )

            if (unzipping_status <= 0) {
                unzipping_error = "Lang zip file extraction failed";
            } else {
                update_languages();
            }

            obj_gamecontroller.clear_tmp();
            unzipping = false;
        }
    }
    else if (ds_map_find_value(async_load, "status") < 0)
    {
        loading_error = string(ds_map_find_value(async_load, "http_status"));
        language_downloading = false;
        obj_gamecontroller.clear_tmp();
    }
    else if (ds_map_find_value(async_load, "status") > 0)
    {
        lang_file_size = ds_map_find_value(async_load, "contentLength");
        downloaded_size = ds_map_find_value(async_load, "sizeDownloaded");
    }
}
