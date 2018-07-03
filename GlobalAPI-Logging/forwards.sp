// =========================================================== //

static Handle H_Global_OnLogged = INVALID_HANDLE;
static Handle H_Global_OnFailLogged = INVALID_HANDLE;
static Handle H_Global_OnStartLogged = INVALID_HANDLE;
static Handle H_Global_OnFinishLogged = INVALID_HANDLE;

// =========================================================== //

public void CreateForwards()
{
	H_Global_OnLogged = CreateGlobalForward("GlobalAPI_Logging_OnLogged", ET_Ignore);
	H_Global_OnFailLogged = CreateGlobalForward("GlobalAPI_Logging_OnFailLogged", ET_Ignore);
	H_Global_OnStartLogged = CreateGlobalForward("GlobalAPI_Logging_OnStartLogged", ET_Ignore);
	H_Global_OnFinishLogged = CreateGlobalForward("GlobalAPI_Logging_OnFinishLogged", ET_Ignore);
}

// =========================================================== //

public void Call_Global_OnLogged()
{
	Call_StartForward(H_Global_OnLogged);
	Call_Finish();
}

public void Call_Global_OnFailLogged()
{
	Call_StartForward(H_Global_OnFailLogged);
	Call_Finish();
}

public void Call_Global_OnStartLogged()
{
	Call_StartForward(H_Global_OnStartLogged);
	Call_Finish();
}

public void Call_Global_OnFinishLogged()
{
	Call_StartForward(H_Global_OnFinishLogged);
	Call_Finish();
}

// =========================================================== //