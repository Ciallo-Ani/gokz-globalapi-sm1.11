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
	GlobalAPI_GetModeByName(OnMode, _, "kz_timer");
}

public void OnMode(bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData)
{
	APIMode mode = new APIMode(hJson);

	char modeName[64];
	mode.GetName(modeName, sizeof(modeName));

	char description[64];
	mode.GetDescription(description, sizeof(description));

	PrintToServer("Mode: %s", modeName);
	PrintToServer("Description: %s", description);
	PrintToServer("Latest Version: %d", mode.latestVersion);
}

// =========================================================== //