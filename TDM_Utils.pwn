#define FILTERSCRIPT

#include <a_samp>
#include <EUL\Utils\eColors>
#include <EUL\Utils\eUtilities>
#include <YSI\y_commands>
#include <YSI\y_hooks>
#include <YSI\y_ini>

#define MAX_STRING 255

#define VEH_FILE "vehicles/Vehicles/%d.ini"

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

enum veh_data
{
	VEH_ID,
	Float:VEH_X,
	Float:VEH_Y,
	Float:VEH_Z,
	Float:VEH_ROT
}

new vehicle_data[MAX_VEHICLES][veh_data];

forward LoadVehicleData(vehicleid, name[], value[]);

public LoadVehicleData(vehicleid, name[], value[])
{
	INI_Int("ID", vehicle_data[vehicleid][VEH_ID]);
	INI_Float("X", vehicle_data[vehicleid][VEH_X]);
	INI_Float("Y", vehicle_data[vehicleid][VEH_Y]);
	INI_Float("Z", vehicle_data[vehicleid][VEH_Z]);
	return 1;
}

YCMD:nudge(playerid, params[], help)
{
	#pragma unused help
	new param[MAX_STRING], index, params_loaded;
	new vehicleid, Float:X, Float:Y, Float:Z;
	new bool:failed, bool:negative = false;
	
	do
	{
		param = strtok(params, index);
		
		printf("Param #%d: %s", params_loaded, param);
		
		if(param[0] == '-')
		{
		    strdel(param, 0, 1);
		    negative = true;
		}
	
	    if(!isnumeric(param))
		{
			failed = true;
			printf("%s is not numeric!");
		}
		
		if(vehicleid == 0)
		{
	 		if(!isstrwholenumber(param))
	 		{
			 	failed = true;
			 	printf("%s is not whole.");
			}
			vehicleid = strval(param);
		}
		else
		{
		    switch(params_loaded)
		    {
		        case 1:
				{
					X = floatstr(param);
					if(negative) X = (0 - X);
				}
				case 2:
				{
					Y = floatstr(param);
					if(negative) Y = (0 - Y);
				}
				case 3:
				{
					Z = floatstr(param);
					if(negative) Z = (0 - Z);
				}
				default:
				{
				    failed = true;
				    print("Default called");
				    break;
				}
			}
		}
		
		params_loaded++;
		
		if(failed) return SCM(playerid, COLOR_RED, "Usage: /nudge [Vehicle ID] [X] [Y] [Z]");
		strdel(param, 0, strlen(param));
	}
	while(params_loaded < 4);
	
	new Float:vX, Float:vY, Float:vZ;
	GetVehiclePos(vehicleid, vX, vY, vZ);
	
	printf("[Nudge]: %d, %f, %f, %f", vehicleid, X, Y, Z);
	
	X += vX;
	Y += vY;
	Z += vZ;
	
	printf("[Nudge #2]: %d, %f, %f, %f", vehicleid, X, Y, Z);
	
	SetVehiclePos(vehicleid, X, Y, Z);
	return 1;
}
	
YCMD:savevehicles(playerid, params[], help)
{
	#pragma unused params
	#pragma unused help
	
	for(new i = 0; i <= MAX_VEHICLES; i++)
	{
	    new Float:X, Float:Y, Float:Z;
	    if(GetVehiclePos(i, X, Y, Z) == 0) continue;
	    new Float:Rot, model;
	    GetVehicleZAngle(i, Rot);
	    model = GetVehicleModel(i);
	    
		new file_name[64];
		format(file_name, sizeof(file_name), VEH_FILE, i);
		
		new INI:file_handle = INI_Open(file_name);
		
		INI_WriteInt(file_handle, "ID", model);
		
		INI_WriteFloat(file_handle, "X", X);
		INI_WriteFloat(file_handle, "Y", Y);
		INI_WriteFloat(file_handle, "Z", Z);
		INI_WriteFloat(file_handle, "Rot", Rot);
		
		INI_Close(file_handle);
	}
	
	SCM(playerid, COLOR_YELLOW, "~ Vehicles saved");
	return 1;
}
		










	
	
	
	
	
	
