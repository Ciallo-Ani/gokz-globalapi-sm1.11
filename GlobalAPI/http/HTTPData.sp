// =========================================================== //

public int Global_HTTP_Data(const char[] response, GlobalAPIRequestData hData)
{
	GlobalAPI_DebugMessage("HTTP Response data...");

	JSON_Object hJson = null;

	if (hData.acceptType == GlobalAPIRequestContentType_OctetStream)
	{
		char path[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, path, sizeof(path), "data/GlobalAPI/%d_%f.%s",
												GetTime(),
												GetEngineTime(), 
												GlobalAPI_Data_File_Extension);

		hData.AddDataPath(path);

		Handle request = hData.GetHandle("_requestHandle");
		SteamWorks_WriteHTTPResponseBodyToFile(request, path);
	}

	else
	{
		hJson = json_decode(response);
	}

	any data = hData.data;
	Handle hFwd = hData.callback;

	// Remove temporary key
	hData.Remove("_requestHandle");

	CallForward(hFwd, hJson, hData, data);

	// Cleanup
	if (hJson != null) hJson.Cleanup();
	if (hData != null) hData.Cleanup();

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //