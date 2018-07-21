// ====================== DEFINITIONS ======================== //

#define CONFIG_PATH "sourcemod/GlobalAPI"
#define SETTING_DIR "cfg/sourcemod/GlobalAPI"
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI/GlobalAPI-key.cfg"

// =========================================================== //

#include <sourcemod>
#include <SteamWorks>

#include <GlobalAPI>
#include <GlobalAPI/request>
#include <GlobalAPI/requestdata>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

// Plugin
bool gB_usingAPIKey = false;
char gC_apiKey[GlobalAPI_Max_APIKey_Length];
char gC_baseUrl[GlobalAPI_Max_BaseUrl_Length];

// ConVars
bool gB_Debug = false;
bool gB_Staging = false;

// ======================= INCLUDES ========================== //

#include "GlobalAPI/http.sp"
#include "GlobalAPI/misc.sp"
#include "GlobalAPI/convars.sp"
#include "GlobalAPI/natives.sp"
#include "GlobalAPI/forwards.sp"
#include "GlobalAPI/commands.sp"

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI",
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
	CreateConfigDir();
}

public void OnPluginStart()
{
	gB_usingAPIKey = ReadAPIKey();
	AutoExecConfig(true, "GlobalAPI", CONFIG_PATH);
}

public void OnConfigsExecuted()
{
	GetConVars();
	Call_Global_OnInitialized();
}

// =========================================================== //