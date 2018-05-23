// =========================================================== //

/*
	native bool GlobalAPI_GetModes(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public bool GetModes(GlobalAPIRequestData hData)
{
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	hData.ToString(requestParams, sizeof(requestParams));

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/modes", gC_baseUrl);
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