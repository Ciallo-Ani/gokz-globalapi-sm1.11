// =========================================================== //

// Privates
static Handle H_Private_OnHTTPStart = INVALID_HANDLE;

// Globals
static Handle H_Global_OnInitialized = INVALID_HANDLE;
static Handle H_Global_RequestFailed = INVALID_HANDLE;
static Handle H_Global_RequestStarted = INVALID_HANDLE;
static Handle H_Global_RequestFinished = INVALID_HANDLE;

// =========================================================== //

public void CreateForwards()
{
	// Privates
	H_Private_OnHTTPStart = CreateForward(ET_Ignore, Param_Cell, Param_Cell);
	AddToForward(H_Private_OnHTTPStart, INVALID_HANDLE, Global_HTTP_Started);

	// Globals
	H_Global_OnInitialized = CreateGlobalForward("GlobalAPI_OnInitialized", ET_Ignore);
	H_Global_RequestFailed = CreateGlobalForward("GlobalAPI_OnRequestFailed", ET_Ignore, Param_Cell, Param_Cell);
	H_Global_RequestStarted = CreateGlobalForward("GlobalAPI_OnRequestStarted", ET_Ignore, Param_Cell, Param_Cell);
	H_Global_RequestFinished = CreateGlobalForward("GlobalAPI_OnRequestFinished", ET_Ignore, Param_Cell, Param_Cell);
}

// =========================================================== //

public void Call_Global_OnInitialized()
{
	Call_StartForward(H_Global_OnInitialized);
	Call_Finish();
}

public void Call_Global_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	Call_StartForward(H_Global_RequestFailed);
	Call_PushCell(request);
	Call_PushCell(hData);
	Call_Finish();
}

public void Call_Global_OnRequestStarted(Handle request, GlobalAPIRequestData hData)
{
	Call_StartForward(H_Global_RequestStarted);
	Call_PushCell(request);
	Call_PushCell(hData);
	Call_Finish();
}

public void Call_Global_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
	Call_StartForward(H_Global_RequestFinished);
	Call_PushCell(request);
	Call_PushCell(hData);
	Call_Finish();
}

// =========================================================== //

public void Call_Private_OnHTTPStart(Handle request, GlobalAPIRequestData hData)
{
	Call_StartForward(H_Private_OnHTTPStart);
	Call_PushCell(request);
	Call_PushCell(hData);
	Call_Finish();
}

// =========================================================== //