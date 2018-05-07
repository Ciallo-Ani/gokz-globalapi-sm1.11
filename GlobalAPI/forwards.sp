// =========================================================== //

static Handle H_OnInitialized = INVALID_HANDLE;

// =========================================================== //

public void CreateForwards()
{
	H_OnInitialized = CreateGlobalForward("GlobalAPI_OnInitialized", ET_Ignore);
}

// =========================================================== //

public void Call_Global_OnInitialized()
{
	Call_StartForward(H_OnInitialized);
	Call_Finish();
}

// =========================================================== //