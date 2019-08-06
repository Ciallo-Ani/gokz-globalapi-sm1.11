// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Responses_included_
#endinput
#endif
#define _GlobalAPI_Responses_included_

// =========================================================== //

#include <json>
#include <GlobalAPI/iterable>

// =========================================================== //

methodmap APIAuth < JSON_Object
{
	public APIAuth(JSON_Object hAuth)
	{
		return view_as<APIAuth>(hAuth);
	}
	
   /**
 	* Gets auth "type" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn
 	*/
	public bool GetType(char[] buffer, int maxlength)
	{
		return this.GetString("type", buffer, maxlength);
	}
	
	/* 
		Gets auth "isValid" key from the response
	*/
	property bool IsValid
	{
		public get() { return this.GetBool("isValid"); }
	}
	
	/*
		Gets auth "identity" key from the response
	*/
	property int Identity
	{
		public get() { return this.GetInt("identity"); }
	}
}

// =========================================================== //

methodmap APIBan < JSON_Object
{
	public APIBan(JSON_Object hBan)
	{
		return view_as<APIBan>(hBan);
	}
	
	/*
		Gets ban "updatedById" key from the response
	*/
	property int UpdatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}
	
	/*
		Gets ban "id" key from the response
	*/
	property int Id
	{
		public get() { return this.GetInt("id"); }
	}
	
   /**
 	* Gets ban "stats" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn
 	*/
	public void GetStats(char[] buffer, int maxlength)
	{
		this.GetString("stats", buffer, maxlength);
	}
	
   /**
 	* Gets ban "ban_type" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetBanType(char[] buffer, int maxlength)
	{
		this.GetString("ban_type", buffer, maxlength);
	}
	
   /**
 	* Gets ban "expires_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetExpiresOn(char[] buffer, int maxlength)
	{
		this.GetString("expires_on", buffer, maxlength);
	}

	/*
		Gets ban "steamid64" key from the response
	*/
	property int SteamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}

   /**
 	* Gets ban "player_name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetPlayerName(char[] buffer, int maxlength)
	{
		this.GetString("player_name", buffer, maxlength);
	}

   /**
 	* Gets ban "notes" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetNotes(char[] buffer, int maxlength)
	{
		this.GetString("notes", buffer, maxlength);
	}

   /**
 	* Gets ban "steam_id" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}

   /**
 	* Gets ban "updated_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}

	/*
		Gets ban "server_id" key from the response
	*/
	property int ServerId
	{
		public get() { return this.GetInt("server_id"); }
	}

   /**
 	* Gets ban "created_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}
}

// =========================================================== //

methodmap APIJumpstat < JSON_Object
{
	public APIJumpstat(JSON_Object hJump)
	{
		return view_as<APIJumpstat>(hJump);
	}

	/*
		Gets jumpstat "id" key from the response
	*/
	property int Id
	{
		public get() { return this.GetInt("id"); }
	}

	/*
		Gets jumpstat "server_id" key from the response
	*/
	property int ServerId
	{
		public get() { return this.GetInt("server_id"); }
	}

	/*
		Gets jumpstat "steamid64" key from the response
	*/
	property int SteamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}

   /**
 	* Gets jumpstat "player_name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("player_name", buffer, maxlength);
	}

   /**
 	* Gets jumpstat "steam_id" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}

	/*
		Gets jumpstat "jump_type" key from the response
	*/
	property int JumpType
	{
		public get() { return this.GetInt("jump_type"); }
	}

	/*
		Gets jumpstat "distance" key from the response
	*/
	property float Distance
	{
		public get() { return this.GetFloat("distance"); }
	}

	/*
		Gets jumpstat "tickrate" key from the response
	*/
	property int TickRate
	{
		public get() { return this.GetInt("tickrate"); }
	}

	/*
		Gets jumpstat "msl_count" key from the response
	*/
	property int MslCount
	{
		public get() { return this.GetInt("msl_count"); }
	}

	/*
		Gets jumpstat "strafe_count" key from the response
	*/
	property int StrafeCount
	{
		public get() { return this.GetInt("strafe_count"); }
	}

	/*
		Gets jumpstat "is_crouch_bind" key from the response
	*/
	property bool IsCrouchBind
	{
		public get() { return this.GetBool("is_crouch_bind"); }
	}

	/*
		Gets jumpstat "is_forward_bind" key from the response
	*/
	property bool IsForwardBind
	{
		public get() { return this.GetBool("is_forward_bind"); }
	}

	/*
		Gets jumpstat "is_crouch_boost" key from the response
	*/
	property bool IsCrouchBoost
	{
		public get() { return this.GetBool("is_crouch_boost"); }
	}

	/*
		Gets jumpstat "updated_by_id" key from the response
	*/
	property int UpdatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}

   /**
 	* Gets jumpstat "created_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}

   /**
 	* Gets jumpstat "updated_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}
}

// =========================================================== //

methodmap APIMap < JSON_Object
{
	public APIMap(JSON_Object hMap)
	{
		return view_as<APIMap>(hMap);
	}
	
	/*
		Gets map "id" key from the response
	*/
	property int Id
	{
		public get() { return this.GetInt("id"); }
	}

   /**
 	* Gets map "name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}

	/*
		Gets map "filesize" key from the response
	*/
	property int Filesize
	{
		public get() { return this.GetInt("filesize"); }
	}

	/*
		Gets map "validated" key from the response
	*/
	property bool IsValidated
	{
		public get() { return this.GetBool("validated"); }
	}

	/*
		Gets map "difficulty" key from the response
	*/
	property int Difficulty
	{
		public get() { return this.GetInt("difficulty"); }
	}

   /**
 	* Gets map "created_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}

   /**
 	* Gets map "updated_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}

	/*
		Gets map "approved_by_steamid64" key from the response
	*/
	property int ApprovedBySteamId64
	{
		public get() { return this.GetInt("approved_by_steamid64"); }
	}
}

// =========================================================== //

methodmap APIMode < JSON_Object
{
	public APIMode(JSON_Object hMode)
	{
		return view_as<APIMode>(hMode);
	}
	
	/*
		Gets mode "id" key from the response
	*/
	property int Id
	{
		public get() { return this.GetInt("id"); }
	}

   /**
 	* Gets mode "name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}

   /**
 	* Gets mode "description" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetDescription(char[] buffer, int maxlength)
	{
		this.GetString("description", buffer, maxlength);
	}

	/*
		Gets mode "latest_version" key from the response
	*/
	property int LatestVersion
	{
		public get() { return this.GetInt("latest_version"); }
	}

   /**
 	* Gets mode "latest_version_description" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetLatestVersionDesc(char[] buffer, int maxlength)
	{
		this.GetString("latest_version_description", buffer, maxlength);
	}

   /**
 	* Gets mode "website" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetWebsite(char[] buffer, int maxlength)
	{
		this.GetString("website", buffer, maxlength);
	}

   /**
 	* Gets mode "repo" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetRepository(char[] buffer, int maxlength)
	{
		this.GetString("repo", buffer, maxlength);
	}

	/*
		Gets mode "contact_steamid64" key from the response
	*/
	property int ContactSteamId64
	{
		public get() { return this.GetInt("contact_steamid64"); }
	}
	
	// TODO: Add supported_tickrates

   /**
 	* Gets mode "created_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}

   /**
 	* Gets mode "updated_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}

	/*
		Gets mode "updated_by_id" key from the response
	*/
	property int UpdatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}
}

// =========================================================== //

methodmap APIPlayer < JSON_Object
{
	public APIPlayer(JSON_Object hPlayer)
	{
		return view_as<APIPlayer>(hPlayer);
	}
	
	/*
		Gets player "steamid64" key from the response
	*/
	property int SteamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}

   /**
 	* Gets player "steam_id" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}

	/*
		Gets player "is_banned" key from the response
	*/
	property bool IsBanned
	{
		public get() { return this.GetBool("is_banned"); }
	}

	/*
		Gets player "total_records" key from the response
	*/
	property int TotalRecords
	{
		public get() { return this.GetInt("total_records"); }
	}

   /**
 	* Gets player "name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}
}

// =========================================================== //

methodmap APIRecord < JSON_Object
{
	public APIRecord(JSON_Object hRecord)
	{
		return view_as<APIRecord>(hRecord);
	}
	
	/*
		Gets record "id" key from the response
	*/
	property int Id
	{
		public get() { return this.GetInt("id"); }
	}

	/*
		Gets record "steamid64" key from the response
	*/
	property int SteamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}

   /**
 	* Gets record "player_name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetPlayerName(char[] buffer, int maxlength)
	{
		this.GetString("player_name", buffer, maxlength);
	}

   /**
 	* Gets record "steam_id" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}

	/*
		Gets record "server_id" key from the response
	*/
	property int ServerId
	{
		public get() { return this.GetInt("server_id"); }
	}

	/*
		Gets record "map_id" key from the response
	*/
	property int MapId
	{
		public get() { return this.GetInt("map_id"); }
	}

	/*
		Gets record "stage" key from the response
	*/
	property int Stage
	{
		public get() { return this.GetInt("stage"); }
	}

   /**
 	* Gets record "mode" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetMode(char[] buffer, int maxlength)
	{
		this.GetString("mode", buffer, maxlength);
	}

	/*
		Gets record "tickrate" key from the response
	*/
	property int TickRate
	{
		public get() { return this.GetInt("tickrate"); }
	}

	/*
		Gets record "time" key from the response
	*/
	property float Time
	{
		public get() { return this.GetFloat("time"); }
	}

	/*
		Gets record "teleports" key from the response
	*/
	property int Teleports
	{
		public get() { return this.GetInt("teleports"); }
	}

   /**
 	* Gets record "created_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}

   /**
 	* Gets record "updated_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}

	/*
		Gets record "updated_by" key from the response
	*/
	property int UpdatedBySteamId64
	{
		public get() { return this.GetInt("updated_by"); }
	}

   /**
 	* Gets record "server_name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetServerName(char[] buffer, int maxlength)
	{
		this.GetString("server_name", buffer, maxlength);
	}

   /**
 	* Gets record "map_name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetMapName(char[] buffer, int maxlength)
	{
		this.GetString("map_name", buffer, maxlength);
	}
}

// =========================================================== //

methodmap APIServer < JSON_Object
{
	public APIServer(JSON_Object hServer)
	{
		return view_as<APIServer>(hServer);
	}
	
	/*
		Gets server "port" key from the response
	*/
	property int Port
	{
		public get() { return this.GetInt("port"); }
	}

   /**
 	* Gets server "ip" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetIPAddress(char[] buffer, int maxlength)
	{
		this.GetString("ip", buffer, maxlength);
	}

   /**
 	* Gets server "name" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn		
 	*/
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}

	/*
		Gets server "owner_steamid64" key from the response
	*/
	property int OwnerSteamId64
	{
		public get() { return this.GetInt("owner_steamid64"); }
	}
}

// =========================================================== //

methodmap APIRecordFilter < JSON_Object
{
	public APIRecordFilter(JSON_Object hRecordFilter)
	{
		return view_as<APIRecordFilter>(hRecordFilter);
	}
	
	/*
		Gets record filter "id" key from the response
	*/ 
	property int Id
	{
		public get() { return this.GetInt("id"); }
	}
	
	/*
		Gets record filter "map_id" key from the response
	*/ 
	property int MapId
	{
		public get() { return this.GetInt("map_id"); }
	}

	/*
		Gets record filter "stage" key from the response
	*/ 
	property int Stage
	{
		public get() { return this.GetInt("stage"); }
	}

	/*
		Gets record filter "mode_id" key from the response
	*/
	property int ModeId
	{
		public get() { return this.GetInt("mode_id"); }
	}
	
	/*
		Gets record filter "tickrate" key from the response
	*/
	property int TickRate
	{
		public get() { return this.GetInt("tickrate"); }
	}

	/*
		Gets record filter "has_teleports" key from the response
	*/
	property bool HasTeleports
	{
		public get() { return this.GetBool("has_teleports"); }
	}

   /**
 	* Gets record filter "created_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn
 	*/
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}

   /**
 	* Gets record filter "update_on" key from the response
	*
 	* @param buffer				Buffer to store result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn
 	*/
	public void GetUpdateOn(char[] buffer, int maxlength)
	{
		this.GetString("update_on", buffer, maxlength);
	}

	/*
		Gets record filter "updated_by_id" key from the response
	*/
	property int UpdatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}
}

// =========================================================== //