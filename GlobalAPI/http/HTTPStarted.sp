// =========================================================== //

public void Global_HTTP_Started(Handle request, GlobalAPIRequestData hData)
{
	PrintDebugMessage("HTTP Request started!");

	hData.SetFloat("_requestStartTime", GetEngineTime());
	Call_Global_OnRequestStarted(request, hData);
}

// =========================================================== //