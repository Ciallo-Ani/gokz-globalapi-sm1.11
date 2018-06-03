// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_included_
#endinput
#endif
#define _GlobalAPI_included_

// =========================================================== //

#include <GlobalAPI/requestdata>

// ======================= DEFINITIONS ======================= //

#define GlobalAPI_Version "v1.0"
#define GlobalAPI_Staging_Version "v1.0"
#define GlobalAPI_BaseUrl "https://kztimerglobal.com/api/" ... GlobalAPI_Version
#define GlobalAPI_Staging_BaseUrl "https://staging.kztimerglobal.com/api/" ... GlobalAPI_Staging_Version

#define GlobalAPI_Plugin_Version "2.0.0"
#define GlobalAPI_Plugin_Desc "Plugin helper for GlobalAPI " ... GlobalAPI_Version
#define GlobalAPI_Plugin_Url "https://bitbucket.org/kztimerglobalteam/GlobalAPI-SMPlugin"

#define DEFAULT_INT -1
#define DEFAULT_STRING ""
#define DEFAULT_FLOAT -1.0
#define DEFAULT_BOOL view_as<bool>(-1)

// ======================= ENUMS ============================= //

//...

// ======================= TYPEDEFS ========================== //

typeset OnAPICallFinished
{
	function void(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData);
	function void(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData, any data);
}

// ======================= FORWARDS ========================== //

forward void GlobalAPI_OnInitialized();

// ======================= NATIVES =========================== //

native void GlobalAPI_GetAPIKey(char[] buffer, int maxlength);

native bool GlobalAPI_GetStaging();

native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);


native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] banTypes = DEFAULT_STRING,
								const char[] banTypesList = DEFAULT_STRING, bool isExpired = DEFAULT_BOOL, const char[] ipAddress = DEFAULT_STRING,
								int steamId64 = DEFAULT_INT, const char[] steamId = DEFAULT_STRING, const char[] notesContain = DEFAULT_STRING,
								const char[] statsContain = DEFAULT_STRING, int serverId = DEFAULT_INT, const char[] createdSince = DEFAULT_STRING,
								const char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
								
native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									const char[] steamId, const char[] banType, const char[] stats,
									const char[] notes, const char[] ipAddress);

native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = DEFAULT_INT,
									int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT, const char[] steamId = DEFAULT_STRING,
									const char[] jumpType = DEFAULT_STRING, const char[] steamId64List = DEFAULT_STRING,
									const char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
									float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL, bool isCrouchBind = DEFAULT_BOOL,
									bool isForwardBind = DEFAULT_BOOL, bool isCrouchBoost = DEFAULT_BOOL, int updatedById = DEFAULT_INT,
									const char[] createdSince = DEFAULT_STRING, const char[] updatedSince = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId,
										int jumpType, float distance, const char[] jumpJsonInfo, int tickRate, int mslCount,
										bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);

native bool GlobalAPI_GetJumpstatTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] jumpType,
										int id = DEFAULT_INT, int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT,
										const char[] steamId = DEFAULT_STRING, const char[] steamId64List = DEFAULT_STRING,
										const char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
										float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL, bool isCrouchBind = DEFAULT_BOOL,
										bool isForwardBind = DEFAULT_BOOL, bool isCrouchBoost = DEFAULT_BOOL, int updatedById = DEFAULT_INT,
										const char[] createdSince = DEFAULT_STRING, const char[] updatedSince = DEFAULT_STRING,
										int offset = DEFAULT_INT, int limit = DEFAULT_INT);
										
native bool GlobalAPI_GetJumpstatTop30(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] jumpType);

native bool GlobalAPI_GetMaps(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] name = DEFAULT_STRING,
								int largerThanFilesize = DEFAULT_INT, int smallerThanFilesize = DEFAULT_INT, bool isValidated = DEFAULT_BOOL,
								int difficulty = DEFAULT_INT, const char[] createdSince = DEFAULT_STRING, const char[] updatedSince = DEFAULT_STRING,
								int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_GetModes(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);

native bool GlobalAPI_GetModeById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

native bool GlobalAPI_GetModeByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] name);

native bool GlobalAPI_GetPlayers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId = DEFAULT_STRING,
									bool isBanned = DEFAULT_BOOL, int totalRecords = DEFAULT_INT, const char[] ipAddress = DEFAULT_STRING,
									const char[] steamId64List = DEFAULT_STRING);

native bool GlobalAPI_GetPlayerBySteamId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId);

native bool GlobalAPI_GetPlayersBySteamIdAndIp(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
												const char[] steamId, const char[] ipAddress);

native bool GlobalAPI_GetRecords(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] mapName = DEFAULT_STRING,
									const char[] modes = DEFAULT_STRING, int tickRate = DEFAULT_INT, const char[] steamId = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_CreateRecord(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId,
									int mapId, const char[] mode, int stage, int tickRate, int teleports, float time);

#pragma deprecated "This method does not return JSON at the moment!"
native bool GlobalAPI_GetRecordPlaceById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

native bool GlobalAPI_GetRecordsTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
										const char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT,
										const char[] mapName = DEFAULT_STRING, int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
										const char[] modes = DEFAULT_STRING, bool hasTeleports = DEFAULT_BOOL,
										const char[] playerName = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_GetRecordsTopRecent(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
											const char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT,
											int mapId = DEFAULT_INT, const char[] mapName = DEFAULT_STRING,
											int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
											const char[] modes = DEFAULT_STRING, int placeTopAtLeast = DEFAULT_INT,
											int placeTopOverallAtLeast = DEFAULT_INT, bool hasTeleports = DEFAULT_BOOL,
											const char[] createdSince = DEFAULT_STRING, const char[] playerName = DEFAULT_STRING,
											int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_GetServers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									int id = DEFAULT_INT, int port = DEFAULT_INT, const char[] ip = DEFAULT_STRING,
									const char[] name = DEFAULT_STRING, int ownerSteamId64 = DEFAULT_INT,
									int approvalStatus = DEFAULT_INT, int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_GetServerById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

native bool GlobalAPI_GetServersByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] serverName);

// ======================= PLUGIN INFO ======================= //

public SharedPlugin __pl_GlobalAPI =
{
	name = "GlobalAPI",
	file = "GlobalAPI.smx",
	#if defined REQUIRE_PLUGIN
	required = 1,
	#else
	required = 0,
	#endif
};

// =========================================================== //

#if !defined REQUIRE_PLUGIN
public void __pl_GlobalAPI_SetNTVOptional()
{
	// Plugin
	MarkNativeAsOptional("GlobalAPI_GetAPIKey");

	// Auth
	MarkNativeAsOptional("GlobalAPI_GetAuthStatus");
	
	// Bans
	MarkNativeAsOptional("GlobalAPI_GetBans");
	MarkNativeAsOptional("GlobalAPI_CreateBan");

	// Jumpstats
	MarkNativeAsOptional("GlobalAPI_GetJumpstats");
	MarkNativeAsOptional("GlobalAPI_GetJumpstatTop");
	MarkNativeAsOptional("GlobalAPI_GetJumpstatTop30");

	// Maps
	MarkNativeAsOptional("GlobalAPI_GetMaps");

	// Modes
	MarkNativeAsOptional("GlobalAPI_GetModes");
	MarkNativeAsOptional("GlobalAPI_GetModeById");
	MarkNativeAsOptional("GlobalAPI_GetModeByName");

	// Players
	MarkNativeAsOptional("GlobalAPI_GetPlayers");
	MarkNativeAsOptional("GlobalAPI_GetPlayerBySteamId");
	MarkNativeAsOptional("GlobalAPI_GetPlayersBySteamIdAndIp");

	// Records
	MarkNativeAsOptional("GlobalAPI_GetRecords");
	MarkNativeAsOptional("GlobalAPI_CreateRecord");
	MarkNativeAsOptional("GlobalAPI_GetRecordPlaceById");
	MarkNativeAsOptional("GlobalAPI_GetRecordsTop");
	MarkNativeAsOptional("GlobalAPI_GetRecordsTopRecent");

	// Servers
	MarkNativeAsOptional("GlobalAPI_GetServers");
	MarkNativeAsOptional("GlobalAPI_GetServerById");
	MarkNativeAsOptional("GlobalAPI_GetServersByName");
}
#endif

// =========================================================== //