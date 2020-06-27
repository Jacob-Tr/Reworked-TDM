#include <a_samp>
#include <EUL\Utils\eColors>
#include <EUL\Utils\eUtilities>
#include <YSI\y_commands>
#include <YSI\y_hooks>
#include <YSI\y_ini>
#include <sscanf2>
#include <merrandom>

#define SEM SendErrorMessageToPlayer

#define MAX_STRING 255

#define VEHICLE_COL_1 0
#define VEHICLE_COL_2 1

#define PLAYER_SPAWN_X 0
#define PLAYER_SPAWN_Y 1
#define PLAYER_SPAWN_Z 2
#define PLAYER_SPAWN_ROT 3

#define MAX_WEAPONS 42
#define MAX_WEAPON_SLOTS 13
#define WEAPON_SLOTS 3
#define WEAPON_SLOT_PRIMARY 0
#define WEAPON_SLOT_SECONDARY 1
#define WEAPON_SLOT_MELEE 2

#define MAX_AMMO_TYPES 6
#define AMMO_MELEE -1
#define AMMO_9MM 0
#define AMMO_45C 1
#define AMMO_20G 2
#define AMMO_12G 3
#define AMMO_30C 4
#define AMMO_223C 5

#define INI_Exists(%0) fexist(%0) // (%0) is a parameter. (A file directory in this case)
#define USER_FILE "Users/%s/%c/%s.ini" // The format of the files. (scriptfiles/Users/(First letter of player name}/(player name).ini)

#define MAX_LOGINS 3

#define DIALOG_INVENTORY 0

#define MAX_INVENTORY_SIZE (MAX_WEAPONS + MAX_AMMO_TYPES)

#define INVALID_REASON 255

#define DEFAULT_DEBUG_STATE true
#define MAX_DEBUG_KEYWORDS 60

enum data
{
	playerPassword
}

enum sData
{
	playerName
}

new weaponPrice[] =
{
	-1,
	5,
	7,
	10,
	2500,
	5,
	5,
	5,
	75,
	3000,
	-1,
	-1,
	-1,
	-1,
	100000,
	5,
	12500,
	250,
	11000,
	-1,
	-1,
	-1,
	2500,
	2750,
	7000,
	5000,
	5000,
	9000,
	4000,
	5500,
	15000,
	17000,
	4400,
	5000,
	11000,
	23000,
	-1,
	35000,
	50000,
	8000,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	100
};

new Float:ammoPrice[] =
{
	0.22,
	1.75,
	0.5,
	0.75,
	3.0,
	3.0
};

new defaultAmmo[] =
{
	-1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	-1,
	-1,
	-1,
	17,
	17,
	7,
	10,
	2,
	7,
	50,
	30,
	30,
	50,
	30,
	10,
	5,
	1,
	-1,
	150,
	500,
	1,
	-1,
	150,
	150,
	1,
	1,
	1
};

new ammoName[][] =
{
	"9mm",
	".45 Calibre",
	"20 Gauge",
	"12 Gauge",
	".30 Calibre",
	".223 Calibre"
};
	
new weaponName[][] =
{
	"Fists",
	"Brass Knuckles",
	"Golf Club",
	"Nite Stick",
	"Knife",
	"Baseball Bat",
	"Shovel",
	"Pool Cue",
	"Katana",
	"Chainsaw",
	"Dildo",
	"Small Vibrator",
	"Large Vibrator",
	"Vibrator",
	"Flowers",
	"Cane",
	"Grenade",
	"Tear Gas",
	"Molotov Cocktail",
	"",
	"",
	"",
	"9mm Pistol",
	"Silenced 9mm",
	"Desert Eagle",
	"Shotgun",
	"Sawn-off Shotgun", 
	"Combat Shotgun",
	"Micro SMG",
	"SMG",
	"AK47",
	"M4",
	"Tec9",
	"Rifle",
	"Sniper Rifle",
	"Rocket Launcher",
	"HS Rocket Launcher",
	"Flamethrower",
	"Minigun",
	"Satchel Charge",
	"Detonator",
	"Spraycan",
	"Fire Extinguisher",
	"Camera",
	"Nightvision Goggles",
	"Thermal Goggles",
	"Parachute",
	"",
	"",
	"Collision",
	"Collision/Helicopter",
	"Explosion",
	"",
	"Drowned",
	"Suicide"
};

new vehName[][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perennial",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer A",
	"Hotring Racer B",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropduster",
	"Stunt",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster",
	"Monster",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight Flat",
	"Streak Carriage",
	"Kart",
	"Mower",
	"Dune",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"News Van",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Freight Box",
	"Trailer",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police",
	"Police",
	"Police",
	"Ranger",
	"Picador",
	"S.W.A.T",
	"Alpha",
	"Phoenix",
	"Glendale Shit",
	"Sadler Shit",
	"Luggage",
	"Luggage",
	"Stairs",
	"Boxville",
	"Tiller",
	"Utility Trailer"
};

new playerVehicles[MAX_PLAYERS][MAX_VEHICLES];
new vehColor[MAX_VEHICLES][2];

new Float:playerSpawn[MAX_PLAYERS][4];

new playerAmmo[MAX_PLAYERS][MAX_AMMO_TYPES];
new bool:playerWeapons[MAX_PLAYERS][MAX_WEAPONS];
new weaponsOnHand[MAX_PLAYERS][WEAPON_SLOTS];
new currentWeaponid[MAX_PLAYERS];

new playerData[MAX_PLAYERS][data];
new sPlayerData[MAX_PLAYERS][sData][25];

new bool:registering[MAX_PLAYERS];

new loginAttempts[MAX_PLAYERS];

