// =========================================================== //

public int Global_HTTP_Data(const char[] response, GlobalAPIRequestData hData)
{
	GlobalAPI_DebugMessage("HTTP Response data...");

	JSON_Object hJson = json_decode(response);

	any data = hData.data;
	Handle hFwd = hData.callback;

	CallForward(hFwd, hJson, hData, data);

	// Cleanup
	if (hJson != null) hJson.Cleanup();
	if (hData != null) hData.Cleanup();

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //