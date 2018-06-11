// =========================================================== //

public int Global_HTTP_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	hData.status = statuscode;

	// Special case for timeout / failure
	if (failure || statuscode != 200)
	{
		hData.failure = true;

		any data = hData.data;
		Handle hFwd = hData.callback;

		CallForward(hFwd, true, null, hData, data);

		// Cleanup
		if (hData != INVALID_HANDLE) hData.Cleanup();

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