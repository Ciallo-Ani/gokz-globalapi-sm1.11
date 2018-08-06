// =========================================================== //

/*
	BASE HTTP POST METHOD FOR NATIVES
*/
public bool HTTPPost(GlobalAPIRequestData hData)
{
	if (hData.keyRequired && !gB_usingAPIKey && !gB_Debug)
	{
		LogMessage("[GlobalAPI] Using this method requires an API key, and you dont seem to have one setup!");
		return false;
	}
	
	int maxlength = hData.bodyLength;
	
	char contentType[32];
	hData.GetString("contentType", contentType, sizeof(contentType));

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	hData.GetString("url", requestUrl, sizeof(requestUrl));

	char[] body = new char[maxlength];

	if (StrEqual(contentType, "application/octet-stream", false))
	{
		hData.GetString("body", body, maxlength);
	}
	else
	{
		hData.Encode(body, maxlength);
	}
	
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
	request.SetContentTypeHeader(hData);
	request.SetRequestOriginHeader(hData);
	request.SetBody(hData, body, maxlength);
	request.Send(hData);

	return true;
}

// =========================================================== //
