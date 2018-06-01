// ====================== DEFINITIONS ======================== //

#define MAX_APIKEY_LENGTH 128
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI-key.cfg"

#define MAX_QUERYPARAM_NUM 20
#define MAX_QUERYURL_LENGTH 2048
#define MAX_QUERYPARAM_LENGTH 64

// =========================================================== //

#include <sourcemod>
#include <SteamWorks>

#include <json>
#include <GlobalAPI>
#include <GlobalAPI/helpers>
#include <GlobalAPI/request>
#include <GlobalAPI/requestdata>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

// Plugin
char gC_baseUrl[64];
bool gB_usingAPIKey = false;
char gC_apiKey[MAX_APIKEY_LENGTH];

// ConVars
bool gB_Debug = false;
bool gB_Staging = false;

// ======================= INCLUDES ========================== //

// Core plugin
#include "GlobalAPI/http.sp"
#include "GlobalAPI/misc.sp"
#include "GlobalAPI/convars.sp"
#include "GlobalAPI/natives.sp"
#include "GlobalAPI/forwards.sp"
#include "GlobalAPI/commands.sp"

// Datasets
#include "GlobalAPI/methods/auth.sp"
#include "GlobalAPI/methods/bans.sp"
#include "GlobalAPI/methods/maps.sp"
#include "GlobalAPI/methods/modes.sp"
#include "GlobalAPI/methods/players.sp"
#include "GlobalAPI/methods/records.sp"
#include "GlobalAPI/methods/jumpstats.sp"

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
    name = "GlobalAPI-SMPlugin",
    author = "Sikari",
    description = GlobalAPI_Plugin_Desc,
    version = GlobalAPI_Plugin_Version,
    url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI");
	
	CreateConvars();
	CreateNatives();
	CreateForwards();
	CreateCommands();
}

public void OnPluginStart()
{
	gB_usingAPIKey = ReadAPIKey();
	AutoExecConfig(true, "GlobalAPI-conf");
}

public void OnConfigsExecuted()
{
	GetConvars();
	Call_Global_OnInitialized();
}

public void GlobalAPI_OnInitialized()
{
	GlobalAPI_GetRecords(OnRecords, .mapName = "kz_man_everest_go_fix");
}

public void OnRecords(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData)
{
	APIRecords records = new APIRecords(hResponse);
	APIRecord record = new APIRecord(records.GetById(0));

	char playerName[64];
	record.GetPlayerName(playerName, sizeof(playerName));

	char steamId[64];
	record.GetSteamId(steamId, sizeof(steamId));

	char mode[20];
	record.GetMode(mode, sizeof(mode));

	char serverName[64];
	record.GetServerName(serverName, sizeof(serverName));

	char mapName[64];
	record.GetMapName(mapName, sizeof(mapName));

	PrintToServer("Player \"%s\" (%s) completed a %s run with time %f on map \"%s\" and server \"%s\"",
					playerName, steamId, mode, record.time, mapName, serverName);
}

// =========================================================== //