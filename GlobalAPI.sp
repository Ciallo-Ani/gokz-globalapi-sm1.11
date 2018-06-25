// ====================== DEFINITIONS ======================== //

#define MAX_BASEURL_LENGTH 64
#define MAX_APIKEY_LENGTH 128

#define CONFIG_PATH "sourcemod/GlobalAPI"
#define SETTING_DIR "cfg/sourcemod/GlobalAPI"
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI/GlobalAPI-key.cfg"

#define MAX_QUERYPARAM_NUM 20
#define MAX_QUERYURL_LENGTH 2048
#define MAX_QUERYPARAM_LENGTH 64

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
char gC_apiKey[MAX_APIKEY_LENGTH];
char gC_baseUrl[MAX_BASEURL_LENGTH];

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
	GetConvars();
	Call_Global_OnInitialized();
}

// =========================================================== //