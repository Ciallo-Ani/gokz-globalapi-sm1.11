// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-stocks>
#include <GlobalAPI/responses>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
    name = "GlobalAPI-Records-Stats",
    author = "Sikari",
    description = "",
    version = "1.0.0",
    url = ""
};

// ====================== VARIABLES ========================== //

// ...

// ======================= MAIN CODE ========================= //

public void GlobalAPI_OnInitialized()
{
	RegConsoleCmd("sm_globalapi_mapstats", GetStatsForMap);
}

public Action GetStatsForMap(int client, int args)
{	
	char temp[12];
	char mapName[128];
	GetCmdArg(1, mapName, sizeof(mapName));

	GetCmdArg(2, temp, sizeof(temp));
	int stage = StringToInt(temp);
	
	GetCmdArg(3, temp, sizeof(temp));
	int topNum = StringToInt(temp);
	
	GetCmdArg(4, temp, sizeof(temp));
	
	// Combined
	GlobalAPI_GetRecordsTop(OnRecordsGet,
							.stage = stage,
							.tickRate = 128,
							.modes = temp,
							.mapName = mapName,
							.limit = topNum);
	
	// TP
	GlobalAPI_GetRecordsTop(OnRecordsGet, 
							.hasTeleports = true,
							.stage = stage,
							.tickRate = 128,
							.modes = temp,
							.mapName = mapName,
							.limit = topNum);
	
	// Pro
	GlobalAPI_GetRecordsTop(OnRecordsGet, 
							.hasTeleports = false,
							.stage = stage,
							.tickRate = 128,
							.modes = temp,
							.mapName = mapName,
							.limit = topNum);
}

public void OnRecordsGet(JSON_Object hResponse, GlobalAPIRequestData hData)
{
	if (hData.failure == false)
	{
		APIIterable iterable = new APIIterable(hResponse);
		
		if (iterable != null)
		{
			FormatRecords(iterable, hData);
			delete iterable;
		}
	}
	else
	{
		LogMessage("Failure during HTTP Request!");
	}
	
	GlobalAPI_DebugMessage("<Get Records Top> executed in %d ms - status: %d", hData.responseTime, hData.status);
}

static void FormatRecords(APIIterable records, GlobalAPIRequestData hData)
{
	float totalTime = 0.0;
	float bestTime = -1.0;
	float worstTime = -1.0;
	int totalRecords = records.Count;
	
	for (int i = 0; i < totalRecords; i++)
	{
		APIRecord record = new APIRecord(records.GetById(i));
		
		if (i == 0)
		{
			bestTime = record.time;
		}
		else if (i == totalRecords -1)
		{
			worstTime = record.time;
		}

		totalTime += record.time;
		delete record;
	}
	
	char mapName[128];
	hData.GetString("map_name", mapName, sizeof(mapName));
	
	char mode[12];
	hData.GetString("modes_list_string", mode, sizeof(mode));
	
	char timeType[12];
	timeType = hData.GetKeyHidden("has_teleports") ? "Combined" : hData.GetBool("has_teleports") ? "TP" : "PRO";

	int limit = hData.GetInt("limit");
	int stage = hData.GetInt("stage");
	
	PrintToServer("[%s %s] Stats for Top %d - %s (Stage %d):", mode, timeType, limit, mapName, stage);
	PrintToServer("Best time: %s", FormatRecordTime(bestTime));
	PrintToServer("Worst time: %s", FormatRecordTime(worstTime));
	PrintToServer("Average Time: %s", FormatRecordTime((totalTime / totalRecords)));
}