// =========================================================== //

/*
	native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId,
										int jumpType, float distance, char[] jumpJsonInfo, int tickRate, int mslCount,
										bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);
*/
public bool CreateJumpstat(GlobalAPIRequestParams hData)
{
	if (!gB_usingAPIKey && !gB_suppressWarnings)
	{
		LogMessage("[GlobalAPI] Using the method <CreateJumpstats> requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/jumpstats", gC_baseUrl);
	hData.AddUrl(requestUrl);
	
	char json[MAX_CREATE_JUMPSTAT_JSON_LENGTH];
	json_encode(hData, json, sizeof(json));
	
	GlobalAPIRequest request = new GlobalAPIRequest(requestUrl, k_EHTTPMethodPOST);
	
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
	request.SetBody(json, sizeof(json));
	request.SetCallback(CreateJumpstat_DataReceived);
	request.Send();

	return true;
}

public int CreateJumpstat_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestParams hData)
{
	PrintToServer("Status: %d", statuscode);
	
	// Special case for timeout / failure
	if (statuscode == 0 || failure || statuscode == 500)
	{
		hData.SetBool("failure", true);
		hData.SetKeyHidden("failure", true);
		
		Handle hFwd = hData.GetHandle("callback");
		any data = hData.GetInt("data");

		CallForward(hFwd, true, INVALID_HANDLE, hData, data);
		
		delete hFwd;
		delete hData;
	}
	
	else
	{
		hData.SetBool("failure", false);
		hData.SetKeyHidden("failure", true);

		SteamWorks_GetHTTPResponseBodyCallback(request, CreateJumpstat_Data, hData);
	}

	delete request;
}

public int CreateJumpstat_Data(const char[] response, GlobalAPIRequestParams hData)
{
	Handle hJson = json_decode(response);
	Handle hFwd = hData.GetHandle("callback");
	bool bFailure = hData.GetBool("failure");
	any data = hData.GetInt("data");

	CallForward(hFwd, bFailure, hJson, hData, data);

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //
