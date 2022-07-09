public void Global_HTTP_Started(Handle request, GlobalAPIRequestData hData)
{
    hData.SetFloat("_requestStartTime", GetEngineTime());
    hData.SetKeyHidden("_requestStartTime", true);

    Call_Global_OnRequestStarted(request, hData);
}

public void Global_HTTP_Headers(Handle request, bool failure, GlobalAPIRequestData hData)
{
    GlobalAPI_DebugMessage("HTTP Response headers received...");
}

public void Global_HTTP_Completed(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statusCode, GlobalAPIRequestData hData)
{
    hData.Status = view_as<int>(statusCode);
    hData.Failure = (failure || !requestSuccessful || statusCode != k_EHTTPStatusCode200OK);
    hData.ResponseTime = CalculateResponseTime(hData);

    Call_Global_OnRequestFinished(request, hData);
}

public void Global_HTTP_DataReceived(Handle request, bool failure, int offset, int bytesReceived, GlobalAPIRequestData hData)
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

public void Global_HTTP_Data(const char[] response, GlobalAPIRequestData hData)
{
    GlobalAPI_DebugMessage("HTTP Response data...");

    JSON_Object hJson = null;

    if (hData.AcceptType == GlobalAPIRequestContentType_OctetStream)
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

    any data = hData.Data;
    Handle hFwd = hData.Callback;

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

// =====[ PRIVATE ]=====

static int CalculateResponseTime(GlobalAPIRequestData hData)
{
    float timeNow = GetEngineTime();
    float startTime = hData.GetFloat("_requestStartTime");

    // Remove temporary key
    hData.Remove("_requestStartTime");

    return RoundFloat((timeNow - startTime) * 1000);
}
