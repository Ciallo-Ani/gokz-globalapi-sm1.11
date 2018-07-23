// =========================================================== //

/*
	BASE HTTP POST METHOD FOR NATIVES
*/
public bool HTTPPost(GlobalAPIRequestData hData)
{
	hData.requestType = GlobalAPIRequestType_POST;

	if (hData.keyRequired && !gB_usingAPIKey && !gB_Debug)
	{
		LogMessage("[GlobalAPI] Using this method requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	int maxlength = hData.bodyLength;
	
	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	hData.GetString("url", requestUrl, sizeof(requestUrl));

	char[] json = new char[maxlength];
	hData.Encode(json, maxlength);
	
	GlobalAPIRequest request = new GlobalAPIRequest(requestUrl, k_EHTTPMethodPOST);
	
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
	request.SetBody(json, maxlength);
	request.Send(hData);

	return true;
}

// =========================================================== //
