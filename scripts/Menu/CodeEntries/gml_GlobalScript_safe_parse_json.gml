function safe_parse_json(arg0, arg1, arg2)
{
    try
    {
        return json_parse(arg0);
    }
    catch (err)
    {
        show_message(arg2);
        return json_parse(arg1);
    }
}
