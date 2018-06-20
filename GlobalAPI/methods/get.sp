// =========================================================== //

/*
	BASE HTTP GET METHOD FOR NATIVES
*/
public bool HTTPGet(GlobalAPIRequestData hData)
{
	if (hData.keyRequired && !gB_usingAPIKey && !gB_Debug)
	{
		LogMessage("[GlobalAPI] Using this method requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	hData.ToString(requestParams, sizeof(requestParams));

	char requestUrl[MAX_QUERYURL_LENGTH];
	hData.GetString("url", requestUrl, sizeof(requestUrl));
	StrCat(requestUrl, sizeof(requestUrl), requestParams);

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