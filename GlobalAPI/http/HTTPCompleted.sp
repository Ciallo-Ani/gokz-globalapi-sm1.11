// =========================================================== //

public int Global_HTTP_Completed(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statusCode, GlobalAPIRequestData hData)
{
	hData.status = view_as<int>(statusCode);
	hData.failure = (failure || statusCode != k_EHTTPStatusCode200OK);
	// TODO: Research what requestSuccessful actually is

	Call_Global_OnRequestFinished(request, hData);
}

// =========================================================== //