// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_included_
#endinput
#endif
#define _GlobalAPI_included_

// =========================================================== //

#include <GlobalAPI/requestdata>

// ======================= DEFINITIONS ======================= //

#define GlobalAPI_Plugin_Version "2.0.0"
#define GlobalAPI_Plugin_Desc "Plugin helper for GlobalAPI " ... GlobalAPI_Version
#define GlobalAPI_Plugin_Url "https://bitbucket.org/kztimerglobalteam/GlobalAPI-SMPlugin"

#define GlobalAPI_Version "v1.0"
#define GlobalAPI_Staging_Version "v1.0"
#define GlobalAPI_BaseUrl "https://kztimerglobal.com/api/" ... GlobalAPI_Version
#define GlobalAPI_Staging_BaseUrl "https://staging.kztimerglobal.com/api/" ... GlobalAPI_Staging_Version

#define GlobalAPI_Max_APIKey_Length 128
#define GlobalAPI_Max_BaseUrl_Length 128
#define GlobalAPI_Max_QueryParam_Num 20
#define GlobalAPI_Max_QueryParam_Length 64
#define GlobalAPI_Max_QueryParams_Length 1280
#define GlobalAPI_Max_QueryUrl_Length 2048
#define GlobalAPI_Max_PluginName_Length 64

#define DEFAULT_INT -1
#define DEFAULT_STRING ""
#define DEFAULT_FLOAT -1.0
#define DEFAULT_BOOL view_as<bool>(-1)

// ======================= ENUMS ============================= //

enum
{
	GlobalAPIRequestType_GET = 0,
	GlobalAPIRequestType_POST
}

// ======================= TYPEDEFS ========================== //

typeset OnAPICallFinished
{
	function void(JSON_Object hResponse, GlobalAPIRequestData hData);
	function void(JSON_Object hResponse, GlobalAPIRequestData hData, any data);
}

// ======================= FORWARDS ========================== //

/**
 * Called when GlobalAPI plugin is initialized
 * This means API Key is loaded and all the cvars are loaded
 *
 * @noreturn
 */
forward void GlobalAPI_OnInitialized();

/**
 * Called when GlobalAPI plugin has failed a request
 *
 * @param request		Handle to the request started
 * @param hData			Handle to request's GlobalAPIRequestData
 * @noreturn
 */
forward void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData);

/**
 * Called when GlobalAPI plugin has started a request
 *
 * @param request		Handle to the request started
 * @param hData			Handle to request's GlobalAPIRequestData
 * @noreturn
 */
forward void GlobalAPI_OnRequestStarted(Handle request, GlobalAPIRequestData hData);

/**
 * Called when GlobalAPI plugin has finished a request
 *
 * @param request		Handle to the request started
 * @param hData			Handle to request's GlobalAPIRequestData
 * @noreturn
 */
forward void GlobalAPI_OnRequestFinished(Handle request, GlobalAPIRequestData hData);

// ======================= NATIVES =========================== //

/**
 * Gets the API Key used by GlobalAPI plugin
 *
 * @param buffer			Buffer to store result in
 * @param maxlength			Max length of the buffer
 * @noreturn		
 */
native void GlobalAPI_GetAPIKey(char[] buffer, int maxlength);

/**
 * Gets whether GlobalAPI is using an API Key
 *
 * @note					This does not mean the API Key is valid!
 * @return					Whether API Key is used by GlobalAPI plugin
 */
native bool GlobalAPI_HasAPIKey();

/**
 * Gets whether GlobalAPI is using the staging endpoint
 *
 * @note					It is not safe to call this before GlobalAPI_OnInitialized!
 * @return					Whether staging endpoint is used by GlobalAPI plugin
 */
native bool GlobalAPI_IsStaging();

/**
 * Gets whether GlobalAPI is in debug mode
 *
 * @note					It is not safe to call this before GlobalAPI_OnInitialized!
 * @return					Whether GlobalAPI plugin is in debug mode
 */
native bool GlobalAPI_IsDebugging();

/**
 * Sends a request in GlobalAPI plugin format
 *
 * @param hData				Handle to GlobalAPIRequestData
 * @return					Whether the request was sent successfully
 */
native bool GlobalAPI_SendRequest(GlobalAPIRequestData hData);

/**
 * Loads calling plugin as a logging module
 *
 * @return					Whether the module was successfully loaded
 */
native bool GlobalAPI_Logging_LoadModule();

/**
 * Unloads calling plugin from logging modules
 *
 * @return					Whether the module was successfully unloaded
 */
native bool GlobalAPI_Logging_UnloadModule();

/**
 * Gets number of logging modules loaded
 *
 * @return					Number of logging modules loaded
 */
