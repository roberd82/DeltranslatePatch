var jp = variable_global_exists("lang") && global.lang == "ja";

if (pause != 1)
    timer += text_speed;

if (polite && timer < 30)
    timer += 0.3;

if (timer > (76 + (60 * (polite == 2))))
    instance_destroy();

if (!bright && !instance_exists(obj_ghosthouse_jackolantern) && !instance_exists(obj_dw_church_jackenstein))
    exit;

var str;

var phrases = get_chapter_lang_setting("jack_phrases", [
    ["YOUR", " TAKING", " TOO", " LONG  "],
    ["YOUR", " TAKING", " TOO", " LONG  "],
    ["YOUR", " TAKING", " TOO", " LONG  "],
    ["YOUR", "       ", "    ", " LONG  "],
    ["  LO", "       ", "    ", " NG  "],

    ["YOUR", " TAKING", " TOO", " LONG  "],
    ["    ", "     IS", "    ", "       "],
    ["    ", " TAKING", " TOO", " LONG  "],

    ["YOUR", " TAKING", " TOO", " TOO   "],
    ["    ", "       ", " TOO", " TOO   "],
    ["YOUR", "       ", " TOO", " TOO   "],

    ["YOUR", " TAKING", " TOO", " LONG  "],
    ["LONG", " TAKING", " TOO", " LONG  "],


    ["YOUR", " TOO", " BRIGHT"]
]);

var timings = get_chapter_lang_setting("jack_timings", [
    [0, 13, 27, 37],
    [0, 13, 27, 37],
    [0, 13, 27, 37],
    [0, 0, 30, 30],
    [0, 0, 5, 5],

    [0, 13, 27, 37],
    [50, 50, 50, 50],
    [62, 62, 81, 88],

    [0, 13, 27, 37],
    [0,  0, 27, 37],
    [0, 13, 27, 37],

    [0, 13, 27, 37],
    [30, 39, 53, 63],

    [0, 23, 40]
]);

// if ((i_ex(obj_jackenstein_enemy) && obj_jackenstein_enemy.scaredycat) && pause > 1 && tutu < 2)
//     str = stringsetloc("LONG", "obj_takingtoolong_slash_Draw_0_gml_19_0");
// else if (!small || pause > 1)
//     str = stringsetloc("YOUR", "obj_takingtoolong_slash_Draw_0_gml_21_0");
// else
//     str = " ";

// var str2 = stringsetloc("YOUR ", "obj_takingtoolong_slash_Draw_0_gml_25_0");

if (small && timer == (11 - max(ceil(obj_ghosthouse_jackolantern.timer / 11), 10 * (i_ex(obj_jackenstein_enemy) && obj_jackenstein_enemy.scaredycat))) && pause < 1)
{
    if (instance_number(object_index) < 27)
    {
        if ((instance_number(object_index) % 2) == 0)
            doom = true;
        
        var _x = lengthdir_x(9 + (2.4 * instance_number(object_index)) + random(9), (instance_number(object_index) + 74) * instance_number(object_index));
        var _y = lengthdir_y(7 + (1.7 * instance_number(object_index)), ((3.12 * instance_number(object_index)) + 74) * instance_number(object_index)) - 15;
        
        with (instance_create_depth(obj_ghosthouse_jackolantern.x + _x, obj_ghosthouse_jackolantern.y + _y, obj_heart.depth - instance_number(object_index), obj_bulletparent))
        {
            sprite_index = spr_small_jackolantern;
            snd_play(snd_small_jackolantern_appear);
            
            with (instance_create_depth(x - 40, y - 40, obj_heart.depth - 1000, obj_takingtoolong))
                small = true;
        }
    }
}

if (small && timer == 12 && pause == 0)
{
    pause = true;
    timer = 0;
}

if (small && obj_ghosthouse_jackolantern.timer >= 130 && pause == 1)
{
    pause = 2;
    timer = 0;
    fade = 1;
    
    if (i_ex(obj_jackenstein_enemy) && obj_jackenstein_enemy.scaredycat)
        text_speed = 4;
}


// if (jp && tutu == 1)
// {
//     str = "カ";
    
//     if (timer > 9)
//         str += "　ワ";
    
//     if (timer > 19)
//         str += "　イ";
    
//     if (timer > 29)
//         str += "　す";
    
//     if (timer > 39)
//         str += "ぎ";
// }
// else if (jp && tutu == 2)
// {
//     text_speed = 2;
//     str = "す";
    
//     if (timer > 15)
//         str += "き";
    
//     if (timer > 30)
//         str += "　　　　す";
    
//     if (timer > 45)
//         str += "き";
// }
// else if (jp && !bright && !tutu && (!small || (pause > 1 && timer > 0)))
// {
//     str = "ナ";
//     str2 = str;
    
//     if (timer > 12)
//         str += "ガ";
    
//     if (timer > 20)
//         str += "イ";
    
//     if (timer > 32)
//         str += " シ";
    
//     if (timer > 39)
//         str += "す";
    
//     if (timer > 46)
//         str += "ぎ";
// }
// else if (jp && bright)
// {
//     str = "マ";
    
