// =========================================================== //

public int Global_HTTP_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	hData.AddStatus(statuscode);

	// Special case for timeout / failure
	// NOTE: Retrying a 404 is probably useless
	if (statuscode == 0 || statuscode == 203 || statuscode == 404 || statuscode == 500 || statuscode == 503)
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
		SteamWorks_GetHTTPResponseBodyCallback(request, Global_HTTP_Data, hData);
	}

	delete request;
}

// =========================================================== //