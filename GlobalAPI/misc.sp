// =========================================================== //

public bool ReadAPIKey()
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
			LogError("[GlobalAPI] Cannot read API key!");
			APIKey.Close();

			return false;
		}
	}
	
	LogError("[GlobalAPI] %s does not exist!", APIKEY_PATH);
	return false;
}

// =========================================================== //

public void CreateDataDir()
{
	if (!CreateDirectoryIfNotExist(DATA_DIR))
	{
		SetFailState("[GlobalAPI] Failed to create directory %s", SETTING_DIR);
	}
}

public void CreateConfigDir()
{
	if (!CreateDirectoryIfNotExist(SETTING_DIR))
	{
		SetFailState("[GlobalAPI] Failed to create directory %s", SETTING_DIR);
	}

	if (!FileExists(APIKEY_PATH))
	{
		File temp = OpenFile(APIKEY_PATH, "w");
		temp.Close();
	}
}

// =========================================================== //

public bool BuildAuthenticationHeader(Handle request)
{
	return SteamWorks_SetHTTPRequestHeaderValue(request, "X-ApiKey", gC_apiKey);
}

// =========================================================== //

public bool SendRequest(Handle request, GlobalAPIRequestData hData)
{
	Call_Private_OnHTTPStart(request, hData);
	return SteamWorks_SendHTTPRequest(request);
}

// =========================================================== //

public bool SendRequestEx(GlobalAPIRequestData hData)
{
	if (hData.requestType == GlobalAPIRequestType_GET)
	{
		return HTTPGet(hData);
	}
	else
	{
		return HTTPPost(hData);
	}
}

// =========================================================== //

// This could be failure, or just success with no response body
// We do not care. We call the forward with data as null anyways
public void CallForward_NoResponse(GlobalAPIRequestData hData)
{
	any data = hData.data;
	Handle hFwd = hData.callback;
	bool bFailure = hData.failure;

	if (hFwd != null) CallForward(hFwd, bFailure, null, hData, data);

	// Cleanup
	if (hData != null) hData.Cleanup();

	delete hFwd;
	delete hData;
}

// =========================================================== //

public Handle CreateForwardHandle(Function callback, any data)
{
	Handle hFwd = INVALID_HANDLE;
	
	if (callback != INVALID_FUNCTION)
	{
			PrintDebugMessage("Created a forward");
			// bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData, any data
			hFwd = CreateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	}
	
	return hFwd;
}

// =========================================================== //

public void AddToForwardEx(Handle hFwd, Handle plugin, Function callback)
{
	if (hFwd != INVALID_HANDLE && plugin != INVALID_HANDLE && callback != INVALID_FUNCTION)
	{
		AddToForward(hFwd, plugin, callback);
	}
}

// =========================================================== //

public void CallForward(Handle hFwd, bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData, any data)
{
	if (hFwd != INVALID_HANDLE)
	{
		PrintDebugMessage("Called a forward");
		// bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData, any data
		Call_StartForward(hFwd);
		Call_PushCell(bFailure);
		Call_PushCell(hJson);
		Call_PushCell(hData);
		Call_PushCell(data);
		Call_Finish();
	}
}

// =========================================================== //

public void PrintInfoHeaderToConsole(int client)
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
	PrintToConsole(client, "-- Logging:   \t\t %s", GlobalAPI_Logging_GetModuleCount() > 0 ? "Y" : "N");
	PrintToConsole(client, "-- Retrying:  \t\t %s", GlobalAPI_Retrying_GetModuleCount() > 0 ? "Y" : "N");
}

// =========================================================== //

public void PrintLoggingModulesToConsole(int client)
{
	int moduleCount = GlobalAPI_Logging_GetModuleCount();

	if (moduleCount <= 0)
	{
		PrintToConsole(client, "-- Logging Module: \t None");
		return;
	}

	for (int i = 0; i < moduleCount; i++)
	{
		Handle module = g_loggingModules.Get(i);

		char pluginName[GlobalAPI_Max_PluginName_Length];
		strcopy(pluginName, sizeof(pluginName), GetPluginDisplayName(module));

		PrintToConsole(client, "-- Logging Module: \t %s", pluginName);
		delete module;
	}
}

// =========================================================== //

public void PrintRetryingModulesToConsole(int client)
{
	int moduleCount = GlobalAPI_Retrying_GetModuleCount();

	if (moduleCount <= 0)
	{
		PrintToConsole(client, "-- Retrying Module: \t None");
		return;
	}

	for (int i = 0; i < moduleCount; i++)
	{
		Handle module = g_retryingModules.Get(i);

		char pluginName[GlobalAPI_Max_PluginName_Length];
		strcopy(pluginName, sizeof(pluginName), GetPluginDisplayName(module));

		PrintToConsole(client, "-- Retrying Module: \t %s", pluginName);
		delete module;
	}
}

// =========================================================== //

public void PrintMapInfoToConsole(int client)
{
	PrintToConsole(client, "-- Map Name: \t\t %s", gC_mapName);
	PrintToConsole(client, "-- Map Path: \t\t %s", gC_mapPath);
	PrintToConsole(client, "-- Map Size: \t\t %d", gI_mapFilesize);
}

// =========================================================== //

public int CalculateResponseTime(GlobalAPIRequestData hData)
{
	float timeNow = GetEngineTime();
	float startTime = hData.GetFloat("_requestStartTime");

	// Remove temporary key
	hData.Remove("_requestStartTime");

	return RoundFloat((timeNow - startTime) * 1000);
}

// =========================================================== //

public void PrintDebugMessage(char[] message)
{
	if (gB_Debug)
	{
		LogMessage(message);
	}
}

// =========================================================== //
