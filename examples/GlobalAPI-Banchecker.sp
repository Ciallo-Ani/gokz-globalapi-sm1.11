// =========================================================== //

#include <sourcemod>

#include <GlobalAPI>
#include <GlobalAPI/responses>

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

public void OnPlayer(JSON_Object hResponse, GlobalAPIRequestData hData, int userid)
{
	if (hData.failure == false)
	{
		int client = GetClientOfUserId(userid);
		APIPlayer player = new APIPlayer(hResponse);
		
		char steamId[32];
		GetClientAuthId(client, AuthId_Steam2, steamId, sizeof(steamId));
		
		LogMessage("%s is %s", steamId, player.isBanned ? "banned" : "not banned");

		if (player.isBanned)
		{
			KickClient(client, "[GlobalAPI] You're globally banned!");
		}
	}
}

// =========================================================== //