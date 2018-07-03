// =========================================================== //

public int Global_HTTP_DataReceived(Handle request, bool failure, int offset, int statuscode, GlobalAPIRequestData hData)
{
	// Special case for timeout / failure
	if (failure || statuscode != 200)
	{
		Call_Global_OnRequestFailed(request, hData);
		CallForward_NoResponse(hData);
	}

	else
	{
		int responseBodySize = 0;
		SteamWorks_GetHTTPResponseBodySize(request, responseBodySize);

		if (responseBodySize <= 0)
		{
			CallForward_NoResponse(hData);
		}
		else
		{
			SteamWorks_GetHTTPResponseBodyCallback(request, Global_HTTP_Data, hData);
		}
	}

	delete request;
}

// =========================================================== //