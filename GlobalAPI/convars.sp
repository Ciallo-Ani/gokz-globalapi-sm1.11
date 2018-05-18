// =========================================================== //

static ConVar hCV_Debug = null;
static ConVar hCV_Staging = null;

// =========================================================== //

public void CreateConvars()
{
	hCV_Debug = CreateConVar("GlobalAPI_Debug", "0", "", _, true, 0.0, true, 1.0);
	hCV_Staging = CreateConVar("GlobalAPI_Staging", "0", "Enables the plugin to use the staging endpoint for API calls", _, true, 0.0, true, 1.0);
	
	hCV_Debug.AddChangeHook(ConVarHook);
	hCV_Staging.AddChangeHook(ConVarHook);
}

// =========================================================== //

public void GetConvars()
{
	gB_Debug = hCV_Debug.BoolValue;
	gB_Staging = hCV_Staging.BoolValue;

	Format(gC_baseUrl, sizeof(gC_baseUrl), "%s", gB_Staging ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl);
}

// =========================================================== //

 void ConVarHook(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (!StrEqual(newValue, oldValue))
	{
		convar.IntValue = StringToInt(newValue);

		if (convar == hCV_Staging)
		{
			Format(gC_baseUrl, sizeof(gC_baseUrl), "%s", hCV_Staging.BoolValue ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl);
		}
	}
}

// =========================================================== //