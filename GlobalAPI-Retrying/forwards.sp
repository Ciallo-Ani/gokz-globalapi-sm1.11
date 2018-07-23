// =========================================================== //

static Handle H_Global_OnSaveRequest = INVALID_HANDLE;
static Handle H_Global_OnCheckRequests = INVALID_HANDLE;

// =========================================================== //

public void CreateForwards()
{
	H_Global_OnSaveRequest = CreateGlobalForward("GlobalAPI_Retrying_OnSaveRequest", ET_Ignore, Param_Cell);
	H_Global_OnCheckRequests = CreateGlobalForward("GlobalAPI_Retrying_OnCheckRequests", ET_Ignore);
}

// =========================================================== //

public void Call_Global_OnSaveRequest(GlobalAPIRequestData hData)
{
	Call_StartForward(H_Global_OnSaveRequest);
	Call_PushCell(hData);
	Call_Finish();
}

public void Call_Global_OnCheckRequests()
{
	Call_StartForward(H_Global_OnCheckRequests);
	Call_Finish();
}

// =========================================================== //