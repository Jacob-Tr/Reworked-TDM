// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

#include <fixes>
#if defined isnull
	#undef isnull
#endif

forward VA_OnScriptInit();
#include <YSI\y_hooks>
#include <YSI\y_ini>
#define INI_Exists(%0) fexist((%0))

#include <EUL\Utils\eUtilities>
#include <EUL\Utils\eColors>

#include <Server\Core>

main() {}

public LoadUserData(playerid, name[], value[])
{
    INI_String(player_str_data_str[STR_USR_PSWRD], player_password[playerid]);
	//LOAD_USER_STR(playerid, STR_USR_PSWRD);
	return 1;
}

public OnGameModeInit()
{
	InitializeMenu();
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetSpawnInfo(playerid, -1, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	TogglePlayerControllable(playerid, false);
	return 1;
}

public OnPlayerConnect(playerid)
{
	SCM(playerid, COLOR_YELLOW, "~ You are recommended to disable timestamps.");
	
	new player_name[MAX_PLAYER_NAME], user_folder_str[64], user_file[64];
	PARSE_NAME(playerid, player_name);

	format(user_file, sizeof(user_file), USER_FILE, player_name[0], player_name);
	
	if(INI_Exists(user_file)) registered[playerid] = true;
	
	InitializeLoginOption(playerid);

	ShowPlayerGameMenu(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SelectTextDraw(playerid, COLOR_YELLOW);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == login_option)
	{
	    new input[256] = " ";
 		if(registered[playerid]) ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""EMBED_GREEN"Login:", input, "Confirm", "Cancel");
		else ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""EMBED_RED"Register:", input, "Confirm", "Cancel");
		return 1;
	}
	return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
