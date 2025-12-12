#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <csx>
#include <engine>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>

native get_user_xp(id)
native set_user_xp(id, amount)

native set_user_prestige(id, how)
native get_user_prestige(id)

public plugin_init()
{
	register_plugin("Prestige Shop", "1.1", "extazY")
	
	register_clcmd("set_prestige", "set_prestige", ADMIN_RCON, "<name> <amount>")

	register_clcmd("say /prs", "CmdPrestigeMenu");
	register_clcmd("say /prestige", "CmdPrestigeMenu");
	
	register_clcmd("say prs", "CmdPrestigeMenu");
	register_clcmd("say prestige", "CmdPrestigeMenu");
}

public CmdPrestigeMenu(id)
{
	new Title[128], Menu
	formatex(Title, sizeof(Title)-1, "\r[\yGunXP\r] \wPrestige Shop^n\yAvailable XP: \r%d", get_user_xp(id))
	Menu = menu_create(Title, "CmdBuyPrestige")
	
	if(get_user_xp(id) >= 150000) 
		menu_additem(Menu, "\w1 Prestige - \r150000\y XP", "1", 0)
	else 
		menu_additem(Menu, "\d1 Prestige - \r150000 XP", "1", 0)
		
	if(get_user_xp(id) >= 450000)
		menu_additem(Menu, "\w3 Prestige - \r450000\y XP", "2", 0)
	else 
		menu_additem(Menu, "\d3 Prestige - \r450000 XP", "2", 0)
		
	if(get_user_xp(id) >= 750000) 
		menu_additem(Menu, "\w5 Prestige - \r750000\y XP", "3", 0)
	else 
		menu_additem(Menu, "\d5 Prestige - \r750000 XP", "3", 0)		

	if(get_user_xp(id) >= 1500000) 
		menu_additem(Menu, "\w10 Prestige - \r1500000\y XP", "4", 0)
	else 
		menu_additem(Menu, "\d10 Prestige - \r1500000 XP", "4", 0)
		
	menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, Menu, 0);
}

public CmdBuyPrestige(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new Data[6], Name[64];
	new Access, CallBack;
	menu_item_getinfo(menu, item, Access, Data,5, Name, 63, CallBack);
	new Key = str_to_num(Data);
	switch(Key) {
		case 1:
		{
			new PrestigeCost = get_user_xp(id) - 150000
			if(PrestigeCost < 0) 
				ColorChat(id, "!t[GunXP]!y You dont have enought !tXP!n to buy!g 1 prestige!g !")
			else {
				set_user_prestige(id, get_user_prestige(id) + 1) 
				set_user_xp(id, PrestigeCost)
				ColorChat(id, "!t[GunXP]!1 You buyed !g1 prestige !")
			}
		}
		case 2:
		{
			new PrestigeCost = get_user_xp(id) - 450000
			if(PrestigeCost < 0) 
				ColorChat(id, "!t[GunXP]!y You dont have enought !tXP!n to buy!g 3 prestige!g !")
			else {
				set_user_prestige(id, get_user_prestige(id) + 3) 
				set_user_xp(id, PrestigeCost)
				ColorChat(id, "!t[GunXP]!1 You buyed !g3 prestige !")
			}
		}
		case 3:
		{
			new PrestigeCost = get_user_xp(id) - 750000
			if(PrestigeCost < 0) 
				ColorChat(id, "!t[GunXP]!y You dont have enought !tXP!n to buy!g 5 prestige!g !")
			else {
				set_user_prestige(id, get_user_prestige(id) + 5) 
				set_user_xp(id, PrestigeCost)
				ColorChat(id, "!t[GunXP]!1 You buyed !g5 prestige !")
			}
		}
		case 4:
		{
			new PrestigeCost = get_user_xp(id) - 1500000
			if(PrestigeCost < 0) 
				ColorChat(id, "!t[GunXP]!y You dont have enought !tXP!n to buy!g 10 prestige!g !")
			else {
				set_user_prestige(id, get_user_prestige(id) + 10) 
				set_user_xp(id, PrestigeCost)
				ColorChat(id, "!t[GunXP]!1 You buyed !g10 prestige !")
			}
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

// Give Prestige
public set_prestige (id, level, cid) {

    if(!cmd_access(id, level, cid, 3))
        return PLUGIN_HANDLED;

    new arg[32], arg2[32];
    read_argv(1, arg, 32);
    read_argv(2, arg2, 31);
    
    new player = cmd_target(id,arg,2);
    if(!player) return PLUGIN_HANDLED;
    
    new prestigeamount = str_to_num(arg2);
    set_user_prestige(player, get_user_prestige(player) + prestigeamount);
    
    if( prestigeamount < 0 )
    {
        console_print(id, "You can't give player prestige lower that 0");
        return PLUGIN_HANDLED;
    }
    
    new player_name[32], admin_name[32];
    get_user_name(player, player_name, 31);
    get_user_name(id, admin_name, 31);
    
    switch(get_cvar_num("amx_show_activity"))
    {
        case 2: ColorChat(id, "!gADMIN !y%s: give !t%s %i !gPrestige", admin_name, player_name, prestigeamount);
        case 1: ColorChat(id, "!gADMIN: !ygive !t%s %i !gPrestige", player_name, prestigeamount);
    }
    
    return PLUGIN_HANDLED;
}

stock ColorChat(const id, const input[], any:...) {
	new count = 1, players[32];
	static msg[191];
	vformat(msg, 190, input, 3);
	
	replace_all(msg, 190, "!g", "^4");
	replace_all(msg, 190, "!y", "^1");
	replace_all(msg, 190, "!t", "^3");
	
	if(id) players[0] = id;
	else get_players(players, count, "ch"); {
		for(new i = 0; i < count; i++) {
			if(is_user_connected(players[i])) {
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i]);
				write_byte(players[i]);
				write_string(msg);
				message_end();
			}
		}
	} 
}