native int GlobalAPI_Logging_GetModuleCount();

/**
 * Gets a copy of logging modules as an ArrayList
 *
 * @note					Plugins in the arraylist are simply plugin handles
 * @return					ArrayList handle of logging modules
 */
native ArrayList GlobalAPI_Logging_GetModuleList();

/**
 * Loads calling plugin as a retrying module
 *
 * @return					Whether the module was successfully loaded
 */
native bool GlobalAPI_Retrying_LoadModule();

/**
 * Unloads calling plugin from retrying modules
 *
 * @return					Whether the module was successfully unloaded
 */
native bool GlobalAPI_Retrying_UnloadModule();

/**
 * Gets number of retrying modules loaded
 *
 * @return					Number of retrying modules loaded
 */
native int GlobalAPI_Retrying_GetModuleCount();

/**
 * Gets a copy of retrying modules as an ArrayList
 *
 * @note					Plugins in the arraylist are simply plugin handles
 * @return					ArrayList handle of retrying modules
 */
native ArrayList GlobalAPI_Retrying_GetModuleList();

/**
 * Starts a GET HTTP Request to /api/{version}/auth/status
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);

/**
 * Starts a GET HTTP Request to /api/{version}/bans
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param banTypes			Ban types to query
 * @param banTypesList		-Unsupported at the moment-
 * @param isExpired			Whether to query for isExpired or not
 * @param ipAddress			IP address to query
 * @param steamId64			SteamID64 to query
 * @param steamId			SteamID2 to query
 * @param notesContain		Notes to query
 * @param statsContain		Stats to query
 * @param serverId			Server ID to query
 * @param createdSince		Created since date to query
 * @param updatedSince		Updated since date to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] banTypes = DEFAULT_STRING,
								const char[] banTypesList = DEFAULT_STRING, bool isExpired = DEFAULT_BOOL, const char[] ipAddress = DEFAULT_STRING,
								int steamId64 = DEFAULT_INT, const char[] steamId = DEFAULT_STRING, const char[] notesContain = DEFAULT_STRING,
								const char[] statsContain = DEFAULT_STRING, int serverId = DEFAULT_INT, const char[] createdSince = DEFAULT_STRING,
								const char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a POST HTTP Request to /api/{version}/bans
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 of the user
 * @param banType			Type of the ban
 * @param stats				Stats of the ban
 * @param notes				Notes of the ban
 * @param ipAddress			IP address of the user
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									const char[] steamId, const char[] banType, const char[] stats,
									const char[] notes, const char[] ipAddress);

/**
 * Starts a GET HTTP Request to /api/{version}/jumpstats
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param id				Id to query
 * @param serverId			Server id to query
 * @param steamId64			SteamID64 to query
 * @param steamId			SteamID2 to query
 * @param jumpType			Jump type to query
 * @param steamId64List		-Unsupported at the moment-
 * @param jumpTypeList		-Unsupported at the moment-
 * @param greaterThanDist	Greater than distance to query
 * @param lessThanDist		Less than distance to query
 * @param isMsl				Whether to query for isMsl or not
 * @param isCrouchBind		Whether to query for isCrouchBind or not
 * @param isForwardBind		Whether to query for isForwardBind or not
 * @param isCrouchBoost		Whether to query for isCrouchBoost or not
 * @param updatedById		Updated by id to query
 * @param createdSince		Created since date to query
 * @param updatedSince		Updated since date to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = DEFAULT_INT,
									int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT, const char[] steamId = DEFAULT_STRING,
									const char[] jumpType = DEFAULT_STRING, const char[] steamId64List = DEFAULT_STRING,
									const char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
									float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL, bool isCrouchBind = DEFAULT_BOOL,
									bool isForwardBind = DEFAULT_BOOL, bool isCrouchBoost = DEFAULT_BOOL, int updatedById = DEFAULT_INT,
									const char[] createdSince = DEFAULT_STRING, const char[] updatedSince = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a POST HTTP Request to /api/{version}/jumpstats
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 of the user
 * @param jumpType			Type of the jump
 * @param distance			Distance of the jump
 * @param jumpJsonInfo		Data of the jump
 * @param tickRate			Tickrate of the server
 * @param mslCount			Msl count of the jump
 * @param isCrouchBind		Whether crouch bind was used
 * @param isForwardBind		Whether forward bind was used
 * @param isCrouchBoost		Whether crouch boost was used
 * @param strafeCount		Strafe count of the jump
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId,
										int jumpType, float distance, const char[] jumpJsonInfo, int tickRate, int mslCount,
										bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);

/**
 * Starts a GET HTTP Request to /api/{version}/jumpstats/{jump_type}/top
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param jumpType			Jump type to query
 * @param id				Id to query
 * @param serverId			Server Id to query
 * @param steamId64			SteamID64 to query
 * @param steamId			SteamID2 to query
 * @param steamId64List		-Unsupported at the moment-
 * @param jumpTypeList		-Unsupported at the moment-
 * @param greaterThanDist	Greater than distance to query
 * @param lessThanDist		Less than distance to query
 * @param isMsl				Whether to query for isMsl or not
 * @param isCrouchBind		Whether to query for isCrouchBind or not
 * @param isForwardBind		Whether to query for isForwardBind or not
 * @param isCrouchBoost		Whether to query for isCrouchBoost or not
 * @param updatedById		Updated by id to query
 * @param createdSince		Created since date to query
 * @param updatedSince		Updated since date to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetJumpstatTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] jumpType,
										int id = DEFAULT_INT, int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT,
										const char[] steamId = DEFAULT_STRING, const char[] steamId64List = DEFAULT_STRING,
										const char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
										float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL, bool isCrouchBind = DEFAULT_BOOL,
										bool isForwardBind = DEFAULT_BOOL, bool isCrouchBoost = DEFAULT_BOOL, int updatedById = DEFAULT_INT,
										const char[] createdSince = DEFAULT_STRING, const char[] updatedSince = DEFAULT_STRING,
										int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a GET HTTP Request to /api/{version}/jumpstats/{jump_type}/top30
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param jumpType			Jump type to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetJumpstatTop30(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] jumpType);

/**
 * Starts a GET HTTP Request to /api/{version}/maps
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param name				Map name to query
 * @param largerThanSize	Larger than filesize to query
 * @param smallerThanSize	Smaller than filesize to query
 * @param isValidated		Whether to query for isValidated or not
 * @param difficulty		Map difficulty to query
 * @param createdSince		Created since date to query
 * @param updatedSince 		Updated since date to query 
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetMaps(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] name = DEFAULT_STRING,
								int largerThanFilesize = DEFAULT_INT, int smallerThanFilesize = DEFAULT_INT, bool isValidated = DEFAULT_BOOL,
								int difficulty = DEFAULT_INT, const char[] createdSince = DEFAULT_STRING, const char[] updatedSince = DEFAULT_STRING,
								int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a GET HTTP Request to /api/{version}/maps/{id}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param id				Map id to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetMapById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

/**
 * Starts a GET HTTP Request to /api/{version}/maps/name/{map_name}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param name				Map name to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetMapByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] name);

/**
 * Starts a GET HTTP Request to /api/{version}/modes
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetModes(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);

/**
 * Starts a GET HTTP Request to /api/{version}/modes/id/{id}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param id				Mode id to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetModeById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

/**
 * Starts a GET HTTP Request to /api/{version}/modes/name/{mode_name}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param name				Mode name to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetModeByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] name);

/**
 * Starts a GET HTTP Request to /api/{version}/players
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 to query
 * @param isBanned			Whether to query for isBanned or not
 * @param totalRecords		Total records to query
 * @param ipAddress			IP address to query
 * @param steamId64List		-Unsupported at the moment-
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetPlayers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId = DEFAULT_STRING,
									bool isBanned = DEFAULT_BOOL, int totalRecords = DEFAULT_INT, const char[] ipAddress = DEFAULT_STRING,
									const char[] steamId64List = DEFAULT_STRING);

/**
 * Starts a GET HTTP Request to /api/{version}/players/steamid/{steamid}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetPlayerBySteamId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId);

/**
 * Starts a GET HTTP Request to /api/{version}/players/steamid/{steamid}/ip/{ip}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 to query
 * @param ipAddress			IP address to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetPlayerBySteamIdAndIp(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
												const char[] steamId, const char[] ipAddress);

/**
 * Starts a GET HTTP Request to /api/{version}/records
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param mapName			Map name to query
 * @param modes				Mode(s) to query
 * @param tickRate			Tickrate to query
 * @param steamId			SteamID2 to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetRecords(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] mapName = DEFAULT_STRING,
									const char[] modes = DEFAULT_STRING, int tickRate = DEFAULT_INT, const char[] steamId = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a POST HTTP Request to /api/{version}/records
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 of the user
 * @param mapId				Map id of the record
 * @param mode				Mode of the record
 * @param stage				Stage of the record
 * @param tickrate			Tickrate of the server
 * @param teleports			Teleport count of the record
 * @param time				Elapsed time of the record
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_CreateRecord(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] steamId,
									int mapId, const char[] mode, int stage, int tickRate, int teleports, float time);

// This is deprecated because this method returns the value in body W/O JSON
#pragma deprecated "This method does not return JSON at the moment!"
native bool GlobalAPI_GetRecordPlaceById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

/**
 * Starts a GET HTTP Request to /api/{version}/records/top
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 to query
 * @param steamId64			SteamID64 to query
 * @param mapId				Map id to query
 * @param mapName			Map name to query
 * @param tickRate			Tickrate to query
 * @param stage				Stage to query
 * @param modes				Mode(s) to query
 * @param hasTeleports		Whether to query for hasTeleports or not
 * @param playerName		Player name to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetRecordsTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
										const char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT,
										const char[] mapName = DEFAULT_STRING, int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
										const char[] modes = DEFAULT_STRING, bool hasTeleports = DEFAULT_BOOL,
										const char[] playerName = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a GET HTTP Request to /api/{version}/records/top/recent
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param steamId			SteamID2 to query
 * @param steamId64			SteamID64 to query
 * @param mapId				Map id to query
 * @param mapName			Map name to query
 * @param tickRate			Tickrate to query
 * @param stage				Stage to query
 * @param modes				Mode(s) to query
 * @param topAtLeast		Place top at least to query
 * @param topOverallAtLeast	Place top overall at least to query
 * @param hasTeleports		Whether to query for hasTeleports or not
 * @param createdSince		Created since date to query
 * @param playerName		Player name to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetRecordsTopRecent(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
											const char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT,
											int mapId = DEFAULT_INT, const char[] mapName = DEFAULT_STRING,
											int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
											const char[] modes = DEFAULT_STRING, int placeTopAtLeast = DEFAULT_INT,
											int placeTopOverallAtLeast = DEFAULT_INT, bool hasTeleports = DEFAULT_BOOL,
											const char[] createdSince = DEFAULT_STRING, const char[] playerName = DEFAULT_STRING,
											int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a GET HTTP Request to /api/{version}/servers
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param id				Id to query
 * @param port				Port to query
 * @param ip				IP address to query
 * @param name				Server name to query
 * @param ownerSteamId64	Owner's steamid64 to query
 * @param approvalStatus	Approval status to query
 * @param offset			Offset of the dataset to query
 * @param limit				Amount of items returned for the query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetServers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
									int id = DEFAULT_INT, int port = DEFAULT_INT, const char[] ip = DEFAULT_STRING,
									const char[] name = DEFAULT_STRING, int ownerSteamId64 = DEFAULT_INT,
									int approvalStatus = DEFAULT_INT, int offset = DEFAULT_INT, int limit = DEFAULT_INT);

/**
 * Starts a GET HTTP Request to /api/{version}/servers/{id}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param id				Id to query
 * @return					Whether request was successfully sent
 */
