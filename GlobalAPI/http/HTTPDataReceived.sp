// =========================================================== //

public int Global_HTTP_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	// Special case for timeout / failure
	if (statuscode == 0 || failure || statuscode == 500)
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