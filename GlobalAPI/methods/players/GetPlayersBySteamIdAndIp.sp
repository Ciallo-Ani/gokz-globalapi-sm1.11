// =========================================================== //

/*
	native bool GlobalAPI_GetPlayersBySteamIdAndIp(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId, char[] ip);
*/
public bool GetPlayersBySteamIdAndIp(GlobalAPIRequestData hData)
{
	char steamId[MAX_QUERYPARAM_LENGTH];
	hData.GetString("steamid", steamId, sizeof(steamId));
	
	char ip[MAX_QUERYPARAM_LENGTH];
	hData.GetString("ip", ip, sizeof(ip));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/players/steamid/%s/ip/%s", gC_baseUrl, steamId, ip);
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
	request.SetCallbacks();
	request.SetAuthHeader();
	request.SetAcceptHeaders();
	request.SetPoweredByHeader();
	request.Send(hData);

	return true;
}

// =========================================================== //