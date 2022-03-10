bool ReadAPIKey()
{
	if (!FileExists(APIKEY_PATH))
	{
		LogError("File '%s' does not exist!", APIKEY_PATH);
		return false;
	}

	File file = OpenFile(APIKEY_PATH, "r");
	if (file == null)
	{
		LogError("Cannot read API key from '%s'!", APIKEY_PATH);
		return false;
	}

	file.ReadLine(gC_apiKey, sizeof(gC_apiKey));
	delete file;

	TrimString(gC_apiKey);
	return !StrEqual(gC_apiKey, "");
}

void Initialize()
{
	gC_baseUrl = gCV_Staging.BoolValue ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl;

	gB_IsInit = true;
	Call_Global_OnInitialized();
}

bool FormatRequestUrl(char[] buffer, int maxlength, char[] endpoint)
{
	return Format(buffer, maxlength, "%s/%s", gC_baseUrl, endpoint) > 0;
}

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

// This could be failure, or just success with no response body
// We do not care. We call the forward with data as null anyways
void CallForward_NoResponse(GlobalAPIRequestData hData)
{
	any data = hData.Data;
	Handle hFwd = hData.Callback;

	CallForward(hFwd, null, hData, data);

	// Cleanup
	if (hData != null)
	{
		hData.Cleanup();
	}

	delete hFwd;
	delete hData;
}

GlobalAPIRequestData CreateRequestData(Handle plugin, Function callback, any data)
{
	GlobalAPIRequestData hData = new GlobalAPIRequestData(plugin);

	if (callback != INVALID_FUNCTION)
	{
		Handle hFwd = CreateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
		AddToForward(hFwd, plugin, callback);

		hData.Callback = hFwd;
	}

	hData.Data = data;
	return hData;
}

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
