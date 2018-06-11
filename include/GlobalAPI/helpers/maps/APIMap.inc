// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Map_Helper_included_
#endinput
#endif
#define _GlobalAPI_Map_Helper_included_

// =========================================================== //

#include <json>
#include <GlobalAPI/iterable>

// =========================================================== //

methodmap APIMap < JSON_Object
{
	public APIMap(JSON_Object hMap)
	{
		return view_as<APIMap>(hMap);
	}
	
	property int id
	{
		public get() { return this.GetInt("id"); }
	}
	
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}
	
	property int fileSize
	{
		public get() { return this.GetInt("filesize"); }
	}
	
	property bool isValidated
	{
		public get() { return this.GetBool("validated"); }
	}
	
	property int difficulty
	{
		public get() { return this.GetInt("difficulty"); }
	}
	
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}
	
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}
	
	property int approvedBySteamId64
	{
		public get() { return this.GetInt("approved_by_steamid64"); }
	}
}

// =========================================================== //
