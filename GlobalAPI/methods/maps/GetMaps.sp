// =========================================================== //

/*
	native bool GlobalAPI_GetMaps(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] name = DEFAULT_STRING,
									int largerThanFilesize = DEFAULT_INT, int smallerThanFilesize = DEFAULT_INT, bool isValidated = DEFAULT_BOOL,
									int difficulty = DEFAULT_INT, char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public bool GetMaps(GlobalAPIRequestData hData)
{
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	hData.ToString(requestParams, sizeof(requestParams));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/maps%s", gC_baseUrl, requestParams);
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
	request.SetAuthHeader();
	request.SetAcceptHeaders();
	request.SetPoweredByHeader();
	request.SetCallback(GetMaps_DataReceived);
	request.Send();

	return true;
}

public int GetMaps_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	// Special case for timeout / failure
	if (statuscode == 0 || failure || statuscode == 500)
	{
		hData.AddFailure(true);
		
		any data = hData.GetInt("data");
		Handle hFwd = hData.GetHandle("callback");
		
		CallForward(hFwd, true, null, hData, data);
		
		// Cleanup
		hData.Cleanup();

		delete hFwd;
		delete hData;
	}
	
	else
	{
		hData.AddFailure(false);
		SteamWorks_GetHTTPResponseBodyCallback(request, GetMaps_Data, hData);
	}

	delete request;
}

public int GetMaps_Data(const char[] response, GlobalAPIRequestData hData)
{
	JSON_Object hJson = json_decode(response);
	
	any data = hData.GetInt("data");
	bool bFailure = hData.GetBool("failure");
	Handle hFwd = hData.GetHandle("callback");

	CallForward(hFwd, bFailure, hJson, hData, data);

	// Cleanup
	hJson.Cleanup();
	hData.Cleanup();

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //