// ====================== DEFINITIONS ======================== //

#define DATA_FILE "retrying.dat"
#define DATA_PATH "data/GlobalAPI-Retrying"

// =========================================================== //

#include <GlobalAPI>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

// ...

// ======================= INCLUDES ========================== //

// ...

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Retrying-Binary",
	author = "Sikari",
	description = "",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Retrying-Binary");
}

public void GlobalAPI_Retrying_OnSaveRequest(GlobalAPIRequestData hData)
{
	// Save as binary
}

// =========================================================== //