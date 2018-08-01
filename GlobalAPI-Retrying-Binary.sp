// ====================== DEFINITIONS ======================== //

#define DATA_PATH "data/GlobalAPI-Retrying"
#define DATA_FILE "retrying_{timestamp}_{gametick}.dat"

// =========================================================== //

#include <GlobalAPI>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_Core = false;

// ======================= INCLUDES ========================== //

// ...

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Retrying-Binary",
	author = "Sikari",
	description = "",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// =========================================================== //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Retrying-Binary");
}

public void OnPluginStart()
{
	
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("GlobalAPI"))
	{
		gB_Core = true;
		GlobalAPI_Retrying_LoadModule();
	}
}

public void OnPluginEnd()
{
	if (gB_Core)
	{
		GlobalAPI_Retrying_UnloadModule();
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

// ======================= MAIN CODE ========================= //

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	if (hData.requestType == GlobalAPIRequestType_POST)
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
		LogError("Could not open or create binary file for retrying... [%s]", path);
		return;
	}

	// Start preparing data
	int bodyLength = hData.bodyLength;
	
	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char[] params = new char[bodyLength];
	hData.Encode(params, bodyLength);

	any data = hData.data;
	int timestamp = GetTime();
	Handle callback = hData.callback;
	int requestType = hData.requestType;
	bool keyRequired = hData.keyRequired;

	binaryFile.WriteInt8(strlen(url));
	binaryFile.WriteString(url, false);
	binaryFile.WriteInt8(strlen(params));
	binaryFile.WriteString(params, false);
	binaryFile.WriteInt8(keyRequired);
	binaryFile.WriteInt8(requestType);
	binaryFile.WriteInt32(bodyLength);
	binaryFile.WriteInt32(data);
	binaryFile.WriteInt32(view_as<int>(callback));
	binaryFile.WriteInt32(timestamp);

	PrintToServer("Writing %s %s %d %d %d %d %d %d to %s", url, params, keyRequired, requestType, bodyLength, data, callback, timestamp, path);

	binaryFile.Close();
}

public void OnCheckRequests()
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

	DirectoryListing dataFiles = OpenDirectory(path);

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
			LogError("Could not open binary file for retrying... [%s]", path);
			return;
		}

		int length;

		binaryFile.ReadInt8(length);
		char[] url = new char[length + 1];
		binaryFile.ReadString(url, length, length);
		url[length] = '\0';

		binaryFile.ReadInt8(length);
		char[] params = new char[length + 1];
		binaryFile.ReadString(params, length, length);
		params[length] = '\0';
		
		bool keyRequired;
		binaryFile.ReadInt8(keyRequired);
		
		int requestType;
		binaryFile.ReadInt8(requestType);
		
		int bodyLength;
		binaryFile.ReadInt32(bodyLength);

		any data;
		binaryFile.ReadInt32(data);

		Handle callback;
		binaryFile.ReadInt32(view_as<int>(callback));

		int timestamp;
		binaryFile.ReadInt32(timestamp);
		binaryFile.Close();

		PrintToServer("Reading %s %s %d %d %d %d %d %d from %s", url, params, keyRequired, requestType, bodyLength, data, callback, timestamp, dataFile);

		//RetryRequest(url, params, keyRequired, requestType, bodyLength, data, callback);

		DeleteFile(dataFile);
	}
}

// =========================================================== //