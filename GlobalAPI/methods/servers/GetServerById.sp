// =========================================================== //

/*
	native bool GlobalAPI_GetServerById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);
*/
public bool GetServerById(GlobalAPIRequestData hData)
{
	int id = hData.GetInt("id");

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/servers/%d", gC_baseUrl, id);
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