// =========================================================== //

/*
	native bool GlobalAPI_CreateRecord(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId, int mapId,
										char[] mode, int stage, int tickRate, int teleports, float time);
*/
public bool CreateRecord(GlobalAPIRequestData hData)
{
	if (!gB_usingAPIKey && !gB_Debug)
	{
		LogMessage("[GlobalAPI] Using the method <CreateRecord> requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records", gC_baseUrl);
	hData.AddUrl(requestUrl);
	
	char json[MAX_CREATE_RECORD_JSON_LENGTH];
	hData.Encode(json, sizeof(json));
	
	PrintToServer(json);
	
	GlobalAPIRequest request = new GlobalAPIRequest(requestUrl, k_EHTTPMethodPOST);
	
	if (request == null)
	{
		delete hData;
		delete request;
		return false;
	}

	request.SetData(hData);
	request.SetTimeout(15);
	request.SetCallbacks();
	request.SetAuthHeader();
	request.SetAcceptHeaders();
	request.SetPoweredByHeader();
	request.SetBody(json, sizeof(json));
	request.Send(hData);

	return true;
}

// =========================================================== //