// =========================================================== //

#include <sourcemod>

#include <GlobalAPI>
#include <GlobalAPI/helpers/players>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
    name = "GlobalAPI-Banchecker",
    author = "Sikari",
    description = "Checks banned players via GlobalAPI",
    version = "1.0.0",
    url = ""
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{	
	RegPluginLibrary("GlobalAPI-Banchecker");
}

public void OnClientAuthorized(int client, const char[] auth)
{
	GlobalAPI_GetPlayerBySteamId(OnPlayer, GetClientUserId(client), auth);
}

public void OnPlayer(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData, int userid)
{
	if (!bFailure)
	{
		APIPlayer player = new APIPlayer(hResponse);
		PrintToServer("%s", player.isBanned ? "YES" : "NO");

		if (player.isBanned)
		{
			int client = GetClientOfUserId(userid);
			KickClient(client, "[GlobalAPI] You're globally banned!");
		}
	}
}

// =========================================================== //