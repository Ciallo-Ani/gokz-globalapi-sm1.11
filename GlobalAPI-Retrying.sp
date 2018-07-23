// ====================== DEFINITIONS ======================== //

// ...

// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-Retrying>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

ArrayList gL_moduleList = null;

// ======================= INCLUDES ========================== //

#include "GlobalAPI-Retrying/misc.sp"
#include "GlobalAPI-Retrying/natives.sp"
#include "GlobalAPI-Retrying/forwards.sp"

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Retrying",
	author = "Sikari",
	description = "Retrying sub-module for GlobalAPI plugin",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Retrying");

	CreateNatives();
	CreateForwards();
}

public void OnPluginStart()
{
	gL_moduleList = new ArrayList();

	RegConsoleCmd("sm_dump_modules", DumpModules);

	CreateTimer(30.0, CheckForFailedRequests, _, TIMER_REPEAT);
}

public void OnAllPluginsLoaded()
{
	if (GlobalAPI_Retrying_GetModulesCount() == 0)
	{
		SetFailState("[GlobalAPI-Retrying] One retrying module is required!");
	}
}

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	Call_Global_OnSaveRequest(hData);
}

public Action CheckForFailedRequests(Handle timer)
{
	Call_Global_OnCheckRequests();
}

// =========================================================== //