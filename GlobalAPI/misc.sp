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

public bool SendRequest(Handle request)
{
	return SteamWorks_SendHTTPRequest(request);
}

// =========================================================== //

public bool BuildAuthenticationHeader(Handle request)
{
	return SteamWorks_SetHTTPRequestHeaderValue(request, "X-ApiKey", gC_apiKey);
}

// =========================================================== //

public Handle CreateForwardHandle(Function callback, any data)
{
	Handle hFwd = INVALID_HANDLE;
	
	if (callback != INVALID_FUNCTION)
	{
		if (data == INVALID_HANDLE)
		{
			PrintToServer("Created a normal forward");
			// bool bFailure, Handle hJson, StringMap hData
			hFwd = CreateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
		}
		
		else
		{
			PrintToServer("Created a forward with data");
			// bool bFailure, Handle hJson, StringMap hData, any data
			hFwd = CreateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
		}
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

public void CallForward(Handle hFwd, bool bFailure, Handle hJson, StringMap hData, any data)
{
	if (hFwd != INVALID_HANDLE)
	{
		if (data == INVALID_HANDLE)
		{
			PrintToServer("Called a normal forward");
			// bool bFailure, Handle hJson
			Call_StartForward(hFwd);
			Call_PushCell(bFailure);
			Call_PushCell(hJson);
			Call_PushCell(hData);
			Call_Finish();
		}
		
		else
		{
			PrintToServer("Called a forward with data");
			// bool bFailure, Handle hJson, any data
			Call_StartForward(hFwd);
			Call_PushCell(bFailure);
			Call_PushCell(hJson);
			Call_PushCell(hData);
			Call_PushCell(data);
			Call_Finish();
		}
	}
}

// =========================================================== //