// =========================================================== //

/*
	BASE HTTP POST METHOD FOR NATIVES
*/
bool HTTPPost(GlobalAPIRequestData hData)
{
	if (hData.KeyRequired && !gB_usingAPIKey && !gCV_Debug.BoolValue)
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

	if (hData.ContentType == GlobalAPIRequestContentType_OctetStream)
	{
		char file[PLATFORM_MAX_PATH];
		hData.GetString("bodyFile", file, sizeof(file));
		request.SetBodyFromFile(hData, file);
	}
	else
	{
		int maxlength = hData.BodyLength;
		char[] body = new char[maxlength];

		hData.Encode(body, maxlength);
		request.SetBody(hData, body, maxlength);
	}

	char mmVersion[32] = "Unknown";
	if (gCV_MetaModVersion != null)
	{
		gCV_MetaModVersion.GetString(mmVersion, sizeof(mmVersion));
	}

	char smVersion[32] = "Unknown";
	if (gCV_SourceModVersion != null)
	{
		gCV_SourceModVersion.GetString(smVersion, sizeof(smVersion));
	}

	request.SetData(hData);
	request.SetTimeout(15);
	request.SetCallbacks();
	request.SetAuthHeader();
	request.SetPoweredByHeader();
	request.SetEnvironmentHeaders(mmVersion, smVersion);
	request.SetAcceptHeaders(hData);
	request.SetContentTypeHeader(hData);
	request.SetRequestOriginHeader(hData);
	request.Send(hData);

	return true;
}

// =========================================================== //
