stock InitializeLoginOption(playerid)
{
	new string[32];
	if(registered[playerid]) string = "Login";
	else string = "Register";

	login_option = CreatePlayerTextDraw(playerid, 550.0, 25.0, string);
	
	PlayerTextDrawAlignment(playerid, login_option, 2);
	PlayerTextDrawTextSize(playerid, login_option, 30.0, 125.0);
	PlayerTextDrawUseBox(playerid, login_option, 1);
	PlayerTextDrawBoxColor(playerid, login_option, COLOR_BLACK);
	PlayerTextDrawLetterSize(playerid, login_option, 0.844, 2.11);
	PlayerTextDrawColor(playerid, login_option, COLOR_WHITE);
	PlayerTextDrawSetSelectable(playerid, login_option, 1);
}

stock InitializeMultiplayerOption()
{
	multiplayer_option = TextDrawCreate(160.0, 150.0, "Multiplayer");

	TextDrawAlignment(multiplayer_option, 2);
	TextDrawTextSize(multiplayer_option, 30.0, 265.0);
	TextDrawUseBox(multiplayer_option, 1);
	TextDrawBoxColor(multiplayer_option, COLOR_BLACK);
	TextDrawLetterSize(multiplayer_option, 1.5, 3.75);
	TextDrawColor(multiplayer_option, COLOR_WHITE);
	TextDrawSetSelectable(multiplayer_option, 1);
}

stock InitializeLoadoutOption()
{
	loadout_option = TextDrawCreate(140.0, 185.0, "Loadout");

	TextDrawAlignment(loadout_option, 2);
	TextDrawTextSize(loadout_option, 30.0, 200.0);
	TextDrawUseBox(loadout_option, 1);
	TextDrawBoxColor(loadout_option, COLOR_BLACK);
	TextDrawLetterSize(loadout_option, 1.5, 3.75);
	TextDrawColor(loadout_option, COLOR_WHITE);
	TextDrawSetSelectable(loadout_option, 1);
}

stock InitializeMenu()
{
	black_background = TextDrawCreate(0.0, 0.0, "Initialize Text");

	TextDrawUseBox(black_background, 1);
	TextDrawTextSize(black_background, 1000.0, 1000.0);
	TextDrawLetterSize(black_background, 500.0, 500.0);
	TextDrawColor(black_background, COLOR_WHITE);
	TextDrawBoxColor(black_background, COLOR_BLACK);
	TextDrawBackgroundColor(black_background, COLOR_BLACK);

	InitializeMultiplayerOption();
	InitializeLoadoutOption();
}

stock ShowPlayerGameMenu(playerid)
{
	TextDrawShowForPlayer(playerid, black_background);
	TextDrawShowForPlayer(playerid, multiplayer_option);
	TextDrawShowForPlayer(playerid, loadout_option);
	
	PlayerTextDrawShow(playerid, login_option);
}
