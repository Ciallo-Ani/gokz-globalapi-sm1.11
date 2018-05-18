// =========================================================== //

/*
	native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId,
										int jumpType, float distance, char[] jumpJsonInfo, int tickRate, int mslCount,
										bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);
*/
public bool CreateJumpstat(GlobalAPIRequestData hData)
{
	if (!gB_usingAPIKey && !gB_Debug)
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
	request.SetCallbacks();
	request.SetAuthHeader();
	request.SetAcceptHeaders();
	request.SetPoweredByHeader();
	request.SetBody(json, sizeof(json));
	request.Send(hData);

	return true;
}

// =========================================================== //
