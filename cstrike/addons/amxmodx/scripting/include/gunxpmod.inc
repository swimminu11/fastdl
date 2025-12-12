// Gun Xp Mod Include File //
#if defined _gunxpmod_included
  #endinput
#endif
#define _gunxpmod_included

#if !defined charsmax
    #define charsmax(%1) sizeof(%1)-1
#endif 

//Unlocks levels defined
#define GUN_SECTION_KNIFE 1
#define GUN_SECTION_PISTOL 2
#define GUN_SECTION_RIFLE 3
#define GUN_SECTION_GRENADES 4
#define GUN_SECTION_ITEMS 5
#define GUN_SECTION_VIP 6 

//Access unlocks
#define GUN_FIRST_ACCESS_ID 1
#define GUN_FIRST_ACCESS ADMIN_LEVEL_H
#define GUN_FIRST_ACCESS_TEXT "Require VIP access"

#define GUN_SECOND_ACCESS_ID 2
#define GUN_SECOND_ACCESS ADMIN_BAN
#define GUN_SECOND_ACCESS_TEXT "Require ADMIN access"

#define GUN_THIRD_ACCESS_ID 3
#define GUN_THIRD_ACCESS ADMIN_IMMUNITY
#define GUN_THIRD_ACCESS_TEXT "Require SADMIN access"

//Class PIRCES
#define CLASS_PRICE_XP 1
#define CLASS_PRICE_PR 2

//Unlocks CSW
#define CSW_SANDBAGS 33

//POWERS******
native load_powers();

native get_bonus_xp(id); //Get bonus XP
native get_k1asus(id); //Get k1asus count
native get_supp_box(id); //Get supply box XP from
native get_forcefield_time(id); //Get force field additional time
native get_pipe_radius(id); //Get percent of additional radius
//************

//get if loaded levels
native gxm_level_loaded(id);

//save user level/xp/prestige
native gxm_save_level(id);

//get user save type
native get_user_save_type(id);

// Returns player Experience.
native get_user_xp(id)

// Sets player Experience.
native set_user_xp(id, amount)

// Returns player Prestige.
native get_user_prestige(id)

// Sets player Prestige.
native set_user_prestige(id, amount)

// Returns player Level.
native get_user_level(id)

// Sets player Level.
native set_user_level(id, amount)

// Returns player Level by Xp.
native get_user_max_level(id)

// Register Item.
stock find_itemplugin()
{
	for(new i = 0; i < get_pluginsnum(); ++i)
	{
		new temp[2], name[64]
		get_plugin(i, name, 63, temp, 1, temp, 1, temp, 1, temp, 1)
 		if(equali(name, "gunxpmod_shop.amxx")) {
 			return i;
		}
	}
 	return -1;
}

stock find_itemindex()
{
	new temp[2], name[64], pluginname[64]
	get_plugin(-1, pluginname, 63, temp, 1, temp, 1, temp, 1, temp, 1)
	for (new i = 0; i < get_pluginsnum(); ++i)
	{
		get_plugin(i, name, 63, temp, 1, temp, 1, temp, 1, temp, 1)
 		if(equal(name, pluginname))
		{
 			return i
		}
	}
 	return -1
}

native register_gxm_item(item_name[], item_desc[], item_cost, item_level, item_section, item_access, weapon)
native register_item_gxm(item_name[], item_desc[], item_cost, item_level, item_section, item_access)

// Register Skills.
stock find_skillplugin()
{
	for(new i = 0; i < get_pluginsnum(); ++i)
	{
		new temp[2], name[64]; get_plugin(i, name, 63, temp, 1, temp, 1, temp, 1, temp, 1);
 		if(equali(name, "gunxpmod_powers.amxx")) { return i; }
	}
 	return -1;
}

stock find_skillindex()
{
	new temp[2], name[64], pluginname[64];
	get_plugin(-1, pluginname, 63, temp, 1, temp, 1, temp, 1, temp, 1);
	for (new i = 0; i < get_pluginsnum(); ++i) {
		get_plugin(i, name, 63, temp, 1, temp, 1, temp, 1, temp, 1);
 		if(equal(name, pluginname)) { return i; }
	}
 	return -1
}

stock register_gxm_apwr(skill_name[], skill_desc[], skill_cost, skill_level, skill_access)
{
	new skill_index = find_skillindex(), skillplugin = find_skillplugin();
	new itemregfunc = get_func_id("register_apwr_gxm", skillplugin);

	new temp = callfunc_begin_i(itemregfunc, skillplugin);
	if(temp == -1 || temp == -2)
	{
		if(temp == -2) { log_amx("You have to many skill and need to increase the MAX_SKILLS define!"); }
		else { log_amx("A unkown error has happend, make sure the Skills plugin is loaded!"); }
		
		return PLUGIN_HANDLED;
	}

	callfunc_push_int(skill_index);
	callfunc_push_str(skill_name);
	callfunc_push_str(skill_desc);
	callfunc_push_int(skill_cost);
	callfunc_push_int(skill_level);
	callfunc_push_int(skill_access);
	
	temp = callfunc_end();
	if(temp == -1 || temp == -2) { return PLUGIN_HANDLED; }
	
	return temp;
}