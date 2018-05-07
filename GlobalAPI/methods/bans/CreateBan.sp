// =========================================================== //

/*
	native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip);
*/
public bool CreateBan(StringMap hData)
{
	if (!gB_usingAPIKey && !gB_suppressWarnings)
	{
		LogMessage("[GlobalAPI] Using the method <CreateBan> requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/bans", gC_baseUrl);
	hData.SetString("url", requestUrl);
	
	GlobalAPIRequestBody body = new GlobalAPIRequestBody();
	body.AddAll(hData);

	char json[MAX_CREATE_BAN_JSON_LENGTH];
	json_dump(body.ToJSONHandle(), json, sizeof(json), 0, true, true, false);

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

public int CreateBan_DataReceived(Handle request, bool failure, int offset, int statuscode, StringMap hData)
{
	hData.SetValue("failure", failure);
	
	// Special case for timeout / failure
	if (statuscode == 0 || failure)
	{
		Handle hFwd = null;
		hData.GetValue("callback", hFwd);

		any data = INVALID_HANDLE;
		hData.GetValue("data", data);

		CallForward(hFwd, true, INVALID_HANDLE, data);
		
		delete hFwd;
		delete hData;
	}
	
	else
	{
		SteamWorks_GetHTTPResponseBodyCallback(request, CreateBan_Data, hData);
	}

	delete request;
}

public int CreateBan_Data(const char[] response, StringMap hData)
{
	Handle hJson = json_load(response);
	
	Handle hFwd = null;
	hData.GetValue("callback", hFwd);
	
	bool bFailure = false;
	hData.GetValue("failure", bFailure);
	
	any data = INVALID_HANDLE;
	hData.GetValue("data", data);

	CallForward(hFwd, bFailure, hJson, data);

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //