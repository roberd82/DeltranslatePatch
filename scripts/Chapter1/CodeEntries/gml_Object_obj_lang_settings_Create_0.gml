option = 0

scale = 1
xx_options = 25 * scale
xxoff_heart = 15 * scale
yy_options = 50 * scale
yyoff_options = 25 * scale
xx_mid = 160 * scale

yy_return = (205 + 12) * scale

cur_lang_ind = 0
last_lang = global.lang
for (i = 0; i < array_length(global.langs_names); i++) {
    if (global.langs_names[i] == global.lang) {
        cur_lang_ind = i
        break
    }
}

langs_amount = array_length(global.langs_names)

update_strings = function() {
    if (TYPE == 0) {
        config_text = stringsetloc("LANGUAGE CONFIG", "obj_lang_settings_1_1")
        return_text = stringsetloc("RETURN", "obj_lang_settings_2_1")
        yes_text = stringsetloc("YES", "obj_lang_settings_3_1")
        no_text = stringsetloc("NO", "obj_lang_settings_4_1")
        lang_choice_text = stringsetloc("LANGUAGE", "obj_lang_settings_5_1") + ": "
        spec_mode_text = stringsetloc("SPECIAL MODE", "obj_lang_settings_6_1") + ": "
        tr_songs_text = stringsetloc("TRANSLATED VOICES", "obj_lang_settings_7_1") + ": "
        spec_mode_desc_disabled = stringsetloc("SPECIAL MODE DISABLED\nDESCRIPTION (LEAVE SPACE\nIF NO NEED)", "obj_lang_settings_8_1")
        spec_mode_desc_enabled = stringsetloc("SPECIAL MODE ENABLED\nDESCRIPTION (LEAVE SPACE\nIF NO NEED)", "obj_lang_settings_9_1")
    } else {
        config_text = stringsetloc("LANGUAGE CONFIG", "obj_lang_settings_1_0")
        return_text = stringsetloc("Return", "obj_lang_settings_2_0")
        yes_text = stringsetloc("Yes", "obj_lang_settings_3_0")
        no_text = stringsetloc("No", "obj_lang_settings_4_0")
        lang_choice_text = stringsetloc("Language", "obj_lang_settings_5_0") + ": "
        spec_mode_text = stringsetloc("Special Mode", "obj_lang_settings_6_0") + ": "
        tr_songs_text = stringsetloc("Translated Songs", "obj_lang_settings_7_0") + ": "
        spec_mode_desc_disabled = stringsetloc("Special Mode disabled\ndescription (leave space\nif no need)", "obj_lang_settings_8_0")
        spec_mode_desc_enabled = stringsetloc("Special Mode enabled\ndescription (leave space\nif no need)", "obj_lang_settings_9_0")
    }

    options = ["language"]

    spec_mode_switch = false
    translated_songs_switch = false

    if (get_lang_setting("special_mode")) {
        array_push(options, "special_mode")
        spec_mode_switch = true
    }

    if (get_lang_setting("enable_translated_songs_switch")) {
        array_push(options, "enable_translated_songs_switch")
        translated_songs_switch = true
    }

    options_count = array_length(options)
}


TYPE = 0
SUBTYPE = 0
CH = string(global.chapter)
if ossafe_file_exists("filech1_3")
    TYPE = 1
if ossafe_file_exists("filech1_4")
    TYPE = 1
if ossafe_file_exists("filech1_5")
    TYPE = 1
    
BGMADE = 0
BG_ALPHA = 0.5
BG_SINER = DEVICE_MENU.BG_SINER
OB_DEPTH = DEVICE_MENU.OB_DEPTH
obacktimer = DEVICE_MENU.obacktimer
OBM = DEVICE_MENU.OBM
COL_A = DEVICE_MENU.COL_A
COL_B = DEVICE_MENU.COL_B
COL_PLUS = DEVICE_MENU.COL_PLUS
if (TYPE == 1) {
    BGSINER = DEVICE_MENU.BGSINER
    BGMAGNITUDE = DEVICE_MENU.BGMAGNITUDE
    COL_A = DEVICE_MENU.COL_A
    COL_B = DEVICE_MENU.COL_B
    COL_PLUS = DEVICE_MENU.COL_PLUS
    BGMADE = 1
    BG_ALPHA = DEVICE_MENU.BG_ALPHA
    ANIM_SINER = DEVICE_MENU.ANIM_SINER
    ANIM_SINER_B = DEVICE_MENU.ANIM_SINER_B
    TRUE_ANIM_SINER = DEVICE_MENU.TRUE_ANIM_SINER
}

update_strings()

instance_deactivate_object(DEVICE_MENU)