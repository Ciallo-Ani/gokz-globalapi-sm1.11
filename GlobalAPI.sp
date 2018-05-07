// ====================== DEFINITIONS ======================== //

#define MAX_APIKEY_LENGTH 128
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI-key.cfg"

#define MAX_QUERYPARAM_NUM 20
#define MAX_QUERYURL_LENGTH 2048
#define MAX_QUERYPARAM_LENGTH 64

// =========================================================== //

#include <sourcemod>
#include <smjansson>
#include <SteamWorks>

#include <GlobalAPI>
#include <GlobalAPI/body>
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

#include "GlobalAPI/methods/auth.sp"
#include "GlobalAPI/methods/bans.sp"
#include "GlobalAPI/methods/jumpstats.sp"

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
	//CreateCommands(); // Create Commands
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
	GlobalAPI_GetJumpstats(OnJumpstats, 69, .steamId = "STEAM_1:1:21505111", .jumpType = "longjump");
}

public void OnJumpstats(bool bFailure, Handle hJumps, any data)
{
	PrintToServer("Callback received data: %d", data);
	
	if (!bFailure)
	{
		APIJumpstats jumps = new APIJumpstats(hJumps);
		PrintToServer("Found %d jumps!", jumps.Count);
	}
	
	else
	{
		PrintToServer("<OnJumpstats> Failure occured during HTTP request!");
	}
}

// ================== GLOBAL HTTP CALLBACKS ================== //

public int HTTPHeaders(Handle request, bool failure, any data, any data2)
{
	PrintToServer("HTTP Headers received");
}

public int HTTPCompleted(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statusCode, any data, any data2)
{
	PrintToServer("HTTP Request completed");
	PrintToServer("Stringmaps are cool, you have all of these available!");
	
	APICommonHelper common = new APICommonHelper(data);
	common.DumpProperties();
}

// =========================================================== //

