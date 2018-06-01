// =========================================================== //

public int Global_HTTP_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	hData.status = statuscode;

	// Special case for timeout / failure
	// NOTE: Retrying a 404 is probably useless
	if (statuscode == 0 || statuscode == 203 || statuscode == 404 || statuscode == 500 || statuscode == 503)
	{
		hData.failure = true;

		any data = hData.data;
		Handle hFwd = hData.callback;

		CallForward(hFwd, true, null, hData, data);

		// Cleanup
		hData.Cleanup();

		delete hFwd;
		delete hData;
	}

	else
	{
		hData.failure = false;
		SteamWorks_GetHTTPResponseBodyCallback(request, Global_HTTP_Data, hData);
	}

	delete request;
}

// =========================================================== //