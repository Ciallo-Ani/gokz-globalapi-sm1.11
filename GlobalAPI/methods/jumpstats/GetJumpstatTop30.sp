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
	request.SetAuthHeader();
	request.SetAcceptHeaders();
	request.SetPoweredByHeader();
	request.SetCallback(GetJumpstatTop30_DataReceived);
	request.Send();
	
	return true;
}

public int GetJumpstatTop30_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
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
		SteamWorks_GetHTTPResponseBodyCallback(request, GetJumpstatTop30_Data, hData);
	}

	delete request;
}

public int GetJumpstatTop30_Data(const char[] response, GlobalAPIRequestData hData)
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