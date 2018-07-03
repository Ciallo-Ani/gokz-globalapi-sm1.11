// ====================== DEFINITIONS ======================== //

#define CONFIG_NAME "GlobalAPI-Logging"
#define CONFIG_PATH "sourcemod/GlobalAPI"

#define HTTPLogs_Folder "logs/GlobalAPI"
#define HTTPFailed_LogFile "logs/GlobalAPI/failed-log.txt"
#define HTTPStarted_LogFile "logs/GlobalAPI/start-log.txt"
#define HTTPFinished_LogFile "logs/GlobalAPI/finished-log.txt"

#define MAX_URL_LENGTH 128 // BaseURL only, no params included
#define MAX_PARAMS_LENGTH 20 * 64 // 20 params * 64 param length

// =========================================================== //

#include <GlobalAPI>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

char gC_sourceModPath[PLATFORM_MAX_PATH];
char gC_HTTPFailed_LogFile[PLATFORM_MAX_PATH];
char gC_HTTPStarted_LogFile[PLATFORM_MAX_PATH];
char gC_HTTPFinished_LogFile[PLATFORM_MAX_PATH];

char gC_HTTPMethodPhrases[][] = { "GET", "POST" };

// ConVars
bool gB_LogFailed = true;
bool gB_LogStarted = false;
bool gB_LogFinished = false;

// ======================= INCLUDES ========================== //

#include "GlobalAPI-Logging/misc.sp"
#include "GlobalAPI-Logging/convars.sp"
#include "GlobalAPI-Logging/forwards.sp"
#include "GlobalAPI-Logging/logging/HTTPFailed.sp"
#include "GlobalAPI-Logging/logging/HTTPStarted.sp"
#include "GlobalAPI-Logging/logging/HTTPFinished.sp"

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Logging",
	author = "Sikari",
	description = "Logging sub-module for GlobalAPI plugin",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Logging");

	CreateConvars();
	CreateForwards();
}

public void OnPluginStart()
{
	BuildSMPath();
	BuildLogPaths();
	BuildAndCreateLogDirectory();
	
	AutoExecConfig(true, CONFIG_NAME, CONFIG_PATH);
}

public void OnConfigsExecuted()
{
	GetConVars();
}

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	if (gB_LogFailed) 
		Log_Failed_HTTPRequest(hData);
}

public void GlobalAPI_OnRequestStarted(Handle request, GlobalAPIRequestData hData)
{
	if (gB_LogStarted) 
		Log_Started_HTTPRequest(hData);
}

public void GlobalAPI_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
	if (gB_LogFinished)
		Log_Finished_HTTPRequest(hData);
}

// =========================================================== //