// =========================================================== //

/*
	native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public bool GetAuthStatus(GlobalAPIRequestData hData)
{
	if (!gB_usingAPIKey && !gB_Debug)
	{
		LogMessage("[GlobalAPI] Using the method <GetAuthStatus> requires an API key, and you dont seem to have one setup!");
		return false;
	}
 	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/auth/status", gC_baseUrl);
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