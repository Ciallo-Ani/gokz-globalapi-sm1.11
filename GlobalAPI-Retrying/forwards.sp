// =========================================================== //

static Handle H_Global_OnSaveRequest = INVALID_HANDLE;

// =========================================================== //

public void CreateForwards()
{
	H_Global_OnSaveRequest = CreateGlobalForward("GlobalAPI_Retrying_OnSaveRequest", ET_Ignore, Param_Cell);
}

// =========================================================== //

public void Call_Global_OnSaveRequest(GlobalAPIRequestData hData)
{
	Call_StartForward(H_Global_OnSaveRequest);
	Call_PushCell(hData);
	Call_Finish();
}

// =========================================================== //