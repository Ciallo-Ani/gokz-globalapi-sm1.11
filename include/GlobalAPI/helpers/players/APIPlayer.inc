// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Player_Helper_included_
#endinput
#endif
#define _GlobalAPI_Player_Helper_included_

// =========================================================== //

#include <json>
#include <GlobalAPI/iterable>

// =========================================================== //

methodmap APIPlayer < JSON_Object
{
	public APIPlayer(JSON_Object hPlayer)
	{
		return view_as<APIPlayer>(hPlayer);
	}
	
	property int steamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}
	
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}
	
	property bool isBanned
	{
		public get() { return this.GetBool("is_banned"); }
	}
	
	property int totalRecords
	{
		public get() { return this.GetInt("total_records"); }
	}
	
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}
}

// =========================================================== //