// =========================================================== //

/*
	native bool GlobalAPI_GetPlayerBySteamId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING);
*/
public bool GetPlayerBySteamId(GlobalAPIRequestData hData)
{
	char steamId[MAX_QUERYPARAM_LENGTH];
	hData.GetString("steamid", steamId, sizeof(steamId));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/players/steamid/%s", gC_baseUrl, steamId);
	hData.AddUrl(requestUrl);
	
	GlobalAPIRequest request = new GlobalAPIRequest(requestUrl, k_EHTTPMethodGET);

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
	request.Send(hData);

	return true;
}

// =========================================================== //