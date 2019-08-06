// =========================================================== //

#include <sourcemod>

#include <GlobalAPI>
#include <GlobalAPI/responses>

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
	
	LogMessage("Attempting to get status for %s", apiKey);
	GlobalAPI_GetAuthStatus(OnAuth);
}

public void OnAuth(JSON_Object hAuth, GlobalAPIRequestData hData)
{
	if (hData.Failure == false)
	{
		APIAuth status = new APIAuth(hAuth);
	
		char serverType[30];
		status.GetType(serverType, sizeof(serverType));

		LogMessage("ID: %d", status.Identity);
		LogMessage("Type: %s", serverType);
		LogMessage("Validated: %s", status.IsValid ? "YES" : "NO");
	}
	else
	{
		LogMessage("Failure during HTTP Request!");
	}

	GlobalAPI_DebugMessage("<Get Auth Status> executed in %d ms - status: %d", hData.ResponseTime, hData.Status);
}

// =========================================================== //