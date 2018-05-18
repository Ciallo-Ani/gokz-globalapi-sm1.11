/*
	native bool GlobalAPI_GetJumpstatTop30(OnAPICallFinished callback = INVALID_HANDLE, any data = INVALID_HANDLE, char[] jumpType);
*/
public bool GetJumpstatTop30(GlobalAPIRequestData hData)
{
	char jumpType[MAX_QUERYPARAM_LENGTH];
	hData.GetString("jumpType", jumpType, sizeof(jumpType));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/jumpstats/%s/top30", gC_baseUrl, jumpType);
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