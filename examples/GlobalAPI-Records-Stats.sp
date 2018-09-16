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
	char mapName[128];
	GetCmdArg(1, mapName, sizeof(mapName));
	
	GlobalAPI_GetRecordsTop(OnRecordsGet,
							.stage = 0,
							.tickRate = 128,
							.mapName = mapName,
							.limit = 100);
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
	int totalItems = records.Count;
	float totalTime = 0.0;
	
	for (int i = 0; i < totalItems; i++)
	{
		APIRecord record = new APIRecord(records.GetById(i));
		totalTime += record.time;
	}
	
	char mapName[128];
	hData.GetString("map_name", mapName, sizeof(mapName));
	
	PrintToServer("Stats for %s:", mapName);
	PrintToServer("Average Time: %s", FormatRecordTime((totalTime / totalItems)));
}