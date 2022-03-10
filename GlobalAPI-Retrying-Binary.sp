// ====================== DEFINITIONS ======================== //

#define DATA_PATH "data/GlobalAPI-Retrying"
#define DATA_FILE "retrying_{timestamp}_{gametick}.dat"

// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI/stocks>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_Core = false;

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo =
{
	name = "GlobalAPI-Retrying-Binary",
	author = "The KZ Global Team",
	description = "Retrying for GlobalAPI in binary format",
	version = "1.0.0",
	url = GlobalAPI_Plugin_Url
};

// =========================================================== //

public void OnPluginStart()
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

	if (!CreateDirectoryIfNotExist(path))
	{
		SetFailState("[%s] Failed to create directory [%s]", PLUGIN_NAME, path);
	}

	// TODO: Rethink this?
	CreateTimer(30.0, CheckForRequests, _, TIMER_REPEAT);
}

public void OnAllPluginsLoaded()
{
	gB_Core = LibraryExists("GlobalAPI");
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

// ======================= MAIN CODE ========================= //

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	if (hData.RequestType == GlobalAPIRequestType_POST)
	{
		SaveRequestAsBinary(hData);
	}
}

public void SaveRequestAsBinary(GlobalAPIRequestData hData)
{
	char szTimestamp[32];
	IntToString(GetTime(), szTimestamp, sizeof(szTimestamp));

	char szGameTime[32];
	FloatToString(GetEngineTime(), szGameTime, sizeof(szGameTime));

	char dataFile[PLATFORM_MAX_PATH] = DATA_FILE;
	ReplaceString(dataFile, sizeof(dataFile), "{gametick}", szGameTime);
	ReplaceString(dataFile, sizeof(dataFile), "{timestamp}", szTimestamp);

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "%s/%s", DATA_PATH, dataFile);

	File binaryFile = OpenFile(path, "a+");

	if (binaryFile == null)
	{
		LogError("[%s] Could not open or create binary file [%s]", PLUGIN_NAME, path);
		return;
	}

	// Start preparing data
	int bodyLength = hData.BodyLength;

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char[] params = new char[bodyLength];
	hData.Encode(params, bodyLength);

	int requestType = hData.RequestType;
	bool keyRequired = hData.KeyRequired;

	binaryFile.WriteInt16(strlen(url));
	binaryFile.WriteString(url, false);
	binaryFile.WriteInt32(strlen(params));
	binaryFile.WriteString(params, false);
	binaryFile.WriteInt8(keyRequired);
	binaryFile.WriteInt8(requestType);
	binaryFile.WriteInt32(bodyLength);
	binaryFile.WriteInt32(StringToInt(szTimestamp));
	binaryFile.Close();
}

public Action CheckForRequests(Handle timer)
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

	DirectoryListing dataFiles = OpenDirectory(path);

	if (dataFiles == null)
	{
		LogError("[%s] Could not open directory [%s]", PLUGIN_NAME, path);
		delete dataFiles;
		return;
	}

	char dataFile[PLATFORM_MAX_PATH];
	while (dataFiles.GetNext(dataFile, sizeof(dataFile)))
	{
		if (!StrEqual(dataFile, ".") && !StrEqual(dataFile, ".."))
		{
			Format(dataFile, sizeof(dataFile), "%s/%s", path, dataFile);
			break;
		}
	}

	if (FileExists(dataFile))
	{
		File binaryFile = OpenFile(dataFile, "r");

		if (binaryFile == null)
		{
			LogError("[%s] Could not open binary file [%s]", PLUGIN_NAME, path);
			return;
		}

		int length;

		binaryFile.ReadInt16(length);
		char[] url = new char[length + 1];
		binaryFile.ReadString(url, length, length);
		url[length] = '\0';

		binaryFile.ReadInt32(length);
		char[] params = new char[length + 1];
		binaryFile.ReadString(params, length, length);
		params[length] = '\0';

		bool keyRequired;
		binaryFile.ReadInt8(keyRequired);

		int requestType;
		binaryFile.ReadInt8(requestType);

		int bodyLength;
		binaryFile.ReadInt32(bodyLength);

		int timestamp;
		binaryFile.ReadInt32(timestamp);
		binaryFile.Close();

		RetryRequest(url, params, keyRequired, requestType, bodyLength);
		DeleteFile(dataFile);
	}

	delete dataFiles;
}

public void RetryRequest(char[] url, char[] params, bool keyRequired, int requestType, int bodyLength)
{
	// Pack everything into GlobalAPI plugin friendly format
	GlobalAPIRequestData hData = new GlobalAPIRequestData(GetMyHandle());

	hData.AddUrl(url);
	hData.Decode(params);

	// These are set to null until
	// We have a reliable way of retrieving
	// The handles from the original plugin
	hData.Data = INVALID_HANDLE;
	hData.Callback = INVALID_HANDLE;

	hData.IsRetried = true;
	hData.BodyLength = bodyLength;
	hData.KeyRequired = keyRequired;
	hData.RequestType = requestType;

	GlobalAPI_SendRequest(hData);
}
