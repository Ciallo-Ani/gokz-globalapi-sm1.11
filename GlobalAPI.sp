// ====================== DEFINITIONS ======================== //

#define DATA_DIR "data/GlobalAPI"
#define CONFIG_DIR "cfg/sourcemod/GlobalAPI"

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

#include "GlobalAPI/http/get.sp"
#include "GlobalAPI/http/post.sp"
#include "GlobalAPI/http/forwards.sp"

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo =
{
	name = "GlobalAPI",
	author = "The KZ Global Team",
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

    char dataDir[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, dataDir, sizeof(dataDir), "%s", DATA_DIR);

    TryCreateDirectory(dataDir);
    TryCreateDirectory(CONFIG_DIR);

    // TODO: Create empty apikey file?
}

public void OnPluginStart()
{
	ConVar metamodCvar = FindConVar("metamod_version");
	metamodCvar.GetString(gC_MetamodVersion, sizeof(gC_MetamodVersion));

	ConVar sourcemodCvar = FindConVar("sourcemod_Version");
	sourcemodCvar.GetString(gC_SourcemodVersion, sizeof(gC_SourcemodVersion));

	gB_usingAPIKey = ReadAPIKey();
	AutoExecConfig(true, "GlobalAPI", "sourcemod/GlobalAPI");
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
}

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
