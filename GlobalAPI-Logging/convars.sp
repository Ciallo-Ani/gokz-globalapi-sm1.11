// =========================================================== //

static ConVar hCV_LogFailed = null;
static ConVar hCV_LogStarted = null;
static ConVar hCV_LogFinished = null;

// =========================================================== //

public void CreateConvars()
{
	hCV_LogFailed = CreateConVar("GlobalAPI_Logging_LogFailed", "1", "", _, true, 0.0, true, 1.0);
	hCV_LogStarted = CreateConVar("GlobalAPI_Logging_LogStarted", "0", "", _, true, 0.0, true, 1.0);
	hCV_LogFinished = CreateConVar("GlobalAPI_Logging_LogFinished", "0", "", _, true, 0.0, true, 1.0);
	
	hCV_LogFailed.AddChangeHook(ConVarHook);
	hCV_LogStarted.AddChangeHook(ConVarHook);
	hCV_LogFinished.AddChangeHook(ConVarHook);
}

// =========================================================== //

public void GetConVars()
{
	gB_LogFailed = hCV_LogFailed.BoolValue;
	gB_LogStarted = hCV_LogStarted.BoolValue;
	gB_LogFinished = hCV_LogFinished.BoolValue;
}

// =========================================================== //

void ConVarHook(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (!StrEqual(newValue, oldValue))
	{
		convar.IntValue = StringToInt(newValue);
		
		if (convar == hCV_LogFailed) gB_LogFailed = convar.BoolValue;
		if (convar == hCV_LogStarted) gB_LogStarted = convar.BoolValue;
		if (convar == hCV_LogFinished) gB_LogFinished = convar.BoolValue;
	}
}

// =========================================================== //