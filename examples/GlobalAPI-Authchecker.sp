// =========================================================== //

#include <sourcemod>

#include <GlobalAPI>
#include <GlobalAPI/helpers>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

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
	RegPluginLibrary("GlobalAPI-Authchecker");
	RegAdminCmd("sm_globalapi_authcheck", Command_AuthCheck, ADMFLAG_ROOT);
}

public Action Command_AuthCheck(int client, int args)
{
	char apiKey[GlobalAPI_Max_APIKey_Length];
	GlobalAPI_GetAPIKey(apiKey, sizeof(apiKey));

	int numberOfRemainingChars = strlen(apiKey) - 5;
	FormatEx(apiKey, sizeof(apiKey), "%.5s", apiKey);
	
	while (numberOfRemainingChars--) StrCat(apiKey, sizeof(apiKey), "X");
	
	PrintToServer("[GlobalAPI Auth] Attempting to get status for %s", apiKey);
	GlobalAPI_GetAuthStatus(OnAuth);
}

public void OnAuth(JSON_Object hAuth, GlobalAPIRequestData hData)
{
	if (hData.failure == false)
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
}

// =========================================================== //