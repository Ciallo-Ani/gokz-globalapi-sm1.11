// =========================================================== //

/*
	native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public bool GetAuthStatus(StringMap hData)
{
	if (!gB_usingAPIKey && !gB_suppressWarnings)
	{
		LogMessage("[GlobalAPI] Using the method <GetAuthStatus> requires an API key, and you dont seem to have one setup!");
		return false;
	}
 	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/auth/status", gC_baseUrl);
	hData.SetString("url", requestUrl);
	
	GlobalAPIRequest request = new GlobalAPIRequest(requestUrl, k_EHTTPMethodGET);

	if (request == null)
	{
		delete hData;
		delete request;
		return false;
	}

	request.SetData(hData);
	request.SetTimeout(5);
	request.SetAuthHeader();
	request.SetAcceptHeaders();
	request.SetPoweredByHeader();
	request.SetCallback(GetAuthStatus_DataReceived);
	request.Send();

	return true;
}

public int GetAuthStatus_DataReceived(Handle request, bool failure, int offset, int statuscode, StringMap hData)
{
	hData.SetValue("failure", failure);
	
	// Special case for timeout / failure
	if (statuscode == 0 || failure)
	{
		Handle hFwd = null;
		hData.GetValue("callback", hFwd);

		any data = INVALID_HANDLE;
		hData.GetValue("data", data);
		
		CallForward(hFwd, true, INVALID_HANDLE, hData, data);
		
		delete hFwd;
		delete hData;
	}
	
	else
	{
		SteamWorks_GetHTTPResponseBodyCallback(request, GetAuthStatus_Data, hData);
	}

	delete request;
}

public int GetAuthStatus_Data(const char[] response, StringMap hData)
{
	Handle hJson = json_decode(response);
	
	Handle hFwd = null;
	hData.GetValue("callback", hFwd);
	
	bool bFailure = false;
	hData.GetValue("failure", bFailure);
	
	any data = INVALID_HANDLE;
	hData.GetValue("data", data);

	CallForward(hFwd, bFailure, hJson, hData, data);

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //