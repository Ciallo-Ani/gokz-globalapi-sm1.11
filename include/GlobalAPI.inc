// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_included_
#endinput
#endif
#define _GlobalAPI_included_

// =========================================================== //

#include <GlobalAPI/params>

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
	function void(bool bFailure, JSON_Object hJson, GlobalAPIRequestParams hData);
	function void(bool bFailure, JSON_Object hJson, GlobalAPIRequestParams hData, any data);
}

// ======================= FORWARDS ========================== //

forward void GlobalAPI_OnInitialized();

// ======================= NATIVES =========================== //

native void GlobalAPI_GetAPIKey(char[] buffer, int maxlength);

native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);


native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] banTypes = DEFAULT_STRING,
								char[] banTypesList = DEFAULT_STRING, bool isExpired = DEFAULT_BOOL, char[] ipAddress = DEFAULT_STRING,
								int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING, char[] notesContain = DEFAULT_STRING,
								char[] statsContain = DEFAULT_STRING, int serverId = DEFAULT_INT, char[] createdSince = DEFAULT_STRING,
								char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
								
native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
								char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip);

native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = DEFAULT_INT,
									int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING,
									char[] jumpType = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING, 
									char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
									float lessThanDistance = DEFAULT_FLOAT, char[] isMsl = DEFAULT_STRING,
									char[] isCrouchBind = DEFAULT_STRING, char[] isForwardBind = DEFAULT_STRING,
									char[] isCrouchBoost = DEFAULT_STRING, int updatedById = DEFAULT_INT,
									char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);

native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId,
										int jumpType, float distance, char[] jumpJsonInfo, int tickRate, int mslCount,
										bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);

native bool GlobalAPI_GetJumpstatTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] jumpType,
										int id = DEFAULT_INT, int serverId = DEFAULT_INT, char[] steamId64 = DEFAULT_STRING,
										char[] steamId = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING,
										char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
										float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL,
										bool isCrouchBind = DEFAULT_BOOL,bool isCrouchBoost = DEFAULT_BOOL,
										int updatedById = DEFAULT_INT, char[] createdSince = DEFAULT_STRING,
										char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);

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
	MarkNativeAsOptional("GlobalAPI_GetAPIKey");
	MarkNativeAsOptional("GlobalAPI_GetAuthStatus");
	
	MarkNativeAsOptional("GlobalAPI_GetBans");
	MarkNativeAsOptional("GlobalAPI_CreateBan");
	MarkNativeAsOptional("GlobalAPI_GetJumpstats");
}
#endif

// =========================================================== //