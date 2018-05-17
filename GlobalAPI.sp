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
#include <GlobalAPI/params>
#include <GlobalAPI/request>
#include <GlobalAPI/helpers>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_usingAPIKey = false;

char gC_baseUrl[64];
char gC_apiKey[MAX_APIKEY_LENGTH];

bool gB_suppressWarnings = false;

// ======================= INCLUDES ========================== //

#include "GlobalAPI/misc.sp"
#include "GlobalAPI/convars.sp"
#include "GlobalAPI/natives.sp"
#include "GlobalAPI/forwards.sp"
#include "GlobalAPI/commands.sp"

#include "GlobalAPI/methods/auth.sp"
#include "GlobalAPI/methods/bans.sp"
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
	GlobalAPI_GetJumpstatTop30(OnJumps, _, "longjump");
}

public void OnJumps(bool bFailure, JSON_Object hJson, GlobalAPIRequestParams hData)
{
	APICommonHelper helper = new APICommonHelper(hData);
	helper.DumpProperties();
}

// ================== GLOBAL HTTP CALLBACKS ================== //

public int HTTPHeaders(Handle request, bool failure, GlobalAPIRequestParams hData)
{
	PrintToServer("HTTP Headers received");
}

public int HTTPCompleted(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statusCode, GlobalAPIRequestParams hData)
{
	PrintToServer("HTTP Request completed");
}

// =========================================================== //

