// =========================================================== //

/*
	native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip);
*/
public bool CreateBan(GlobalAPIRequestParams hData)
{
	if (!gB_usingAPIKey && !gB_suppressWarnings)
	{
		LogMessage("[GlobalAPI] Using the method <CreateBan> requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/bans", gC_baseUrl);
	hData.AddUrl(requestUrl);

	char json[MAX_CREATE_BAN_JSON_LENGTH];
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
	request.SetCallback(CreateBan_DataReceived);
	//request.Send();

	return true;
}

public int CreateBan_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestParams hData)
{
	// Special case for timeout / failure
	if (statuscode == 0 || failure)
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
		SteamWorks_GetHTTPResponseBodyCallback(request, CreateBan_Data, hData);
	}

	delete request;
}

public int CreateBan_Data(const char[] response, GlobalAPIRequestParams hData)
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