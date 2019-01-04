// =========================================================== //

bool ReadAPIKey()
{
	if (FileExists(APIKEY_PATH))
	{
		File APIKey = OpenFile(APIKEY_PATH, "r");

		if (APIKey != null)
		{
			APIKey.ReadLine(gC_apiKey, sizeof(gC_apiKey));
			TrimString(gC_apiKey);
			APIKey.Close();
				
			return !StrEqual(gC_apiKey, "");
		}
		
		else
		{
			LogError("[%s] Cannot read API key!", PLUGIN_NAME);
			APIKey.Close();

			return false;
		}
	}
	
	LogError("[%s] %s does not exist!", PLUGIN_NAME, APIKEY_PATH);
	return false;
}

// =========================================================== //

void CreateDataDir()
{
	char dataPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, dataPath, sizeof(dataPath), DATA_DIR);
	
	if (!CreateDirectoryIfNotExist(dataPath))
	{
		SetFailState("Failed to create directory %s", dataPath);
	}
}

void CreateConfigDir()
{
	char configPath[PLATFORM_MAX_PATH];
	Format(configPath, sizeof(configPath), "cfg/%s", CONFIG_DIR);
	
	if (!CreateDirectoryIfNotExist(configPath))
	{
		SetFailState("Failed to create directory %s", configPath);
	}

	if (!FileExists(APIKEY_PATH))
	{
		File temp = OpenFile(APIKEY_PATH, "w");
		temp.Close();
	}
}

// =========================================================== //

void Initialize()
{
	Format(gC_baseUrl, sizeof(gC_baseUrl), "%s", gCV_Staging.BoolValue ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl);
}

// =========================================================== //

bool BuildAuthenticationHeader(Handle request)
{
	return SteamWorks_SetHTTPRequestHeaderValue(request, "X-ApiKey", gC_apiKey);
}

// =========================================================== //

bool FormatRequestUrl(char[] buffer, int maxlength, char[] endpoint)
{
	return Format(buffer, maxlength, "%s/%s", gC_baseUrl, endpoint) > 0;
}

// =========================================================== //

void FormatPathParam(char[] buffer, int maxlength, char[] param, char[] value = "", int intValue = -1)
{
	char paramKey[128];
	Format(paramKey, sizeof(paramKey), "{%s}", param);
	
	if (intValue != -1)
	{
		char tempBuffer[64];
		IntToString(intValue, tempBuffer, sizeof(tempBuffer));
		ReplaceString(buffer, maxlength, paramKey, tempBuffer);
	}
	else
	{
		ReplaceString(buffer, maxlength, paramKey, value);
	}
}

// =========================================================== //

bool SendRequest(Handle request, GlobalAPIRequestData hData)
{
	Call_Private_OnHTTPStart(request, hData);
	return SteamWorks_SendHTTPRequest(request);
}

// =========================================================== //

bool SendRequestEx(GlobalAPIRequestData hData)
{
	switch (hData.requestType)
	{
		case GlobalAPIRequestType_GET: return HTTPGet(hData);
		case GlobalAPIRequestType_POST: return HTTPPost(hData);
	}

	return false;
}

// =========================================================== //

// This could be failure, or just success with no response body
// We do not care. We call the forward with data as null anyways
void CallForward_NoResponse(GlobalAPIRequestData hData)
{
	any data = hData.data;
	Handle hFwd = hData.callback;

	CallForward(hFwd, null, hData, data);

	// Cleanup
	if (hData != null) hData.Cleanup();

	delete hFwd;
	delete hData;
}

// =========================================================== //

Handle CreateForwardHandle(Function callback)
{
	Handle hFwd = null;
	
	if (callback != INVALID_FUNCTION)
	{
        GlobalAPI_DebugMessage("Created a forward!");
        hFwd = CreateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
    }
	
	return hFwd;
}

// =========================================================== //

void AddToForwardEx(Handle hFwd, Handle plugin, Function callback)
{
	if (hFwd != null && plugin != null && callback != INVALID_FUNCTION)
	{
		AddToForward(hFwd, plugin, callback);
	}
}

// =========================================================== //

void CallForward(Handle hFwd, JSON_Object hJson, GlobalAPIRequestData hData, any data)
{
	if (hFwd != null)
	{
		GlobalAPI_DebugMessage("Called a forward!");
		Call_StartForward(hFwd);
		Call_PushCell(hJson);
		Call_PushCell(hData);
		Call_PushCell(data);
		Call_Finish();
	}
}

// =========================================================== //

void PrintInfoHeaderToConsole(int client)
{
	char infoStr[128];
	int paddingSize = Format(infoStr, sizeof(infoStr), "[GlobalAPI Plugin v%s for backend %s]",
														GlobalAPI_Plugin_Version, GlobalAPI_Backend_Version);

	char[] padding = new char[paddingSize];
	for (int i = 0; i < paddingSize; i++) padding[i] = '-';

	PrintToConsole(client, padding);
	PrintToConsole(client, infoStr);
	PrintToConsole(client, padding);
	PrintToConsole(client, "-- Tickrate:  \t\t %d", RoundFloat(1.0 / GetTickInterval()));
	PrintToConsole(client, "-- Staging:   \t\t %s", GlobalAPI_IsStaging() ? "Y" : "N");
	PrintToConsole(client, "-- Debugging: \t\t %s", GlobalAPI_IsDebugging() ? "Y" : "N");
	PrintToConsole(client, "-- Stats:	  \t %s",   GlobalAPI_GetModuleCount(ModuleType_Stats) > 0 ? "Y" : "N");
	PrintToConsole(client, "-- Logging:   \t\t %s", GlobalAPI_GetModuleCount(ModuleType_Logging) > 0 ? "Y" : "N");
	PrintToConsole(client, "-- Retrying:  \t\t %s", GlobalAPI_GetModuleCount(ModuleType_Retrying) > 0 ? "Y" : "N");
}

// =========================================================== //

void PrintMapInfoToConsole(int client)
{
	PrintToConsole(client, "-- Map Name: \t\t %s", gC_mapName);
	PrintToConsole(client, "-- Map Path: \t\t {gamedir}/%s", gC_mapPath);
	PrintToConsole(client, "-- Map Size: \t\t %d bytes", gI_mapFilesize);
}

// =========================================================== //

int CalculateResponseTime(GlobalAPIRequestData hData)
{
	float timeNow = GetEngineTime();
	float startTime = hData.GetFloat("_requestStartTime");

	// Remove temporary key
	hData.Remove("_requestStartTime");

	return RoundFloat((timeNow - startTime) * 1000);
}

// =========================================================== //

bool DebugMessage(char[] message)
{
	if (gCV_Debug.BoolValue)
	{
		LogMessage(message);
		return true;
	}

	return false;
}

// =========================================================== //
