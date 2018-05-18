// =========================================================== //

/*
	native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip);
*/
public bool CreateBan(GlobalAPIRequestData hData)
{
	if (!gB_usingAPIKey && !gB_Debug)
	{
		LogMessage("[GlobalAPI] Using the method <CreateBan> requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/bans", gC_baseUrl);
	hData.AddUrl(requestUrl);

	char json[MAX_CREATE_BAN_JSON_LENGTH];
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
	request.Send();

	return true;
}

// =========================================================== //