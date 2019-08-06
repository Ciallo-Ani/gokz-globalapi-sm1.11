// =========================================================== //

public int Global_HTTP_Completed(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statusCode, GlobalAPIRequestData hData)
{
	hData.Status = view_as<int>(statusCode);
	hData.Failure = (failure || !requestSuccessful || statusCode != k_EHTTPStatusCode200OK);
	hData.ResponseTime = CalculateResponseTime(hData);

	Call_Global_OnRequestFinished(request, hData);
}

// =========================================================== //