new Dialog:dialog[MAX_PLAYERS];

new Float:realMoney[MAX_PLAYERS];

new currentInvPage[MAX_PLAYERS];

new debugString[256];
new bool:serverDebug = DEFAULT_DEBUG_STATE;
new debugOpt[MAX_DEBUG_KEYWORDS][128];
new opts = 0;

IsVowel(str[])
{
	if(strcmp(str, "a", true, 0) == 0 || strcmp(str, "e", true, 0) == 0 || strcmp(str, "i", true, 0) == 0 || strcmp(str, "o", true, 0) == 0 || strcmp(str, "u", true, 0) == 0) return 1;
	return 0;
}

SendErrorMessageToPlayer(playerid, message[])
{
	if(serverDebug)
	{
		format(debugString, sizeof(debugString), "SEMTP Output for player [%s]: %s", GetName(playerid), message);
		SCL(" ", debugString);
		format(debugString, sizeof(debugString), "Original message: %s", message);
		SCL(" ", debugString);
	}
	
	return SCM(playerid, COLOR_WHITE, message);
}

SendClientMessage2(playerid, color, const message[])
{
	return SendClientMessage(playerid, color, message);
}

GetVacantVehicleID(playerid)
{
	for(new i = 0; i < MAX_VEHICLES; i++) if(playerVehicles[playerid][i] == -1) return i;
	return -1;
}

CreateVehicle2(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren = 0, playerid = -1)
{
	new colorCapture[2], string[128];
	
	if(color1 == -1) color1 = MRandRange(0, 255);
	if(color2 == -1) color2 = MRandRange(0, 255);
	colorCapture[0] = color1;
	colorCapture[1] = color2;
	
	new vehicleid = GetVacantVehicleID(playerid);
	if(vehicleid == -1) return;
	playerVehicles[playerid][vehicleid] = CreateVehicle(vehicletype, x, y, z, rotation, colorCapture[0], colorCapture[1], respawn_delay, addsiren);
	
	format(string, sizeof(string), "~ A %s was created for %s.", vehName[playerVehicles[playerid][vehicleid] - 400], GetName(playerid));
	SCL(" ", string);
	
	vehColor[vehicleid][0] = colorCapture[0];
	vehColor[vehicleid][1] = colorCapture[1];
	
	return;
}

IsPlayerAdmin2(playerid)
{
	return IsPlayerAdmin(playerid);
}

IsB(playerid)
{
    if(strcmp(GetName(playerid), "B", false) == 0 || strcmp(GetName(playerid), "elite", true) == 0|| strcmp(GetName(playerid), "[eLg]elite", true) == 0) return true;
	return false;
}

GetWeaponAmmoType(weaponid)
{
	if(weaponid == 22 || weaponid == 23 || weaponid == 28 || weaponid == 29 || weaponid == 32 || weaponid == 38) return AMMO_9MM;
	if(weaponid == 24) return AMMO_45C;
	if(weaponid == 25 || weaponid == 26) return AMMO_20G;
	if(weaponid == 27) return AMMO_12G;
	if(weaponid == 30 || weaponid == 34) return AMMO_30C;
	if(weaponid == 31 || weaponid == 33) return AMMO_223C;
	return AMMO_MELEE;
}

CanPlayerUseAmmo(playerid, type)
{
	for(new i = 22; i <= MAX_WEAPONS; i++) if(playerWeapons[playerid][i] == true && GetWeaponAmmoType(i) == type) return 1;
	return 0;
}

DetermineInvSize(playerid)
{
	new size = 0;
	for(new i = 0; i <= MAX_WEAPONS; i++)
	{
	    if(i < MAX_AMMO_TYPES) if(playerAmmo[playerid][i] > 0) size++;
	    if(playerWeapons[playerid][i]) size++;
	}
	return size;
}

GetInventoryOrder(playerid)
{
	new inventoryOrder[MAX_INVENTORY_SIZE][128];
	for(new i = 0; i <= MAX_WEAPONS; i++)
	{
		if(i < MAX_AMMO_TYPES)
		{
			if(playerAmmo[playerid][i] > 0)
			{
			    new string[128];
			    format(string, sizeof(string), "%s", ammoName[i]);
				format(inventoryOrder[i], sizeof(string), "%s", string);
			}
		}
		else if(playerWeapons[playerid][i] == true)
		{
		    new string[128];
		    format(string, sizeof(string), "%s", weaponName[i]);
			format(inventoryOrder[i], sizeof(string), "%s", string);
		}
	}
	
	return inventoryOrder;
}

