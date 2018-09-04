// =========================================================== //

public int Global_HTTP_Data(const char[] response, GlobalAPIRequestData hData)
{
	PrintDebugMessage("HTTP Response data...");

	JSON_Object hJson = json_decode(response);

	any data = hData.data;
	Handle hFwd = hData.callback;

	CallForward(hFwd, hJson, hData, data);

	// Cleanup
	if (hJson != INVALID_HANDLE) hJson.Cleanup();
	if (hData != INVALID_HANDLE) hData.Cleanup();

	delete hFwd;
	delete hJson;
	delete hData;
}

// =========================================================== //