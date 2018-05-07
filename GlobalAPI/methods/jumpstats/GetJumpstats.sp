// =========================================================== //

/*
native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = -1,
									int serverId = -1, int steamId64 = -1, char[] steamId = "", char[] jumpType = "",
									char[] steamId64List = "", char[] jumpTypeList = "", float greaterThanDistance = -1.0,
									float lessThanDistance = -1.0, char[] isMsl = "", char[] isCrouchBind = "", char[] isForwardBind = "",
									char[] isCrouchBoost = "", int updatedById = -1, char[] createdSince = "", char[] updatedSince = "", 
									int offset = -1, int limit = -1);
*/
public bool GetJumpstats(StringMap hData)
{
	char requestParams[MAX_QUERYPARAM_NUM * MAX_QUERYPARAM_LENGTH];
	
	GlobalAPIRequestParams params = new GlobalAPIRequestParams();
	params.AddAll(hData);
	params.Build(requestParams, sizeof(requestParams));
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/jumpstats%s", gC_baseUrl, requestParams);
	hData.SetString("url", requestUrl);
	
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

public int GetJumpstats_DataReceived(Handle request, bool failure, int offset, int statuscode, StringMap hData)
{
	hData.SetValue("failure", failure);
	
	// Special case for timeout / failure
	if (statuscode == 0 || failure)
	{
		Handle hFwd = null;
		hData.GetValue("callback", hFwd);
		
		any data = INVALID_HANDLE;
		hData.GetValue("data", data);
		
		CallForward(hFwd, true, INVALID_HANDLE, data);
		
		delete hFwd;
		delete hData;
	}
	
	else
	{
		SteamWorks_GetHTTPResponseBodyCallback(request, GetJumpstats_Data, hData);
	}

	delete request;
}

public int GetJumpstats_Data(const char[] response, StringMap hData)
{
	Handle hJson = json_load(response);
	
	Handle hFwd = null;
	hData.GetValue("callback", hFwd);
	
	bool bFailure = false;
	hData.GetValue("failure", bFailure);
	
	any data = INVALID_HANDLE;
	hData.GetValue("data", data);

	CallForward(hFwd, bFailure, hJson, data);

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //