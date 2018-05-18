// =========================================================== //

/*
	native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId,
										int jumpType, float distance, char[] jumpJsonInfo, int tickRate, int mslCount,
										bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);
*/
public bool CreateJumpstat(GlobalAPIRequestData hData)
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
	hData.Encode(json, sizeof(json));
	
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

public int CreateJumpstat_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	// Special case for timeout / failure
	if (statuscode == 0 || failure || statuscode == 500)
	{
		hData.AddFailure(true);
		
		any data = hData.GetInt("data");
		Handle hFwd = hData.GetHandle("callback");

		CallForward(hFwd, true, null, hData, data);

		// Cleanup
		hData.Cleanup();

		delete hFwd;
		delete hData;
	}
	
	else
	{
		hData.AddFailure(false);
		SteamWorks_GetHTTPResponseBodyCallback(request, CreateJumpstat_Data, hData);
	}

	delete request;
}

public int CreateJumpstat_Data(const char[] response, GlobalAPIRequestData hData)
{
	JSON_Object hJson = json_decode(response);

	any data = hData.GetInt("data");
	bool bFailure = hData.GetBool("failure");
	Handle hFwd = hData.GetHandle("callback");

	CallForward(hFwd, bFailure, hJson, hData, data);

	// Cleanup
	hJson.Cleanup();
	hData.Cleanup();

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //
