// ====================== DEFINITIONS ======================== //

#define PLUGIN_NAME "GlobalAPI-Stats-SQLite"

#define MAX_QUERY_LENGTH 256
#define CREATE_TABLE_REQUESTS "CREATE TABLE IF NOT EXISTS requests (endpoint TEXT, success BOOLEAN, responseTime INTEGER);"
#define INSERT_ROW_TO_REQUESTS "INSERT INTO requests (endpoint, success, responseTime) VALUES (\"%s\", %d, %d);"

char CREATE_VIEW_ENDPOINTS[] = 
"CREATE VIEW IF NOT EXISTS EndpointView"
..." AS"
..." SELECT"
..." t.*,"
..." (((1.0 * t.SuccessfulRequests) / (t.SuccessfulRequests + t.FailedRequests)) * 100) AS SuccessRate"
..." FROM"
..." ("
..." SELECT"
..." r.endpoint AS Endpoint,"
..." (count(*)) AS Samples,"
..." (AVG(r.responseTime)) AS AvgResponseTime,"
..." (select count(*) FROM requests r2 WHERE r2.endpoint = r.endpoint AND r2.success = 1) AS SuccessfulRequests,"
..." (select count(*) FROM requests r2 WHERE r2.endpoint = r.endpoint AND r2.success = 0) AS FailedRequests"
..." FROM"
..." requests as r"
..." GROUP by r.endpoint"
..." ) as t;"

// =========================================================== //

#include <GlobalAPI>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_Core = false;
Database gH_DB = null;

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = PLUGIN_NAME,
	author = "Sikari",
	description = "",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// =========================================================== //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary(PLUGIN_NAME);
}

public void OnPluginStart()
{
	char error[256];
	gH_DB = SQL_Connect(PLUGIN_NAME, true, error, sizeof(error));
	
	if (gH_DB == null)
	{
		SetFailState("[%s] Database connection failure! (%s)", PLUGIN_NAME, error);
	}
	
	char dbType[12];
	SQL_ReadDriver(gH_DB, dbType, sizeof(dbType));
	
	if (!StrEqual(dbType, "sqlite", false))
	{
		SetFailState("[%s] This plugin only supports SQLite!", PLUGIN_NAME);
	}

	SQL_LockDatabase(gH_DB);
	SQL_FastQuery(gH_DB, CREATE_TABLE_REQUESTS);
	SQL_FastQuery(gH_DB, CREATE_VIEW_ENDPOINTS);
	SQL_UnlockDatabase(gH_DB);
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("GlobalAPI"))
	{
		gB_Core = true;
		GlobalAPI_LoadModule(ModuleType_Stats);
	}
}

public void OnPluginEnd()
{
	if (gB_Core)
	{
		GlobalAPI_UnloadModule(ModuleType_Stats);
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

public void GlobalAPI_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
	int responseTime = hData.ResponseTime;
	bool responseSuccess = !hData.Failure;
		
	char endpoint[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("endpoint", endpoint, sizeof(endpoint));
	GetEndpointFromRequestUrl(endpoint, endpoint, sizeof(endpoint));

	char query[MAX_QUERY_LENGTH];
	Format(query, sizeof(query), INSERT_ROW_TO_REQUESTS, endpoint, responseSuccess, responseTime);
		
	Transaction txn = new Transaction();
	ArrayList queries = new ArrayList(ByteCountToCells(sizeof(query)));

	AddQueryToTransactionEx(txn, queries, query);
	SQL_ExecuteTransaction(gH_DB, txn, _, DB_Failure_Generic, .data = queries);
}

public void DB_Failure_Generic(Database db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	ArrayList queries = data;
	LogError("[%s] Transaction error: \"%s\"", PLUGIN_NAME, error);
	
	if (failIndex != -1)
	{
		char query[MAX_QUERY_LENGTH];
		queries.GetString(failIndex, query, sizeof(query));
		LogError("[%s] Transaction failed query: %s", PLUGIN_NAME, query);
	}
	
	delete queries;
}

// =========================================================== //

static void AddQueryToTransactionEx(Transaction txn, ArrayList queries, char[] query)
{
	txn.AddQuery(query);
	queries.PushString(query);
}

static void GetEndpointFromRequestUrl(char[] endpoint, char[] buffer, int maxlength)
{
	char temp[GlobalAPI_Max_BaseUrl_Length];
	strcopy(temp, sizeof(temp), endpoint);
	
	if (!GlobalAPI_IsStaging())
	{
		ReplaceString(temp, sizeof(temp), GlobalAPI_BaseUrl, "prod/" ... GlobalAPI_Backend_Version);
	}
	else
	{
		ReplaceString(temp, sizeof(temp), GlobalAPI_Staging_BaseUrl, "staging/" ... GlobalAPI_Backend_Staging_Version);
	}
	
	strcopy(buffer, maxlength, temp);
}

// =========================================================== //