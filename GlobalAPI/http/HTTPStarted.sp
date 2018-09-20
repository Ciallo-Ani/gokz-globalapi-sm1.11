// =========================================================== //

public void Global_HTTP_Started(Handle request, GlobalAPIRequestData hData)
{
	hData.SetFloat("_requestStartTime", GetEngineTime());
	hData.SetKeyHidden("_requestStartTime", true);
	
	Call_Global_OnRequestStarted(request, hData);
}

// =========================================================== //