InventoryPageInfo(playerid, page)
{
	new menuItems[MAX_INVENTORY_SIZE][256], lastItem = 0; // 24 is max listitems.
	
	if(serverDebug) SCL(" ", "[IPI Debug]: InventoryPageInfo called.");

	for(new i = 0; i <= MAX_WEAPONS - 1; i++)
	{
	    if(lastItem > 24) break;
	    new string[128];
	    
	    if(serverDebug) SCL(" ", "[IPI Debug]: Created variable 'string'.");
	    
	    if(i < MAX_AMMO_TYPES && playerAmmo[playerid][i] > 0)
		{
		    format(string, sizeof(string), "%s", ammoName[i]);
		    if(serverDebug) SCL(" ", "[IPI Debug]: Finished formatting 'string' for ammoName in 'if' #1.");
			format(menuItems[lastItem++], 128, "%s\n", string);
			if(serverDebug) SCL(" ", "[IPI Debug]: Finished formatting 'menuItems' for 'string' in 'if' #1.");
		}
		if(serverDebug) SCL(" ", "[IPI Debug]: Finished first 'if' statement.");
	    if(playerWeapons[playerid][i] == true)
		{
		    format(string, sizeof(string), "%s", weaponName[i]);
		    if(serverDebug) SCL(" ", "[IPI Debug]: Finished formatting 'string' for weaponName in 'if' #2.");
			format(menuItems[lastItem++], sizeof(string), "%s\n", string);
			if(serverDebug) SCL(" ", "[IPI Debug]: Finished formatting 'menuItems' for 'string' in 'if' #2.");
		}
		if(serverDebug) SCL(" ", "[IPI Debug]: Finished second 'if' statement'");
	}
	
    if(serverDebug) SCL(" ", "[IPI Debug]: 'for' loop #1 finished.");

	new menuInfo[1024];
	
	if(serverDebug) SCL(" ", "[IPI Debug]: menuInfo created.");

	for(new i = 0; i <= lastItem - 1; i++) format(menuInfo, sizeof(menuInfo), "%d\t%s\n", i + (24 * page), menuItems[i]);

    if(serverDebug) SCL(" ", "[IPI Debug]: 'for' loop #2 finished.");

	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[IPI Debug]: Output: %s.", menuInfo);
	    SCL(" ", debugString);
	}

	return menuInfo;
}

GivePlayerMoney2(playerid, Float:amount)
{
	realMoney[playerid] += amount;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, roundtoint(realMoney[playerid]));
	return 1;
}

forward LoadPlayerData(playerid, value[], name[]);
forward OnPlayerGainWeapon(playerid, weaponid);
forward OnPlayerSwitchWeapon(playerid, oldweaponid, weaponid);

public LoadPlayerData(playerid, value[], name[])
{
	INI_String("playerName", sPlayerData[playerid][playerName], 25);
	INI_Int("playerPassword", playerData[playerid][playerPassword]);
	return 1;
}

IsValidWeaponName(name[])
{
	for(new i = 0; i <= MAX_WEAPONS; i++) if(strcmp(name, weaponName[i], true) == 0) return 1;
	return 0;
}

GetWeaponID(name[])
{
	for(new i = 0; i <= MAX_WEAPONS; i++) if(strcmp(name, weaponName[i], true) == 0) return i;
	return 0;
}

GetPlayerWeaponData2(playerid)
{
	new weaponData[MAX_WEAPONS + 1][2];

	for(new i = 1; i <= MAX_WEAPON_SLOTS; i++) GetPlayerWeaponData(playerid, i, weaponData[i][0], weaponData[i][1]);
	return weaponData;
}

SendDeathMessageEx(playerid, killerid, reason)
{
	new string[128], playername[MAX_PLAYER_NAME], killername[MAX_PLAYER_NAME], weaponn[24], modelid;
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	
	if (reason != INVALID_REASON) {
		modelid = killerid != INVALID_PLAYER_ID ? GetPlayerState(killerid) == PLAYER_STATE_DRIVER ? GetVehicleModel(GetPlayerVehicleID(killerid)) : 0 : 0;
		if (reason == 31) {
			switch (modelid) {
				case 447: weaponn = "Sparrow Machine Gun";
				case 464: weaponn = "RC Baron Machine Gun";
				case 476: weaponn = "Rustler Machine Gun";
				default: weaponn = "M4";
			}
		}
		else if (reason == 37) {
			weaponn = "Fire";
		}
		else if (reason == 38) {
			switch (modelid) {
				case 425: weaponn = "Hunter Machine Gun";
				default: weaponn = "Minigun";
			}
		}
		else if (reason == 50) {
			switch (modelid) {
				case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: weaponn = "Helicopter";
				default: {
					weaponn = "Collision";
					reason = 49;
				}
			}
		}
		else if (reason == 51) {
			switch (modelid) {
				case 425: weaponn = "Hunter Missile";
				case 432: weaponn = "Rhino Turret";
				case 520: weaponn = "Hydra Missile";
				default: weaponn = "Explosion";
			}
		}
		else {
				format(weaponn, 24, "%s", weaponName[reason]);
		}
		if (killerid != INVALID_PLAYER_ID) {
			GetPlayerName(killerid, killername, MAX_PLAYER_NAME);
			format(string, 128, "* %s [%d] has been killed by %s [%d] (%s).", playername, playerid, killername, killerid, weaponn);
		}
		else {
			format(string, 128, "* %s [%d] has died (%s).", playername, playerid, weaponn);
		}
	}
	else {
		format(string, 128, "* %s [%d] has died (%s).", playername, playerid, weaponName[sizeof(weaponName)-1]);
	}
	for (new i = 0; i < MAX_PLAYERS; i++) {
		if (i == INVALID_PLAYER_ID) continue;
		
		SCM(i, COLOR_WHITE, string);
		SendDeathMessageToPlayer(i, killerid, playerid, reason);
	}
}

IsValidMeleeWeapon(weaponid)
{
	if((weaponid > 0 && weaponid < 15) || (weaponid >= 40 && weaponid <= 42)) return true;
	return false;
}

IsValidSidearm(weaponid)
{
	if((weaponid >= 15 && weaponid <= 23) || weaponid == 25 || weaponid == 27 || weaponid == 31 || weaponid == 38) return true;
	return false;
}

IsValidPrimary(weaponid)
{
	if(weaponid == 24 || weaponid == 26 || ((weaponid >= 28 && weaponid <= 37) && weaponid != 31)) return true;
	return false;
}

GetValidWeaponSlot(weaponid)
{
	if(IsValidMeleeWeapon(weaponid)) return WEAPON_SLOT_MELEE;
	if(IsValidPrimary(weaponid)) return WEAPON_SLOT_PRIMARY;
	if(IsValidSidearm(weaponid)) return WEAPON_SLOT_SECONDARY;
	return -1;
}

