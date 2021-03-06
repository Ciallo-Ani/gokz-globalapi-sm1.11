enum
{
    Argument_Help = 0,
    Argument_ShowMapInfo,
    ARGUMENT_COUNT
};

static char validArgs[ARGUMENT_COUNT][] =
{
    "--help",
    "--show-map-info"
};

// =====[ PUBLIC ]=====

void CreateCommands()
{
    RegAdminCmd("sm_globalapi_info", Command_Info, ADMFLAG_ROOT, "Displays GlobalAPI info");
    RegAdminCmd("sm_globalapi_reload_apikey", Command_ReloadAPIKey, ADMFLAG_ROOT, "Reloads GlobalAPI Key");
}

public Action Command_Info(int client, int args)
{
    PrintInfoHeaderToConsole(client);

    char argument[32];
    ArrayList usedArguments = new ArrayList();

    char errorString[64];
    ArrayList errorMessages = new ArrayList(ByteCountToCells(sizeof(errorString)));

    for (int arg = 1; arg <= args; arg++)
    {
        if (arg > ARGUMENT_COUNT)
        {
            Format(errorString, sizeof(errorString), "Too many arguments supplied! (Limit %d)", ARGUMENT_COUNT);
            errorMessages.PushString(errorString);
            break;
        }

        GetCmdArg(arg, argument, sizeof(argument));

        // --help
        if (StrEqual(argument, validArgs[Argument_Help]))
        {
            if (arg == 1)
            {
                PrintToConsole(client, "\nValid arguments are:");
                for (int i = 0; i < ARGUMENT_COUNT; i++)
                {
                    PrintToConsole(client, "> %s", validArgs[i]);
                }

                break;
            }
            else
            {
                Format(errorString, sizeof(errorString), "\"%s\" must be supplied alone", argument);
                errorMessages.PushString(errorString);
            }
        }

        // --show-map-info
        else if (StrEqual(argument, validArgs[Argument_ShowMapInfo]))
        {
            if (usedArguments.FindValue(Argument_ShowMapInfo) == -1)
            {
                PrintMapInfoToConsole(client);
                usedArguments.Push(Argument_ShowMapInfo);
            }
            else
            {
                Format(errorString, sizeof(errorString), "Command option \"%s\" already used", argument);
                errorMessages.PushString(errorString);
            }
        }

        // All valid ones checked, has to be invalid
        else if (json_string_startswith(argument, "--") && argument[2] != '-')
        {
            Format(errorString, sizeof(errorString), "Invalid command option \"%s\"", argument);
            errorMessages.PushString(errorString);
        }

        // Not even a command option?
        else
        {
            Format(errorString, sizeof(errorString), "Invalid argument! \"%s\"", argument);
            errorMessages.PushString(errorString);
        }
    }

    // Did we have any errors?
    if (errorMessages.Length > 0)
    {
        PrintToConsole(client, "\nErrors:");
        for (int i = 0; i < errorMessages.Length; i++)
        {
            errorMessages.GetString(i, errorString, sizeof(errorString));
            PrintToConsole(client, "> %s", errorString);
        }
    }

    delete errorMessages;
    delete usedArguments;

    return Plugin_Handled;
}

public Action Command_ReloadAPIKey(int client, int args)
{
    gB_usingAPIKey = ReadAPIKey();
    ReplyToCommand(client, "[GlobalAPI] API Key reloaded!");

    return Plugin_Handled;
}

// =====[ PRIVATE ]=====

static void PrintInfoHeaderToConsole(int client)
{
    char infoStr[128];
    int paddingSize = Format(infoStr, sizeof(infoStr), "[GlobalAPI Plugin v%s for backend %s]",
                                                        GlobalAPI_Plugin_Version, GlobalAPI_Backend_Version);

    char[] padding = new char[paddingSize];
    for (int i = 0; i < paddingSize; i++)
    {
        padding[i] = '-';
    }

    PrintToConsole(client, padding);
    PrintToConsole(client, infoStr);
    PrintToConsole(client, padding);
    PrintToConsole(client, "-- Tickrate:  \t\t %d", RoundFloat(1.0 / GetTickInterval()));
    PrintToConsole(client, "-- Staging:   \t\t %s", GlobalAPI_IsStaging() ? "Y" : "N");
    PrintToConsole(client, "-- Debugging: \t\t %s", GlobalAPI_IsDebugging() ? "Y" : "N");
}

static void PrintMapInfoToConsole(int client)
{
    PrintToConsole(client, "-- Map Name: \t\t %s", gC_mapName);
    PrintToConsole(client, "-- Map Path: \t\t %s", gC_mapPath);
    PrintToConsole(client, "-- Map Size: \t\t %d bytes", gI_mapFilesize);
}