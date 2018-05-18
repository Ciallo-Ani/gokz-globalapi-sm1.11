// =========================================================== //

// Privates
static Handle H_Private_OnHTTPStart = INVALID_HANDLE;

// Globals
static Handle H_Global_OnInitialized = INVALID_HANDLE;

// =========================================================== //

public void CreateForwards()
{
	// Privates
	// Should a handle pointing to this plugin be used? (AskPluginLoad2)
	H_Private_OnHTTPStart = CreateForward(ET_Ignore, Param_Cell, Param_Cell);
	AddToForward(H_Private_OnHTTPStart, INVALID_HANDLE, Global_HTTP_Started);

	// Globals
	H_Global_OnInitialized = CreateGlobalForward("GlobalAPI_OnInitialized", ET_Ignore);
}

// =========================================================== //

public void Call_Global_OnInitialized()
{
	Call_StartForward(H_Global_OnInitialized);
	Call_Finish();
}

public void Call_Private_OnHTTPStart(Handle request, GlobalAPIRequestData hData)
{
	Call_StartForward(H_Private_OnHTTPStart);
	Call_PushCell(request);
	Call_PushCell(hData);
	Call_Finish();
}

// =========================================================== //