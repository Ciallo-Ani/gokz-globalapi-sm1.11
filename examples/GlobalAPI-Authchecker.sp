// ====================== DEFINITIONS ======================== //

//...

// =========================================================== //

#include <sourcemod>

#include <GlobalAPI>
#include <GlobalAPI/helpers/auth>
#include <GlobalAPI/helpers/common>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

//...

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
    name = "GlobalAPI-AuthStatus",
    author = "Sikari",
    description = "Auth checker using GlobalAPI plugin",
    version = "1.0.0",
    url = ""
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{	
	RegPluginLibrary("GlobalAPI-AuthChecker");
	RegConsoleCmd("sm_globalapi_authcheck", Command_AuthCheck);
}

public Action Command_AuthCheck(int client, int args)
{
	char apiKey[128];
	GlobalAPI_GetAPIKey(apiKey, sizeof(apiKey));

	int numberOfRemainingChars = strlen(apiKey) - 5;
	FormatEx(apiKey, sizeof(apiKey), "%.5s", apiKey);
	
	while (numberOfRemainingChars--) StrCat(apiKey, sizeof(apiKey), "X");
	
	PrintToServer("[GlobalAPI Auth] Attempting to get status for %s", apiKey);
	GlobalAPI_GetAuthStatus(OnAuth);
}

public void OnAuth(bool bFailure, JSON_Object hAuth, GlobalAPIRequestData hData)
{
	if (!bFailure)
	{
		APIAuthStatus status = new APIAuthStatus(hAuth);
	
		char serverType[30];
		status.GetType(serverType, sizeof(serverType));

		PrintToServer("[GlobalAPI Auth] Server ID: %d", status.identity);
		PrintToServer("[GlobalAPI Auth] Server Type: %s", serverType);
		PrintToServer("[GlobalAPI Auth] Validated: %s", status.isValid ? "YES" : "NO");
	}
	
	else
	{
		PrintToServer("[GlobalAPI Auth] Failure during HTTP Request!");
	}

	APICommonHelper helper = new APICommonHelper(hData);
	helper.DumpProperties();
}

// =========================================================== //