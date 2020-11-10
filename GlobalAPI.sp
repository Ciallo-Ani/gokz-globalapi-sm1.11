// ====================== DEFINITIONS ======================== //

#define PLUGIN_NAME "GlobalAPI"
#define PLUGIN_AUTHOR "Sikari"

#define DATA_DIR "data/GlobalAPI"
#define CONFIG_DIR "sourcemod/GlobalAPI"
 
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI/GlobalAPI-key.cfg"

// =========================================================== //

#include <sourcemod>
#include <SteamWorks>

#include <GlobalAPI>
#include <GlobalAPI/request>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_IsInit = false;

bool gB_usingAPIKey = false;
char gC_apiKey[GlobalAPI_Max_APIKey_Length];
char gC_baseUrl[GlobalAPI_Max_BaseUrl_Length];

char gC_MetamodVersion[32];
char gC_SourcemodVersion[32];

char gC_mapName[64];
char gC_mapPath[PLATFORM_MAX_PATH];
int gI_mapFilesize = -1;

// ======================= INCLUDES ========================== //

#include "GlobalAPI/api/convars.sp"
#include "GlobalAPI/api/natives.sp"
#include "GlobalAPI/api/forwards.sp"

#include "GlobalAPI/misc.sp"
#include "GlobalAPI/commands.sp"

#include "GlobalAPI/method/get.sp"
#include "GlobalAPI/method/post.sp"

#include "GlobalAPI/http/HTTPData.sp"
#include "GlobalAPI/http/HTTPHeaders.sp"
#include "GlobalAPI/http/HTTPStarted.sp"
#include "GlobalAPI/http/HTTPCompleted.sp"
#include "GlobalAPI/http/HTTPDataReceived.sp"

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = GlobalAPI_Plugin_Desc,
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary(PLUGIN_NAME);

	CreateConvars();
	CreateNatives();
	CreateForwards();
	CreateCommands();

	CreateDataDir();
	CreateConfigDir();
}

public void OnPluginStart()
{
	ConVar metamodCvar = FindConVar("metamod_version");
	metamodCvar.GetString(gC_MetamodVersion, sizeof(gC_MetamodVersion));

	ConVar sourcemodCvar = FindConVar("sourcemod_Version");
	sourcemodCvar.GetString(gC_SourcemodVersion, sizeof(gC_SourcemodVersion));

	gB_usingAPIKey = ReadAPIKey();
	AutoExecConfig(true, PLUGIN_NAME, CONFIG_DIR);
}

public void OnMapStart()
{
	GetMapDisplay(gC_mapName, sizeof(gC_mapName));
	GetMapFullPath(gC_mapPath, sizeof(gC_mapPath));
	gI_mapFilesize = FileSize(gC_mapPath);
}

public void OnConfigsExecuted()
{
	Initialize();

	gB_IsInit = true;
	Call_Global_OnInitialized();
}

// =========================================================== //

public void GlobalAPI_OnRequestStarted(Handle request, GlobalAPIRequestData hData)
{
	char requestUrl[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", requestUrl, sizeof(requestUrl));

	GlobalAPI_DebugMessage("HTTP Request to \"%s\" started!", requestUrl);
}

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	char requestUrl[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", requestUrl, sizeof(requestUrl));
	
	GlobalAPI_DebugMessage("HTTP Request to \"%s\" failed! - Status: %d", requestUrl, hData.Status);
}

public void GlobalAPI_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
	char requestUrl[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", requestUrl, sizeof(requestUrl));
	
	GlobalAPI_DebugMessage("HTTP Request to \"%s\" completed! - Status: %d", requestUrl, hData.Status);
}

// =========================================================== //