FindFirstSpace(string[])
{
	new spacePos;
	for(new i = 0; i <= strlen(string); i++)
	{
		if(string[i] == ' ') return i;
		if(serverDebug) spacePos = i;
	}

	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[FFS Debug]: First space in %s is at position %d.", string, spacePos);
	    SCL(" ", debugString);
	}

	return strlen(string);
}

main()
{
	print("\n----------------------------------");
	print(" Fun Gamemode by B");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("B's fun");
	for(new i = 1; i <= 311; i++) AddPlayerClass(i, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	
	//if(classid > GetPlayerScore(playerid)) return SEM(playerid, "Error: Your score must atleast match the skin ID you wish to use.");
	return 1;
}

public OnPlayerConnect(playerid)
{
	for(new i = 0; i <= MAX_VEHICLES; i++) playerVehicles[playerid][i] = -1;
	

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	new Float:x, Float:y, Float:z;
	if(x != playerSpawn[playerid][PLAYER_SPAWN_X] || y != playerSpawn[playerid][PLAYER_SPAWN_Y] || z != playerSpawn[playerid][PLAYER_SPAWN_Z]) SetPlayerPos(playerid, playerSpawn[playerid][PLAYER_SPAWN_X], playerSpawn[playerid][PLAYER_SPAWN_Y], playerSpawn[playerid][PLAYER_SPAWN_Z]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new kScore = GetPlayerScore(killerid);
	new score = GetPlayerScore(playerid);
	if(IsB(killerid))
	{
	    new string[128];
		format(string, sizeof(string), "~ %s was killed by B!", GetName(playerid));
		SCMToAll(COLOR_GREEN, string);
	}
	
	SendDeathMessageEx(playerid, killerid, reason);
	if(killerid != INVALID_PLAYER_ID)
	{
	    GivePlayerMoney2(killerid, score == 0 ? 5 : 5 * score);
		SetPlayerScore(killerid, kScore + 1);
	}
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
	return 1;
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
	if(GetPlayerWeapon(playerid) != currentWeaponid[playerid])
	{
		new lastWeaponid = currentWeaponid[playerid];
		currentWeaponid[playerid] = GetPlayerWeapon(playerid);
		
  		/*OnPlayerSwitchWeapon(playerid, lastWeaponid, currentWeaponid[playerid]);
		if(weaponsOnHand[playerid][WEAPON_SLOT_PRIMARY] != currentWeaponid[playerid] && weaponsOnHand[playerid][WEAPON_SLOT_SECONDARY] != currentWeaponid[playerid] && weaponsOnHand[playerid][WEAPON_SLOT_MELEE] != currentWeaponid[playerid]) OnPlayerGainWeapon(playerid, currentWeaponid[playerid]);*/
	}
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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_INVENTORY:
	    {
	        new inventoryOrder[MAX_INVENTORY_SIZE][128];
			inventoryOrder = GetInventoryOrder(playerid);
	        
	        if(response)
	        {
	            if(listitem == -1 && currentInvPage[playerid] == 1) HidePlayerDialog(playerid);
	            if(listitem == -1)
				{
	  				new menuInfo[1024];
		  			menuInfo = InventoryPageInfo(playerid, --currentInvPage[playerid]);
	  				HidePlayerDialog(playerid);
					ShowPlayerDialog2(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory:", menuInfo, "Select", "Next");
				}
				if(IsValidWeaponName(inventoryOrder[listitem]))
				{
				    new weaponid;
					weaponid = GetWeaponID(inventoryOrder[listitem]);
				    new weaponData[MAX_WEAPONS + 1][2];
					weaponData = GetPlayerWeaponData2(playerid);
				    for(new i = 0; i <= MAX_WEAPONS; i++) playerAmmo[playerid][GetWeaponAmmoType(weaponData[i][0])] = weaponData[i][1];
				    
				    ResetPlayerWeapons(playerid);
				    GivePlayerWeapon(playerid, weaponid, playerAmmo[playerid][GetWeaponAmmoType(weaponid)]);
				    return 0;
				}
			}
			else if(!response)
			{
  				new menuInfo[1024];
	  			menuInfo = InventoryPageInfo(playerid, ++currentInvPage[playerid]);
  				HidePlayerDialog(playerid);
				ShowPlayerDialog2(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory:", menuInfo, "Select", "Next");
			}
			return 0;
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

DoesPlayerHaveWeaponOnThem(playerid, weaponid)
{
	if(weaponsOnHand[playerid][GetValidWeaponSlot(weaponid)] == weaponid) return true;
	return false;
}

public OnPlayerGainWeapon(playerid, weaponid)
{
    if(!playerWeapons[playerid][weaponid])
	{
		playerWeapons[playerid][weaponid] = true;
		if(!IsValidMeleeWeapon(weaponid)) playerAmmo[playerid][GetWeaponAmmoType(weaponid)] += GetPlayerAmmo(playerid);
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, weaponsOnHand[playerid][WEAPON_SLOT_PRIMARY], playerAmmo[playerid][weaponsOnHand[playerid][WEAPON_SLOT_PRIMARY]]);
	GivePlayerWeapon(playerid, weaponsOnHand[playerid][WEAPON_SLOT_SECONDARY], playerAmmo[playerid][weaponsOnHand[playerid][WEAPON_SLOT_SECONDARY]]);
	GivePlayerWeapon(playerid, weaponsOnHand[playerid][WEAPON_SLOT_MELEE], playerAmmo[playerid][weaponsOnHand[playerid][WEAPON_SLOT_MELEE]]);
	
	if(!DoesPlayerHaveWeaponOnThem(playerid, currentWeaponid[playerid])) currentWeaponid[playerid] = weaponid;
	SetPlayerArmedWeapon(playerid, currentWeaponid[playerid]);
	
	new string[128];
	if(!IsValidMeleeWeapon(weaponid)) format(string, sizeof(string), "~ You have gained a %s with %d ammo.", weaponName[weaponid], GetPlayerAmmo(playerid));
	return 1;
}

public OnPlayerSwitchWeapon(playerid, oldweaponid, weaponid)
{
	if(weaponsOnHand[playerid][GetValidWeaponSlot(weaponid)] != weaponid) weaponsOnHand[playerid][GetValidWeaponSlot(weaponid)] = weaponid;

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, weaponsOnHand[playerid][WEAPON_SLOT_PRIMARY], playerAmmo[playerid][weaponsOnHand[playerid][WEAPON_SLOT_PRIMARY]]);
	GivePlayerWeapon(playerid, weaponsOnHand[playerid][WEAPON_SLOT_SECONDARY], playerAmmo[playerid][weaponsOnHand[playerid][WEAPON_SLOT_SECONDARY]]);
	GivePlayerWeapon(playerid, weaponsOnHand[playerid][WEAPON_SLOT_MELEE], playerAmmo[playerid][weaponsOnHand[playerid][WEAPON_SLOT_MELEE]]);
	
	currentWeaponid[playerid] = weaponid;
	SetPlayerArmedWeapon(playerid, weaponid);
	return 1;
}

YCMD:teleport(playerid, params[], help)
{
	#pragma unused help
	new pplayerid, ppplayerid = -1, Float:x = -1.0, Float:y, Float:z;
	
	if(sscanf(params, "ifff", pplayerid, x, y, z) || sscanf(params, "ii", pplayerid, ppplayerid)) return SEM(playerid, "Usage: /teleport [Player ID] [X] [Y] [Z] or /teleport [Player ID] [Player ID]");
	
	if(pplayerid == INVALID_PLAYER_ID) return SEM(playerid, "Error: Invalid Player ID.");
	
	if((ppplayerid == -1) && (x == -1.0)) return SEM(playerid, "Error: Invalid Parameters.");
	if((ppplayerid != -1) && (x != -1.0)) return SEM(playerid, "Error: Invalid Parameters.");
	
	if(ppplayerid != -1)
	{
	    if(ppplayerid == INVALID_PLAYER_ID) return SEM(playerid, "Error: Invalid Player ID.");
	    GetPlayerPos(ppplayerid, x, y, z);
	    GetXYInFrontOfPlayer(ppplayerid, x, y);
	    
	    SetPlayerPos(pplayerid, x, y, z);
		GetPlayerPos(ppplayerid, x, y, z);
		SetPlayerCameraLookAt(pplayerid, x, y, z);
	}
	if(x != -1.0) SetPlayerPos(pplayerid, x, y, z);
	
	new string[128];
	format(string, sizeof(string), "~ You have been transported by %s.", GetName(playerid));
	SCM(pplayerid, COLOR_YELLOW, string);
	return 1;
}

YCMD:giveweapon(playerid, params[], help)
{
	#pragma unused help
	new string[128], pplayerid = -1, weaponid, ammo;
	new parameters[3][MAX_STRING], index;
	
	//if(!IsPlayerAdmin2(playerid)) return 0;
	
	for(new i = 0; i <= 2; i++) parameters[i] = strtok(params, index);
	
	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[/giveweapon Debug]: Parameters[#1: %d, #2: %d, #3: %d]", strval(parameters[0]), strval(parameters[1]), strval(parameters[2]));
	    SCL(" ", debugString);
	}
	
	if(!isnumeric(parameters[0]) || !isnumeric(parameters[1])) return SEM(playerid, "Usage: /giveweapon [Player ID] [Weapon ID] [Ammo]");
	if(isnumeric(parameters[2]))
	{
		pplayerid = roundtoint(strval(parameters[0]));
		weaponid = strval(parameters[1]);
		ammo = roundtoint(strval(parameters[2]));
	}
	else
	{
	    weaponid = roundtoint(strval(parameters[0]));
	    ammo = roundtoint(strval(parameters[1]));
	}
	
	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[/giveweapon Debug]: Parameters[Player ID: %d, Weapon ID: %d, Ammo: %d]", pplayerid, weaponid, ammo);
	    SCL(" ", debugString);
	}
	
	if((weaponid < 1 || weaponid > 41) || strlen(weaponName[weaponid]) < 1) return SEM(playerid, "Error: Invalid Weapon ID.");
	
	if(pplayerid == -1) pplayerid = playerid;
	if(!IsPlayerConnected(pplayerid)) return SEM(playerid, "Error: Invalid Player ID.");
	
	playerWeapons[pplayerid][weaponid] = true;
	GivePlayerWeapon(pplayerid, weaponid, ammo);
	
	if(pplayerid != playerid) format(string, sizeof(string), "~ %s has given %s a %s with %d ammo.", GetName(playerid), GetName(pplayerid), weaponName[weaponid], ammo);
	else format(string, sizeof(string), "~ %s has given themself a %s with %d ammo.", GetName(playerid), weaponName[weaponid], ammo);
	
	SCM(playerid, COLOR_YELLOW, string);
	if(!serverDebug) SCL(" ", string);
	return 1;
}

YCMD:buyweapon(playerid, params[], help)
{
	#pragma unused help
	new string[128], weaponid, ammo;

	if(sscanf(params, "i", weaponid)) return SEM(playerid, "Usage: /buyweapon [Weapon ID]");
	if((weaponid < 1 || weaponid > 41) || strcmp(weaponName[weaponid], "", false) == 0 || weaponPrice[weaponid] == -1) return SEM(playerid, "Error: Invalid Weapon ID.");
	
	if(GetPlayerMoney(playerid) < weaponPrice[weaponid])
	{
	    format(string, sizeof(string), "~ You cannot afford a %s.", weaponName[weaponid]);
	    SEM(playerid, string);
	    return 1;
	}
	
	ammo = defaultAmmo[weaponid];
	
	playerWeapons[playerid][weaponid] = true;

	GivePlayerMoney2(playerid, -weaponPrice[weaponid]);
	GivePlayerWeapon(playerid, weaponid, ammo);
	return 1;
}

YCMD:buyammo(playerid, params[], help)
{
	#pragma unused help
	new string[128], type, amount;
	if(sscanf(params, "ii", type, amount)) return SEM(playerid, "Usage: /buyammo [Weapon ID/Ammo Type] [Amount]");

	if(type < 0 && type > MAX_AMMO_TYPES && ((type < 22 && type > 39) || weaponPrice[type] == -1)) return SEM(playerid, "Error: Invalid Weapon ID or Ammo Type.");
	if(type > MAX_AMMO_TYPES) type = GetWeaponAmmoType(type);
	
	if(amount < 1) return SEM(playerid, "Error: Invalid ammo amount.");
 	if(playerAmmo[playerid][type] + amount > 9999)
 	{
 	    format(string, sizeof(string), "Error: You can only hold %d more rounds of that type.", playerAmmo[playerid][type] > 9999 ? 0 : (9999 - playerAmmo[playerid][type]));
 	    SEM(playerid, string);
 	    return 1;
	}
	
	new Float:cost = (ammoPrice[type] * amount);
	
	if(CanPlayerUseAmmo(playerid, type)) format(string, sizeof(string), "~ The total is %2.f.", cost);
	else format(string, sizeof(string), "~ The total is $%2.f; none of your weapons fire this round.", cost);
	SCM(playerid, COLOR_YELLOW, string);
	
	if(cost > GetPlayerMoney(playerid))
	{
	    format(string, sizeof(string), "Error: You could afford %d %s bullets for %d.", roundtoint(GetPlayerMoney(playerid) / ammoPrice[type]), ammoName[type], roundtoint(GetPlayerMoney(playerid) / ammoPrice[type]) * ammoPrice[type]);
	    SEM(playerid, string);
	    return 1;
	}
	
	playerAmmo[playerid][type] += amount;
	GivePlayerMoney2(playerid, -cost);
	return 1;
}

YCMD:vehicle(playerid, params[], help)
{
	#pragma unused help
	new string[128], pplayerid = -1, vehicleid = -1, vehicleName[60] = "", Float:x, Float:y, Float:z, Float:rot, color1 = -1, color2 = -1;
	new matches = 0;
	new matchID[211];
	new param[128];
	
	format(param, sizeof(param), "%s", params);
	
	if(strlen(params) == 0) return SEM(playerid, "Usage: /vehicle [Player ID] [Vehicle ID/Name]");

	while(FindFirstSpace(param) > 0 && strlen(param) > 0)
	{
	    while(param[0] == ' ') strdel(param, 0, 1);
	    if(strlen(param) == 0) break;
	    new test[128], firstSpace = FindFirstSpace(param);
	    
     	strmid(test, param, 0, firstSpace, sizeof(test));

		if(serverDebug)
		{
		    format(debugString, sizeof(debugString), "[/vehicle Debug]: Current test: %s, Current param: %s, Player ID: %d, Vehicle ID: %d.", test, param, pplayerid, vehicleid);
		    SCL(" ", debugString);
		}

	    if(isnumeric(test) && vehicleid == -1 && strlen(vehicleName) < 1)
		{
		    if(strval(test) < 400 && pplayerid == -1)
			{
				if(strval(test) == INVALID_PLAYER_ID) return SEM(playerid, "Error: Invalid Player ID.");
			 	pplayerid = strval(test);
			}
		    else vehicleid = strval(test);
		    strdel(param, 0, firstSpace + 1);

		    if(serverDebug)
		    {
		        format(debugString, sizeof(debugString), "[/vehicle Debug]: Player ID: %d Vehicle ID: %d. Param reduced to %s.", playerid, vehicleid, param);
		        SCL(" ", debugString);
			}
		}

	    if(!isnumeric(test))
		{
	 		strmid(vehicleName, param, 0, firstSpace, sizeof(vehicleName));
	 		strdel(param, 0, firstSpace + 1);

		    if(serverDebug)
		    {
		        format(debugString, sizeof(debugString), "[/vehicle Debug]: Vehicle name set to %s. Param reduced to %s.", vehicleName, param);
		        SCL(" ", debugString);
			}
		}

		if(isnumeric(test) && (strlen(vehicleName) > 0 || vehicleid != -1) && strval(test) <= 255)
		{
			if(color1 == -1) color1 = strval(test);
			else color2 = strval(test);
			strdel(param, 0, firstSpace + 1);

		    if(serverDebug)
		    {
		        format(debugString, sizeof(debugString), "[/vehicle Debug]: Color 1: %d Color 2: %d.", color1, color2);
		        SCL(" ", debugString);
			}
		}
    }

	if(pplayerid == vehicleid) pplayerid = -1; // Otherwise '/vehicle 520' results in parameters [Player ID: 520, Vehicle ID: 520, Vehicle Name: ].
    //if(sscanf(params, "ii", pplayerid, vehicleid)) if(sscanf(params, "i", vehicleid)) return SEM(playerid, "Usage: /vehicle [Player ID] [Vehicle ID/Name]");
	/*do
	{
	    switch(parameterType++)
	    {
	        case 0: if(sscanf(params, "ii", pplayerid, vehicleid) || sscanf(params, "i", vehicleid)) continue;
			case 1: if(sscanf(params, "i", vehicleid)) continue;
	 		case 2: if(sscanf(params, "is[60]", pplayerid, vehicleName)) continue;
	 		case 3: if(sscanf(params, "s[60]", vehicleName)) continue;
	 		default: return SEM(playerid, "Usage: /vehicle [Player ID] [Vehicle ID/Name]");
		}
 	}
 	while(vehicleid == -1 && strcmp(vehicleName, "", false));*/
 	
 	if(serverDebug)
 	{
 	    format(debugString, sizeof(debugString), "[/vehicle Debug]: Parameters[Player ID: %d, Vehicle ID: %d, Vehicle Name: %s]", pplayerid, vehicleid, vehicleName);
 	    SCL(" ", debugString);
	}

	if(pplayerid == -1) pplayerid = playerid;
	if(pplayerid == INVALID_PLAYER_ID) return SEM(playerid, "Error: Invalid Player ID.");
	
	//if(vehicleid == -1 && strcmp(vehicleName, "", false)) return SEM(playerid, "Error: Invalid vehicle.");
	
	if(vehicleid == -1)
	{
		for(new i = 0; i <= 211; i++)
		{
			if(strfind(vehName[i], vehicleName, true) != -1)
			{
			    matchID[matches++] = i + 400;
			    if(strcmp(vehName[i], vehicleName, true) == 0)
			    {
			        if(serverDebug)
			        {
			            format(debugString, sizeof(debugString), "[/vehicle Debug]: Match ID: %d.", i);
			            SCL(" ", debugString);
					}
				    vehicleid = i + 400;
				    matches = 1;
				    break;
				}
			}
			continue;
		}
		
		if(serverDebug)
		{
		    format(debugString, sizeof(debugString), "[/vehicle Debug]: Matches: %d", matches);
		    SCL(" ", debugString);
		}
		
		if(matches == 0 && vehicleid == -1) return SEM(playerid, "Error: Invalid vehicle name.");
		
	    for(new i = 0; i <= matches; i++)
	    {
	        new matchInfo[128];
            if(matches == 1)
            {
			    if(serverDebug)
			    {
			        format(debugString, sizeof(debugString), "[/vehicle Debug]: Vehicle ID assigned to: %d.", matchID[i]);
			        SCL(" ", debugString);
				}
				vehicleid = matchID[i];
				break;
			}
			else
			{
			    if(i == 0) SCM(playerid, COLOR_YELLOW, "~ Matches:");

			    if(serverDebug) SCL(" ", " ", "[/vehicle Debug]: Made it.");
			    
			    if(matchID[i] < 400) break;
			    
	        	format(matchInfo, 128, "Match #%d: %s. (ID: %d)", i, vehName[matchID[i] - 400], matchID[i]);
	        	SCM(playerid, COLOR_YELLOW, matchInfo);
        	
				if(serverDebug)
				{
				    format(debugString, 128, "[/vehicle Debug]: %s.", matchInfo);
				    SCL(" ", debugString);
				}
			}
		}
	}
		
	if(vehicleid < 400 || vehicleid > 611) return SEM(playerid, "Error: Invalid Vehicle ID.");
	
	GetPlayerPos(pplayerid, x, y, z);
	GetPlayerFacingAngleFix(pplayerid, rot);
	GetXYInFrontOfPlayer(pplayerid, x, y);
	
	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[/vehicle Debug]: Final Params[Vehicle ID: %d, Player ID: %d, Color 1: %d, Color 2: %d.", vehicleid, pplayerid, color1, color2);
		SCL(" ", debugString);
	}
	
	if(playerid == pplayerid)
	{
	    if(serverDebug) SCL(" ", "/vehicle Debug]: playerid & pplayerid are equal.");
		format(string, sizeof(string), "~ %s spawned.", vehName[vehicleid - 400]);
	}
	else
	{
	    if(serverDebug) SCL(" ", "/vehicle Debug]: playerid & pplayerid are not equal.");
	    new pString[128];
		format(string, sizeof(string), "~ You have spawned a %s for %s.", vehName[vehicleid - 400], GetName(pplayerid));
		format(pString, sizeof(pString), "~ %s spawned for you.", vehName[vehicleid - 400]);
		SCM(pplayerid, COLOR_YELLOW, pString);
	}
	if(serverDebug) SCL(" ", "/vehicle Debug]: Finished 'if' statement.");
	
	SCM(playerid, COLOR_YELLOW, string);
	
	if(serverDebug) SCL(" ", "[/vehicle Debug]: Client messages sent.");

	CreateVehicle2(vehicleid, x, y, z, rot, color1, color2, -1, 0, pplayerid);
	
	if(serverDebug) SCL(" ", "/vehicle Debug]: Command end.");
	return 1;
}

YCMD:setspawn(playerid, params[], help)
{
	#pragma unused help
	new string[128], Float:x, Float:y, Float:z, Float:rot = -1.0, pplayerid = -1;
	new tempParams[256], paramNum = 0, parameters[5][MAX_STRING];
	new Float:paramValue, Float:firstParamValue;
	
	format(tempParams, sizeof(tempParams), "%s", params);

	if(strlen(tempParams) < 1)
	{
 		GetPlayerPos(playerid, x, y, z);
	    GetPlayerFacingAngleFix(playerid, rot);
	    pplayerid = playerid;
	}
	else
	{
	    new index = 0;
		while(strlen(tempParams) > 0)
		{
			parameters[paramNum] = strtok(tempParams, index);
      		if(paramNum < 4 && strlen(tempParams) > 0) paramNum++;
			else break;
			
		}
		
		if(!isnumeric(parameters[0])) return SEM(playerid, "Usage: /setspawn [Player ID]");
		firstParamValue = strval(parameters[0]);
		
		for(new i = 0; i <= 5; i++)
		{
 			if(!isnumeric(parameters[i])) break;
 			paramValue = strval(parameters[i]);
 			
 			switch(i)
 			{
 			    case 0:
				{
			 		if(!iswholenumber(firstParamValue) || !IsPlayerConnected(roundtoint(firstParamValue))) x = paramValue;
			 		else pplayerid = strval(parameters[0]);
				}
				case 1:
				{
					if(!iswholenumber(firstParamValue)) y = paramValue;
					else x = paramValue;
				}
				case 2:
				{
        			if(!iswholenumber(firstParamValue)) z = paramValue;
        			else y = paramValue;
				}
				case 3:
				{
				    if(!iswholenumber(firstParamValue)) rot = paramValue;
				    else z = paramValue;
				}
				case 4: if(rot == 0.0) rot = paramValue;
				default: continue;
			}
		}
	}
	
	if(!IsPlayerConnected(pplayerid)) return SEM(playerid, "Error: Invalid player ID.");
	
	if(pplayerid == -1) pplayerid = playerid;
	if(x == 0.0 && y == 0.0 && z == 0.0) GetPlayerPos(playerid, x, y, z);
	if(rot == -1.0) GetPlayerFacingAngleFix(pplayerid, rot);
	playerSpawn[playerid][PLAYER_SPAWN_X] = x;
	playerSpawn[playerid][PLAYER_SPAWN_Y] = y;
	playerSpawn[playerid][PLAYER_SPAWN_Z] = z;
	playerSpawn[pplayerid][PLAYER_SPAWN_ROT] = rot;
	SetSpawnInfo(pplayerid, GetPlayerTeam(pplayerid), GetPlayerSkin(pplayerid), x, y, z, rot, 0, -1, -1, -1, -1, -1);

	format(string, sizeof(string), "~ Your spawn location has been set to: X: %.2f, Y: %.2f, Z: %.2f.", x, y, z);
	SCM(pplayerid, COLOR_YELLOW, string);
	if(serverDebug)
	{
		format(debugString, sizeof(debugString), "[/setspawn Debug]: %s's spawn location was set to: X: %.2f, Y: %.2f Z: %.2f.", GetName(pplayerid), x, y, z);
		SCL(" ", debugString);
	}
	return 1;
}

YCMD:toggleserverdebug(playerid, params[], help)
{
	if(!IsPlayerAdmin2(playerid)) return 0;
	new string[128], keyword[] = "", index;
	
	if(strlen(params) == 0)
	{
		serverDebug = serverDebug ? false : true;
		if(serverDebug)
		{
			SCM(playerid, COLOR_YELLOW, "~ Server Debug Status changed to true.");
			SCL(" ", "[Debug mode enabled]");
		}
		else
		{
			SCM(playerid, COLOR_YELLOW, "~ Server Debug Status changed to false.");
			SCL(" ", "[Debug mode disabled]");
		}
		return 1;
	}
	
	strtok(params, index);
	strmid(keyword, params, 0, index);
	
	if(isnumeric(keyword)) if(strlen(debugOpt[roundtoint(strval(keyword))]) > 1)
	{
	    format(string, sizeof(string), "~ You have re-added debug logs for: %s.", debugOpt[roundtoint(strval(keyword))]);
	    SCM(playerid, COLOR_YELLOW, string);
	    
 		debugOpt[roundtoint(strval(keyword))] = "";
 		return 1;
	}
	
	debugOpt[opts++] = keyword;
	
	format(string, sizeof(string), "~ Debug logs for %s will no longer be displayed in the console. (Opt ID: %d)", keyword, opts);
	SCM(playerid, COLOR_YELLOW, string);
	return 1;
}

YCMD:inventory(playerid, params[], help)
{
	#pragma unused help
	
	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[/inventory Debug]: Command called.");
	    SCL(" ", debugString);
	}

	new menuInfo[1024];
	
	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[/inventory Debug]: Variable created.");
	    SCL(" ", debugString);
	}
	
	format(menuInfo, sizeof(menuInfo), "%s", InventoryPageInfo(playerid, currentInvPage[playerid]));
	//strcat(menuInfo, InventoryPageInfo(playerid, currentInvPage[playerid]));
	
	if(serverDebug)
	{
	    format(debugString, sizeof(debugString), "[/inventory Debug]: Inventory Info: %s", menuInfo);
	    SCL(" ", debugString);
	}
	
	ShowPlayerDialog2(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Inventory:", menuInfo, "Select", "Next");
	return 1;
}

YCMD:getvowels(playerid, params[], help)
{
	#pragma unused help
	new string[128];
	if(sscanf(params, "s[128]", string)) return SEM(playerid, "Usage: /getvowels [String]");
	
	for(new i = 0; i <= strlen(string); i++) if(IsVowel(string[i])) SCM(playerid, COLOR_YELLOW, string[i]);
	return 1;
}

YCMD:respawnv(playerid, params[], help)
{
	#pragma unused help
	new string[128];
	
	if(!isnumeric(params)) return SCM(playerid, COLOR_RED, "Usage: /respawnv [Vehicle ID]");
	new vehicleid = strval(params);
	
	DestroyVehicle(vehicleid);
	return 1;
}

















