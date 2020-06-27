#include <EUL\Utils\eColors>

#define MAX_MENUS 2
#define MENU_LOBBY 0
#define MENU_COMMAND 1

new Menu:lobbyMenu[MAX_PLAYERS];
new Menu:commandMenu[MAX_PLAYERS];

new debugString[256];

strtok(const string[], &index, seperator = ' ')
{
	new length = strlen(string);
	new offset = index;
	new result[MAX_STRING];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1))) {
		result[index - offset] = string[index];
		index ++;
	}
	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator)) {
		index ++;
	}
	return result;
}

IsNumeric(const string[])
{
	new length = strlen(string);
	if (length == 0) return false;
	for (new i = 0; i < length; i++) {
		if ((string[i] > '9' || string[i] < '0' && string[i] != '-' && string[i] != '+') || (string[i] == '-' && i != 0) || (string[i] == '+' && i != 0)) return false;
	}
	if (length == 1 && (string[0] == '-' || string[0] == '+')) return false;
	return true;
}

GetName(playerid)
{
	new pName[MAX_PLAYER_NAME];

	if(playerid == -1) pName = "the server";
	else GetPlayerName(playerid, pName, MAX_PLAYER_NAME);

    return pName;
}

DoesPlayerHaveActiveMenu(playerid)
{
	if(IsValidMenu(lobbyMenu[playerid]) || IsValidMenu(commandMenu[playerid]) return true;
	return false;
}

GetPlayerActiveMenu(playerid)
{
	if(IsValidMenu(lobbyMenu[playerid])) return MENU_LOBBY;
	if(IsValidMenu(commandMenu[playerid])) return MENU_COMMAND;
	return -1;
}

stock DestroyPlayerMenu(playerid, &Menu:menuid)
{
	if(menuid == 0) return;
	DestroyMenu(menuid);
	menuid = Menu:0;
}

stock CreatePlayerMenu(playerid, bool:override = false, &Menu:menuid, const title[], columns, Float:x, Float:y, Float:col1width, Float:col2width = 0.0)
{
	if(DoesPlayerHaveActiveMenu(playerid) && !override) return;
	else if(DoesPlayerHaveActiveMenu(playerid)) DestroyPlayerMenu(playerid, menuid);
	
	menuid = CreateMenu(title, columns, Float:x, Float:y, Float:col1width, Float:col2width = 0.0);
}

SendConsoleLog(playerid, text[])
{
	new string[288];
	format(string, sizeof(string), "[FirebombLobby.ini Debug]: %s", text);
	print(string);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(text, "/cpmenu", true) == 0)
	{
		new param[6][128], index;
		
		for(new i = 0; i <= 6; i++)
		{
	    	param[i] = strtok(cmdtext, index);
	    	if(!strlen(param[i])) return SendClientMessage(playerid, COLOR_RED, "Usage: /cpmenu [Title[]] [Columns] [Float:X] [Float:Y] [Float:col1width] [Float:col2width]");
		}
		
		for(new i = 1; i <= 5; i++) if(!IsNumeric(params[i])) return SendClientMessage(playerid, COLOR_RED, "Usage: /cpmenu [Title[]] [Columns] [Float:X] [Float:Y] [Float:col1width] [Float:col2width]");
		
		format(debugString, sizeof(debugString), "[/cpmenu parameters]: text ~ %s/ Colums ~ %d/ X ~ %f/ Y ~ %f/ Col1wwidth ~ %f/ Col2width ~ %f", param[0], param[1], param[2], param[3], param[4], param[5]);
		CreatePlayerMenu(playerid, false, commandMenu[playerid], param[0], param[1], param[2], param[3], param[4], param[5]);
	}
	return 0;
}

