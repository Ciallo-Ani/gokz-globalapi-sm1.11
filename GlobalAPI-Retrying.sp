// ====================== DEFINITIONS ======================== //

#define CONFIG_NAME "GlobalAPI-Retrying"
#define CONFIG_PATH "sourcemod/GlobalAPI"

#define DATA_FILE "retrying.dat"
#define DATA_PATH "data/GlobalAPI-Retrying"

// =========================================================== //

#include <GlobalAPI>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

// ...

// ======================= INCLUDES ========================== //

#include "GlobalAPI-Retrying/convars.sp"
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

	//CreateConvars();
	//CreateForwards();
}

public void OnPluginStart()
{
	AutoExecConfig(true, CONFIG_NAME, CONFIG_PATH);
}

// =========================================================== //