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

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	hData.GetString("url", requestUrl, sizeof(requestUrl));

	GlobalAPIRequest request = new GlobalAPIRequest(requestUrl, k_EHTTPMethodPOST);

	if (request == null)
	{
		delete hData;
		delete request;
		return false;
	}

	int maxlength = hData.bodyLength;
	char[] body = new char[maxlength];

	if (hData.contentType == GlobalAPIRequestContentType_OctetStream)
	{
		char file[PLATFORM_MAX_PATH];
		hData.GetString("file", file, sizeof(file));
		request.SetBodyFromFile(hData, file);
	}
	else
	{
		hData.Encode(body, maxlength);
		request.SetBody(hData, body, maxlength);
	}

	request.SetData(hData);
	request.SetTimeout(15);
	request.SetCallbacks();
	request.SetAuthHeader();
	request.SetPoweredByHeader();
	request.SetAcceptHeaders(hData);
	request.SetContentTypeHeader(hData);
	request.SetRequestOriginHeader(hData);
	request.SetBody(hData, body, maxlength);
	request.Send(hData);

	return true;
}

// =========================================================== //
