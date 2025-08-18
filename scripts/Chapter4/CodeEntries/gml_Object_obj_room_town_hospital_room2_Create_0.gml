con = -1;

var lay_id = layer_get_id("BACKGROUND");
var back_id = layer_background_get_id(lay_id);
layer_background_sprite(back_id, scr_84_get_sprite("bg_hospital_room2_ch4"));

if (scr_flag_get(457) == 0)
{
    
    if (scr_flag_get(349) > 0)
    {
        layer_background_sprite(back_id, scr_84_get_sprite("bg_hospital_room2_ch4_berdly_sideb"));
        instance_create(180, 105, obj_readable_room1);
        instance_create(180, 105, obj_solidblockLight);
        
        with (obj_caterpillarchara)
        {
            follow = 0;
            visible = 0;
        }
    }
    else
    {
        layer_background_sprite(back_id, scr_84_get_sprite("bg_hospital_room2_ch4_berdly"));
    }
}
else
{
    instance_destroy();
}
