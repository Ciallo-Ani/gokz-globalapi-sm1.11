// =========================================================== //

public int Global_HTTP_Completed(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statusCode, GlobalAPIRequestData hData)
{
	Call_Global_OnRequestFinished(request, hData);
}

// =========================================================== //