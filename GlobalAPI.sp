// ====================== DEFINITIONS ======================== //

#define DATA_DIR "data/sourcemod/GlobalAPI"
#define SETTING_DIR "cfg/sourcemod/GlobalAPI"
 
#define CONFIG_PATH "sourcemod/GlobalAPI"
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI/GlobalAPI-key.cfg"

// =========================================================== //

#include <sourcemod>
#include <SteamWorks>

#include <GlobalAPI>
#include <GlobalAPI-stocks>
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

// Modules
ArrayList g_loggingModules;
ArrayList g_retryingModules;

// ======================= INCLUDES ========================== //

#include "GlobalAPI/misc.sp"
#include "GlobalAPI/convars.sp"
#include "GlobalAPI/commands.sp"

#include "GlobalAPI/method/get.sp"
#include "GlobalAPI/method/post.sp"

#include "GlobalAPI/api/natives.sp"
#include "GlobalAPI/api/forwards.sp"

#include "GlobalAPI/module/logging.sp"
#include "GlobalAPI/module/retrying.sp"

#include "GlobalAPI/http/HTTPData.sp"
#include "GlobalAPI/http/HTTPHeaders.sp"
#include "GlobalAPI/http/HTTPStarted.sp"
#include "GlobalAPI/http/HTTPCompleted.sp"
#include "GlobalAPI/http/HTTPDataReceived.sp"

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

// TODO: Add late loading support
public void OnPluginStart()
{
	g_loggingModules = new ArrayList();
	g_retryingModules = new ArrayList();

	gB_usingAPIKey = ReadAPIKey();
	AutoExecConfig(true, "GlobalAPI", CONFIG_PATH);
}

public void OnConfigsExecuted()
{
	GetConVars();
	Call_Global_OnInitialized();
}

// =========================================================== //