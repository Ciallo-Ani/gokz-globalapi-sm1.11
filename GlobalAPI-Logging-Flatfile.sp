// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI/stocks>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ======================= ENUMS ============================= //

enum LogType
{
    LogType_Failed,
    LogType_Started,
    LogType_Finished
};

enum LogLevel
{
    LogLevel_None = 0,
    LogLevel_Error,
    LogLevel_Info,
    LogLevel_Debug
};

// ====================== VARIABLES ========================== //

char gC_LogsDir[PLATFORM_MAX_PATH];

ConVar gCV_LoggingLevel = null;

static char gC_LogTypes[][] =
{
    "failed",
    "started",
    "finished"
};

static char gC_HTTPMethods[][] =
{
    "GET",
    "POST"
};

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo =
{
    name = "GlobalAPI-Logging-Flatfile",
    author = "The KZ Global Team",
    description = "Logging for GlobalAPI in Flatfile format",
    version = GlobalAPI_Plugin_Version,
    url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public void OnPluginStart()
{
    BuildPath(Path_SM, gC_LogsDir, sizeof(gC_LogsDir), "logs/GlobalAPI");

    if (!TryCreateDirectory(gC_LogsDir))
    {
        SetFailState("Failed to create directory %s", gC_LogsDir);
    }

    gCV_LoggingLevel = CreateConVar("globalapi_logging_level", "1", "Logging level", _, true, 0.0, true, 3.0);

    AutoExecConfig(true, "globalapi-logging");
}

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
    if (IsLevelEnabled(LogLevel_Error))
    {
        DoLog(LogType_Failed, hData);
    }
}

public void GlobalAPI_OnRequestStarted(Handle request, GlobalAPIRequestData hData)
{
    if (IsLevelEnabled(LogLevel_Debug))
    {
        DoLog(LogType_Started, hData);
    }
}

public void GlobalAPI_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
    if (IsLevelEnabled(LogLevel_Debug))
    {
        DoLog(LogType_Finished, hData);
    }
}

// =========================================================== //

void DoLog(LogType type, GlobalAPIRequestData hData)
{
    char logPath[PLATFORM_MAX_PATH];
    GetLogFilePathForType(type, logPath);

    char logPrefix[64];
    FormatTime(logPrefix, sizeof(logPrefix), "%m/%d/%Y - %H:%M:%S");

    char url[GlobalAPI_Max_BaseUrl_Length];
    hData.GetString("url", url, sizeof(url));

    char pluginName[GlobalAPI_Max_PluginName_Length];
    hData.GetString("pluginName", pluginName, sizeof(pluginName));

    char pluginVersion[GlobalAPI_Max_PluginVersion_Length];
    hData.GetString("pluginVersion", pluginVersion, sizeof(pluginVersion));

    char method[5] = "N/A";
    FormatEx(method, sizeof(method), gC_HTTPMethods[hData.RequestType]);

    File file = OpenFile(logPath, "a+");

    file.WriteLine("%s HTTP %s %s", logPrefix, method, gC_LogTypes[type]);
    file.WriteLine("%s  - Callee: %s (V.%s)", logPrefix, pluginName, pluginVersion);
    file.WriteLine("%s  - URL: %s", logPrefix, url);

    if (type == LogType_Finished)
    {
        file.WriteLine("%s  - Failure: %s", logPrefix, hData.Failure ? "YES" : "NO");
    }

    if (type == LogType_Finished || type == LogType_Failed)
    {
        file.WriteLine("%s  - Status: %d", logPrefix, hData.Status);
    }

    if (hData.RequestType == GlobalAPIRequestType_GET)
    {
        char params[GlobalAPI_Max_QueryParams_Length];
        hData.ToString(params, sizeof(params));

        if (strlen(params) > 0)
        {
            file.WriteLine("%s  - Query params: %s", logPrefix, params);
        }
    }
    else if (hData.RequestType == GlobalAPIRequestType_POST)
    {
        char body[8192];
        hData.Encode(body, sizeof(body));

        if (strlen(body) > 0)
        {
            file.WriteLine("%s  - Request body: %s", logPrefix, body);
        }
    }

    delete file;
}

bool IsLevelEnabled(LogLevel level)
{
    return gCV_LoggingLevel.IntValue >= view_as<int>(level);
}

void GetLogFilePathForType(LogType type, char buffer[PLATFORM_MAX_PATH])
{
    char date[64];
    FormatTime(date, sizeof(date), "%Y%m%d");

    Format(buffer, sizeof(buffer), "%s/%s_%s.log", gC_LogsDir, gC_LogTypes[type], date);
}
