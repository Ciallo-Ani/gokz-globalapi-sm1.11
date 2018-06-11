// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Ban_Helper_included_
#endinput
#endif
#define _GlobalAPI_Ban_Helper_included_

// =========================================================== //

#include <json>
#include <GlobalAPI/iterable>

// =========================================================== //

methodmap APIBan < JSON_Object
{
	public APIBan(JSON_Object hBan)
	{
		return view_as<APIBan>(hBan);
	}
	
	property int updatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}
	
	property int id
	{
		public get() { return this.GetInt("id"); }
	}
	
	public void GetStats(char[] buffer, int maxlength)
	{
		this.GetString("stats", buffer, maxlength);
	}
	
	public void GetBanType(char[] buffer, int maxlength)
	{
		this.GetString("ban_type", buffer, maxlength);
	}
	
	public void GetExpiresOn(char[] buffer, int maxlength)
	{
		this.GetString("expires_on", buffer, maxlength);
	}

	property int steamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}
	
	public void GetPlayerName(char[] buffer, int maxlength)
	{
		this.GetString("player_name", buffer, maxlength);
	}
	
	public void GetNotes(char[] buffer, int maxlength)
	{
		this.GetString("notes", buffer, maxlength);
	}
	
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}
	
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}
	
	property int serverId
	{
		public get() { return this.GetInt("server_id"); }
	}
	
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}
	
}

// =========================================================== //