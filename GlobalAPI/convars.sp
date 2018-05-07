// =========================================================== //

static ConVar hCV_SuppressWarnings = null;
static ConVar hCV_DevelopmentMode = null;

// =========================================================== //

public void CreateConvars()
{
	hCV_DevelopmentMode = CreateConVar("GlobalAPI_DevelopmentMode", "0", "Enables the plugin to use the staging endpoint for API calls", _, true, 0.0, true, 1.0);
	hCV_SuppressWarnings = CreateConVar("GlobalAPI_SuppressWarnings", "0", "Suppresses warnings and their messages (such as methods that require API Key)", _, true, 0.0, true, 1.0);
	
	hCV_DevelopmentMode.AddChangeHook(ConVarHook);
	hCV_SuppressWarnings.AddChangeHook(ConVarHook);
}

// =========================================================== //

public void GetConvars()
{
	gB_suppressWarnings = hCV_SuppressWarnings.BoolValue;

	Format(gC_baseUrl, sizeof(gC_baseUrl), "%s", hCV_DevelopmentMode.BoolValue ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl);
}

// =========================================================== //

 void ConVarHook(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (!StrEqual(newValue, oldValue))
	{
		convar.IntValue = StringToInt(newValue);

		if (convar == hCV_DevelopmentMode)
		{
			Format(gC_baseUrl, sizeof(gC_baseUrl), "%s", hCV_DevelopmentMode.BoolValue ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl);
		}
	}
}

// =========================================================== //