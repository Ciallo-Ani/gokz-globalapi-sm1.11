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

public void CreateConfigDir()
{
	if (!DirExists(SETTING_DIR)) CreateDirectory(SETTING_DIR, 666);

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

public bool StartRequest(Handle request, GlobalAPIRequestData hData)
{
	Call_Private_OnHTTPStart(request, hData);
	return SteamWorks_SendHTTPRequest(request);
}

// =========================================================== //

public bool SendRequest(GlobalAPIRequestData hData)
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

	if (hFwd != INVALID_HANDLE)
	{
		CallForward(hFwd, bFailure, null, hData, data);
	}

	// Cleanup
	if (hData != INVALID_HANDLE) hData.Cleanup();

	delete hFwd;
	delete hData;
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
			// bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData
			hFwd = CreateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
		}
		
		else
		{
			PrintToServer("Created a forward with data");
			// bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData, any data
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

public void CallForward(Handle hFwd, bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData, any data)
{
	if (hFwd != INVALID_HANDLE)
	{
		if (data == INVALID_HANDLE)
		{
			PrintToServer("Called a normal forward");
			// bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData
			Call_StartForward(hFwd);
			Call_PushCell(bFailure);
			Call_PushCell(hJson);
			Call_PushCell(hData);
			Call_Finish();
		}
		else
		{
			PrintToServer("Called a forward with data");
			// bool bFailure, JSON_Object hJson, GlobalAPIRequestData hData, any data
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