// =========================================================== //

// Handles...

// =========================================================== //

public void CreateConvars()
{
	// CreateConVar & ConVarHooks
}

// =========================================================== //

public void GetConVars()
{
	// Update Global Vars here, if needed
}

// =========================================================== //

void ConVarHook(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (!StrEqual(newValue, oldValue))
	{
		convar.IntValue = StringToInt(newValue);
	}
}

// =========================================================== //