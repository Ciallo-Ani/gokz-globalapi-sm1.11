// ====================== DEFINITIONS ======================== //

// NOTE: Should all the GET/POST methods be made into a single one?
// I think we can build the url in the native and pass it on requestdata

// NOTE: Maybe we could also make the iterating methodmaps a single one too
// EX: APIBans, APIPlayers, APIModes... they all serve same usage

#define MAX_BASEURL_LENGTH 64
#define MAX_APIKEY_LENGTH 128
#define APIKEY_PATH "cfg/sourcemod/GlobalAPI-key.cfg"
#define CONFIG_PATH "GlobalAPI-conf" // .cfg is implied

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

// Datasets
#include "GlobalAPI/methods/auth.sp"
#include "GlobalAPI/methods/bans.sp"
#include "GlobalAPI/methods/maps.sp"
#include "GlobalAPI/methods/modes.sp"
#include "GlobalAPI/methods/players.sp"
#include "GlobalAPI/methods/records.sp"
#include "GlobalAPI/methods/servers.sp"
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
	AutoExecConfig(true, CONFIG_PATH);
}

public void OnConfigsExecuted()
{
	GetConvars();
	Call_Global_OnInitialized();
}

public void GlobalAPI_OnInitialized()
{
	GlobalAPI_GetServersByName(OnServer, _, "KZ");
}

public void OnServer(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData)
{
	APIServers servers = new APIServers(hResponse);
	APIServer server = new APIServer(servers.GetById(0));

	char name[128];
	server.GetName(name, sizeof(name));

	PrintToServer("Server: \"%s\"", name);
}

// =========================================================== //