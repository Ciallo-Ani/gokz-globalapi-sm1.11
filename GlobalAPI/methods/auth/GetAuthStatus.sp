// =========================================================== //

/*
	native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public bool GetAuthStatus(GlobalAPIRequestParams hData)
{
	if (!gB_usingAPIKey && !gB_suppressWarnings)
	{
		LogMessage("[GlobalAPI] Using the method <GetAuthStatus> requires an API key, and you dont seem to have one setup!");
		return false;
	}
 	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/auth/status", gC_baseUrl);
	hData.AddUrl(requestUrl);
	
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

public int GetAuthStatus_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestParams hData)
{
	// Special case for timeout / failure
	if (statuscode == 0 || failure || statuscode == 500)
	{
		hData.AddFailure(true);

		any data = hData.GetInt("data");
		Handle hFwd = hData.GetHandle("callback");
		
		CallForward(hFwd, true, INVALID_HANDLE, hData, data);
		
		delete hFwd;
		delete hData;
	}
	
	else
	{
		hData.AddFailure(false);
		SteamWorks_GetHTTPResponseBodyCallback(request, GetAuthStatus_Data, hData);
	}

	delete request;
}

public int GetAuthStatus_Data(const char[] response, GlobalAPIRequestParams hData)
{
	Handle hJson = json_decode(response);
	
	any data = hData.GetInt("data");
	bool bFailure = hData.GetBool("failure");
	Handle hFwd = hData.GetHandle("callback");

	CallForward(hFwd, bFailure, hJson, hData, data);

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //