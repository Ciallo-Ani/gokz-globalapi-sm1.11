// =========================================================== //

/*
	BASE HTTP GET METHOD FOR NATIVES
*/
bool HTTPGet(GlobalAPIRequestData hData)
{
	if (hData.KeyRequired && !gB_usingAPIKey && !gCV_Debug.BoolValue)
	{
		LogMessage("[GlobalAPI] Using this method requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	char requestParams[GlobalAPI_Max_QueryParams_Length];
	hData.ToString(requestParams, sizeof(requestParams));

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
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
	request.SetPoweredByHeader();
	request.SetEnvironmentHeaders(gC_MetamodVersion, gC_SourcemodVersion);
	request.SetAcceptHeaders(hData);
	request.SetContentTypeHeader(hData);
	request.SetRequestOriginHeader(hData);
	request.Send(hData);

	return true;
}

// =========================================================== //