//     if (timer > 10)
//         str += " ブ";
    
//     if (timer > 20)
//         str += " シ";
    
//     if (timer > 30)
//         str += " イ";
    
//     if (timer > 38)
//         str += " す";
    
//     if (timer > 46)
//         str += "ぎ";
// }
// else
// {
//     if (timer > (12 + (bright ? 10 : 0)))
//     {
//         if (bright)
//             str += stringsetloc(" TOO", "obj_takingtoolong_slash_Draw_0_gml_69_0");
//         else if (tutu < 2)
//             str += stringsetloc(" TAKING", "obj_takingtoolong_slash_Draw_0_gml_71_0");
//         else
//             str += stringsetloc("       ", "obj_takingtoolong_slash_Draw_0_gml_73_0");
//     }
    
//     if (timer > (26 + (bright ? 13 : 0)))
//     {
//         if (bright)
//             str += stringsetloc(" BRIGHT", "obj_takingtoolong_slash_Draw_0_gml_78_0");
//         else
//             str += stringsetloc(" TOO", "obj_takingtoolong_slash_Draw_0_gml_80_0");
//     }
    
//     if (timer > (36 + (5 * jp)) && !bright)
//     {
//         if (tutu)
//             str += stringsetloc(" TOO", "obj_takingtoolong_slash_Draw_0_gml_85_0");
//         else
//             str += stringsetloc(" LONG", "obj_takingtoolong_slash_Draw_0_gml_87_0");
//     }
// }

// if (polite == 2)
// {
//     if (timer > 61)
//     {
//         if (jp)
//             str2 += "ガ";
//         else
//             str2 += stringsetloc("TAKING", "obj_takingtoolong_slash_Draw_0_gml_93_0");
//     }
    
//     if (timer > 68 && jp)
//         str2 += "イ";
    
//     if (timer > 80)
//     {
//         if (jp)
//             str2 += " シ";
//         else
//             str2 += stringsetloc(" TOO", "obj_takingtoolong_slash_Draw_0_gml_97_0");
//     }
    
//     if (timer > 87)
//     {
//         if (jp)
//             str2 += "す";
//         else
//             str2 += stringsetloc(" LONG", "obj_takingtoolong_slash_Draw_0_gml_101_0");
//     }
    
//     if (timer > 94)
//         str2 += "ぎ";
// }

if (doom && pause == 2)
    instance_destroy();


var ind = 0;
if (instance_exists(obj_jackenstein_enemy))
switch (obj_jackenstein_enemy.myattackchoice) {
    case (1):
        ind = 0; break;
    case (2):
        ind = 1; break;
    case (3):
        ind = 2; break;
    case (4):
        ind = (alt ? 4 : 3); break;
    case (6):
        ind = 5; break;
    case (7):
        ind = (tutu < 2 ? (alt ? 9 : 8) : 10); break;
    case (8):
        ind = (obj_jackenstein_enemy.scaredycat ? 12 : 11); break;
    case (9):
        ind = 13; break;
}


var str = "";
var it = 0;
var str_max = "";

if (!small || pause > 1) {
    while (it < array_length(phrases[ind])) {
        if (timer >= timings[ind][it]) {
            str += phrases[ind][it];
        }
        str_max += phrases[ind][it];
        it++;
    }
}


draw_set_alpha(1);
draw_set_color(c_white);

if (small)
{
    draw_set_font(scr_84_get_font("main_mono"));
}
else
{
    draw_set_font(scr_84_get_font("mainbig_mono"));
}

var step = (15 - (8 * small));

var num = (!polite * max(0, (string_length(str) / 6) - 1)) / (1 + small);
draw_set_alpha(fade);

for (var pos = 1; pos <= string_length(str); pos++)
    draw_text(x - (step * string_length(str_max) / 2) + irandom_range(-num, num) + (step * pos), y + irandom_range(-num, num), string_char_at(str, pos));

if (polite == 2) {
    var str2 = "";
    var str2_max = "";
    var it2 = 0;
    while (it2 < array_length(phrases[ind + 1])) {
        if (timer >= timings[ind + 1][it2]) {
            str2 += phrases[ind + 1][it2];
        }
        str2_max += phrases[ind + 1][it2];
        it2++;
    }

    var str3 = "";
    var str3_max = "";
    var it3 = 0;
    while (it3 < array_length(phrases[ind + 2])) {
        if (timer >= timings[ind + 2][it3]) {
            str3 += phrases[ind + 2][it3];
        }
        str3_max += phrases[ind + 2][it3];
        it3++;
    }

    var pos = 1;
    
    while (pos <= string_length(str2))
    {
        draw_text(x - (step * string_length(str2_max) / 2) + (15 * pos), y + 30, string_char_at(str2, pos));
        pos++;
    }

    pos = 1;
    
    while (pos <= string_length(str3))
    {
        draw_text(x - (step * string_length(str3_max) / 2) + (15 * pos), y + 60, string_char_at(str3, pos));
        pos++;
    }
}

draw_set_alpha(1);
