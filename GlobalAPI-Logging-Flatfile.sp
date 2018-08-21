// ====================== DEFINITIONS ======================== //

#define LOGS_PATH "logs/GlobalAPI"
#define FAILEDLOG_NAME "GlobalAPI-failed"
#define STARTEDLOG_NAME "GlobalAPI-started"
#define FINISHEDLOG_NAME "GlobalAPI-finished"

// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-Stocks>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_Core = false;

// Paths
char gC_HTTPLogs_Directory[PLATFORM_MAX_PATH];
char gC_HTTPFailed_LogFile[PLATFORM_MAX_PATH];
char gC_HTTPStarted_LogFile[PLATFORM_MAX_PATH];
char gC_HTTPFinished_LogFile[PLATFORM_MAX_PATH];

// Phrases
char gC_HTTPMethodPhrases[][] = { "GET", "POST" };

// ======================= ENUMS ============================= //

enum BuildLogType
{
	BuildLog_Failed,
	BuildLog_Started,
	BuildLog_Finished
}

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Logging-Flatfile",
	author = "Sikari",
	description = "Flatfile logging for GlobalAPI",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Logging-Flatfile");
}

public void OnPluginStart()
{
	BuildPath(Path_SM, gC_HTTPLogs_Directory, sizeof(gC_HTTPLogs_Directory), LOGS_PATH);

	if (!CreateDirectoryIfNotExist(gC_HTTPLogs_Directory))
	{
		SetFailState("[GlobalAPI-Logging-Flatfile] Failed to create directory %s", gC_HTTPLogs_Directory);
	}
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("GlobalAPI"))
	{
		gB_Core = true;
		GlobalAPI_Logging_LoadModule();
	}
}

public void OnPluginEnd()
{
	if (gB_Core)
	{
		GlobalAPI_Logging_UnloadModule();
	}
}

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "GlobalAPI"))
	{
		gB_Core = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "GlobalAPI"))
	{
		gB_Core = false;
	}
}

// =========================================================== //

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	BuildDateToLogs(BuildLog_Failed);

	char params[GlobalAPI_Max_QueryParams_Length] = "-";
	hData.ToString(params, sizeof(params));

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char pluginName[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));

	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);

	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPFailed_LogFile, "a+");

	hLogFile.WriteLine("%s (%s) API call failed!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => Status: %d", logTag, hData.status);
	hLogFile.WriteLine("%s    => URL: %s", logTag, url);
	hLogFile.WriteLine("%s     => Params: %s", logTag, params);
	hLogFile.Close();
}

// =========================================================== //

public void GlobalAPI_OnRequestStarted(Handle request, GlobalAPIRequestData hData)
{
	BuildDateToLogs(BuildLog_Started);

	char params[GlobalAPI_Max_QueryParams_Length] = "-";
	hData.ToString(params, sizeof(params));

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char pluginName[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));

	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);

	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPStarted_LogFile, "a+");

	hLogFile.WriteLine("%s (%s) API call started!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => URL: %s", logTag, url);
	hLogFile.WriteLine("%s    => Params: %s", logTag, params);
	hLogFile.Close();
}

// =========================================================== //

public void GlobalAPI_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
	BuildDateToLogs(BuildLog_Finished);

	char params[GlobalAPI_Max_QueryParams_Length] = "-";
	hData.ToString(params, sizeof(params));

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char pluginName[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));

	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);

	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPFinished_LogFile, "a+");

	hLogFile.WriteLine("%s (%s) API call finished!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => Status: %d", logTag, hData.status);
	hLogFile.WriteLine("%s    => Failure: %s", logTag, hData.failure ? "YES" : "NO");
	hLogFile.WriteLine("%s     => URL: %s", logTag, url);
	hLogFile.WriteLine("%s      => Params: %s", logTag, params);
	hLogFile.Close();
}

// =========================================================== //

public void BuildDateToLogs(BuildLogType type)
{
	char date[64];
	FormatTime(date, sizeof(date), "%Y%m%d");

	switch(type)
	{
		case BuildLog_Failed:Format(gC_HTTPFailed_LogFile, sizeof(gC_HTTPFailed_LogFile), "%s/%s_%s.log", gC_HTTPLogs_Directory, FAILEDLOG_NAME, date);
		case BuildLog_Started:Format(gC_HTTPStarted_LogFile, sizeof(gC_HTTPStarted_LogFile), "%s/%s_%s.log", gC_HTTPLogs_Directory, STARTEDLOG_NAME, date);
		case BuildLog_Finished:Format(gC_HTTPFinished_LogFile, sizeof(gC_HTTPFinished_LogFile), "%s/%s_%s.log", gC_HTTPLogs_Directory, FINISHEDLOG_NAME, date);
	}
}

// =========================================================== //