native bool GlobalAPI_GetServerById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);

/**
 * Starts a GET HTTP Request to /api/{version}/servers/name/{server_name}
 *
 * @param OnAPICallFinished	Callback when request has finished
 * @param data				Optional data to pass
 * @param serverName		Server name to query
 * @return					Whether request was successfully sent
 */
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
	MarkNativeAsOptional("GlobalAPI_HasAPIKey");
	MarkNativeAsOptional("GlobalAPI_IsStaging");
	MarkNativeAsOptional("GlobalAPI_IsDebugging");
	MarkNativeAsOptional("GlobalAPI_SendRequest");

	// Logging
	MarkNativeAsOptional("GlobalAPI_Logging_LoadModule");
	MarkNativeAsOptional("GlobalAPI_Logging_UnloadModule");
	MarkNativeAsOptional("GlobalAPI_Logging_GetModuleList");
	MarkNativeAsOptional("GlobalAPI_Logging_GetModuleCount");
	
	// Retrying
	MarkNativeAsOptional("GlobalAPI_Retrying_LoadModule");
	MarkNativeAsOptional("GlobalAPI_Retrying_UnloadModule");
	MarkNativeAsOptional("GlobalAPI_Retrying_GetModuleList");
	MarkNativeAsOptional("GlobalAPI_Retrying_GetModuleCount");

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
	MarkNativeAsOptional("GlobalAPI_GetMapById");
	MarkNativeAsOptional("GlobalAPI_GetMapByName");

	// Modes
	MarkNativeAsOptional("GlobalAPI_GetModes");
	MarkNativeAsOptional("GlobalAPI_GetModeById");
	MarkNativeAsOptional("GlobalAPI_GetModeByName");

	// Players
	MarkNativeAsOptional("GlobalAPI_GetPlayers");
	MarkNativeAsOptional("GlobalAPI_GetPlayerBySteamId");
	MarkNativeAsOptional("GlobalAPI_GetPlayerBySteamIdAndIp");

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