// =========================================================== //

/*
	native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] banTypes = DEFAULT_STRING,
									char[] banTypesList = DEFAULT_STRING, bool isExpired = DEFAULT_BOOL, char[] ipAddress = DEFAULT_STRING,
									int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING, char[] notesContain = DEFAULT_STRING,
									char[] statsContain = DEFAULT_STRING, int serverId = DEFAULT_INT, char[] createdSince = DEFAULT_STRING,
									char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public bool GetBans(GlobalAPIRequestData hData)
{
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	hData.ToString(requestParams, sizeof(requestParams));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/bans%s", gC_baseUrl, requestParams);
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