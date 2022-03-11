ConVar gCV_Debug = null;
ConVar gCV_Staging = null;

void CreateConvars()
{
    gCV_Debug = CreateConVar("GlobalAPI_Debug", "0", "", _, true, 0.0, true, 1.0);
    gCV_Staging = CreateConVar("GlobalAPI_Staging", "0", "Enables the plugin to use the staging endpoint for API calls", _, true, 0.0, true, 1.0);

    gCV_Staging.AddChangeHook(ConVarHook);
}

void ConVarHook(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (!StrEqual(newValue, oldValue))
    {
        if (convar == gCV_Staging)
        {
            gC_baseUrl = convar.BoolValue ? GlobalAPI_Staging_BaseUrl : GlobalAPI_BaseUrl;
        }
    }
}
