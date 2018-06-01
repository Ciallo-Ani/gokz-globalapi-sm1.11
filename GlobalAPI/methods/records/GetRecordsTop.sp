// =========================================================== //

/*
	native bool GlobalAPI_GetRecordsTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
											char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT,
											char[] mapName = DEFAULT_STRING, int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
											char[] modes = DEFAULT_STRING, bool hasTeleports = DEFAULT_BOOL, char[] playerName = DEFAULT_STRING,
											int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public bool GetRecordsTop(GlobalAPIRequestData hData)
{
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	hData.ToString(requestParams, sizeof(requestParams));

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records/top%s", gC_baseUrl, requestParams);
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