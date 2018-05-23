// =========================================================== //

/*
	native bool GlobalAPI_GetModeByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] name);
*/
public bool GetModeByName(GlobalAPIRequestData hData)
{
	char name[MAX_QUERYPARAM_LENGTH];
	hData.GetString("name", name, sizeof(name));

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/modes/name/%s", gC_baseUrl, name);
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