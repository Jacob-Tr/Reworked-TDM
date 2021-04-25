#define USER_FILE "Users/%c/%.ini"

#define DIALOG_REGISTER 0

#define MAX_PLAYER_INTS 0

#define MAX_PLAYER_STRS 1
#define STR_USR_PSWRD 0

#define SAVE_SRVR_VAR(%0,%1) INI_WriteInt((%0), server_data_str[(%1)], server_data[(%1)])
#define SAVE_USER_VAR(%0,%1) INI_WriteInt((%0), player_data_str[(%1)], player_data[playerid][(%1)])
#define SAVE_USER_VAL(%0,%1,%2) INI_WriteInt((%0), player_data_str[(%1)], (%2))
#define SAVE_USER_FLT(%0,%1) INI_WriteFloat((%0), player_flt_data_str[(%1)], player_flt_data[playerid][(%1)])
#define SAVE_USER_STR(%0,%1) INI_WriteString((%0), player_str_data_str[(%1)], player_str_data[playerid][(%1)])

#define LOAD_SRVR_VAR(%0) INI_Int(server_data_str[(%0)], server_data[(%0)])
#define LOAD_USER_VAR(%0,%1) INI_Int(player_data_str[(%1)], player_data[(%0)][(%1)])
#define LOAD_USER_FLT(%0,%1) INI_Float(player_flt_data_str[(%1)], player_flt_data[(%0)][(%1)])
//#define LOAD_USER_STR(%0,%1) INI_String(player_str_data_str[(%1)], player_str_data[(%0)][(%1)][], sizeof(player_str_data[(%0)][(%1)]))

#define SendConsoleLog(%0) printf("<Server>: %s", (%0))

#define PARSE_NAME(%0,%1) format((%1), sizeof((%1)), "%s", GetName((%0)))

forward LoadServerData(name[], value[]);
forward LoadUserData(playerid, name[], value[]);

new player_str_data_str[MAX_PLAYER_STRS][] =
{
	{"Password"}
};

new bool:registered[MAX_PLAYERS] = {false, false, ...};
new bool:logged[MAX_PLAYERS] = {false, false, ...};

new player_data[MAX_PLAYERS][MAX_PLAYER_INTS];
new player_password[MAX_PLAYERS][256];

new Text:black_background = NULL_TEXT;
new Text:multiplayer_option = NULL_TEXT;
new Text:loadout_option = NULL_TEXT;

new PlayerText:login_option = NULL_PTEXT;

#include <Server\Users\Reg&Login>
#include <Server\Menu\MainMenu>
