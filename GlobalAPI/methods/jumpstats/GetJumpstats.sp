// =========================================================== //

/*
	native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = DEFAULT_INT,
										int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING,
										char[] jumpType = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING, 
										char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
										float lessThanDistance = DEFAULT_FLOAT, char[] isMsl = DEFAULT_STRING,
										char[] isCrouchBind = DEFAULT_STRING, char[] isForwardBind = DEFAULT_STRING,
										char[] isCrouchBoost = DEFAULT_STRING, int updatedById = DEFAULT_INT,
										char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
										int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public bool GetJumpstats(GlobalAPIRequestParams hData)
{
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	hData.ToString(requestParams, sizeof(requestParams));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/jumpstats%s", gC_baseUrl, requestParams);
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
	request.SetCallback(GetJumpstats_DataReceived);
	request.Send();

	return true;
}

public int GetJumpstats_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestParams hData)
{
	// Special case for timeout / failure
	if (statuscode == 0 || failure || statuscode == 500)
	{
		hData.AddFailure(true);
		
		any data = hData.GetInt("data");
		Handle hFwd = hData.GetHandle("callback");
		
		CallForward(hFwd, true, INVALID_HANDLE, hData, data);
		
		delete hFwd;
		delete hData;
	}
	
	else
	{
		hData.AddFailure(false);
		SteamWorks_GetHTTPResponseBodyCallback(request, GetJumpstats_Data, hData);
	}

	delete request;
}

public int GetJumpstats_Data(const char[] response, GlobalAPIRequestParams hData)
{
	Handle hJson = json_decode(response);
	
	any data = hData.GetInt("data");
	bool bFailure = hData.GetBool("failure");
	Handle hFwd = hData.GetHandle("callback");

	CallForward(hFwd, bFailure, hJson, hData, data);

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //