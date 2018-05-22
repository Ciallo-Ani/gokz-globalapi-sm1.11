// =========================================================== //

/*
	native bool GlobalAPI_GetModeById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);
*/
public bool GetModeById(GlobalAPIRequestData hData)
{
	int id = hData.GetInt("id");

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/modes/id/%d", gC_baseUrl, id);
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