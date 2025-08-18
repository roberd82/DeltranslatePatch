#load "../BaseFix.csx"

#region Отрисовка доп. спрайтов в контроллере

string room_code = @"";
foreach (var room in jsonRooms)
{
    room_code += string.Format("if (room == {0}) {{\n", room.Key);

    foreach (var spr in jsonRooms[room.Key])
    {
        if (spr["type"] == "tile")
        {
            if (room.Key == "room_town_school")
            {
                room_code += $@"    
                var n = scr_marker_animated({spr["x"]}, {spr["y"]}, scr_84_get_sprite(""{spr["sprite"]}""), sprite_get_speed(scr_84_get_sprite(""{spr["sprite"]}"")))
                n.depth = {spr["depth"]}
                var arr = layer_get_all_elements(""{spr["layer"]}"")
                layer_tilemap_destroy(arr[array_length(arr) - 4])
                ";
            }
            else
            {
                room_code += $@"    
                var n = scr_marker_animated({spr["x"]}, {spr["y"]}, scr_84_get_sprite(""{spr["sprite"]}""), sprite_get_speed(scr_84_get_sprite(""{spr["sprite"]}"")))
                n.depth = {spr["depth"]} - 1
                ";
            }
        }
        if (spr["type"] == "sprite")
        {
            room_code += $@"
            var lay_id = layer_get_id(""{spr["layer"]}"");
            var back_id = layer_sprite_get_id(lay_id, ""{spr["spr_name"]}"");
            layer_sprite_change(back_id, scr_84_get_sprite(""{spr["sprite"]}""));
            ";
        }
        if (spr["type"] == "background")
        {
            room_code += $@"
            var lay_id = layer_get_id(""{spr["layer"]}"");
            var back_id = layer_background_get_id(lay_id);
            layer_background_sprite(back_id, scr_84_get_sprite(""{spr["sprite"]}""));
            ";
        }

        IncrementProgress();
        UpdateProgressValue(GetProgress());
    }

    room_code += "}\n";
}

AddNewEvent("obj_gamecontroller", EventType.Other, (uint)EventSubtypeOther.RoomStart, room_code);

#endregion

await SaveEntries();