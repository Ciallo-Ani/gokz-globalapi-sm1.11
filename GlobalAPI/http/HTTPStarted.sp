// =========================================================== //

public void Global_HTTP_Started(Handle request, GlobalAPIRequestData hData)
{
	GlobalAPI_DebugMessage("HTTP Request started!");

	hData.SetFloat("_requestStartTime", GetEngineTime());
	Call_Global_OnRequestStarted(request, hData);
}

// =========================================================== //