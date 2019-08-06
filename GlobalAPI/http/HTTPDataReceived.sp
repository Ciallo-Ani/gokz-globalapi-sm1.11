// =========================================================== //

public int Global_HTTP_DataReceived(Handle request, bool failure, int offset, int bytesReceived, GlobalAPIRequestData hData)
{
	GlobalAPI_DebugMessage("HTTP Response data received...");

	if (hData.Failure)
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
			hData.SetHandle("_requestHandle", request);
			SteamWorks_GetHTTPResponseBodyCallback(request, Global_HTTP_Data, hData);
		}
	}

	delete request;
}

// =========================================================== //