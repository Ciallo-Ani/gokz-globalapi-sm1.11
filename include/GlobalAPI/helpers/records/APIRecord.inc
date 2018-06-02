// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Record_Helper_included_
#endinput
#endif
#define _GlobalAPI_Record_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIRecord < JSON_Object
{
	public APIRecord(JSON_Object hRecord)
	{
		return view_as<APIRecord>(hRecord);
	}
	
	property int id
	{
		public get() { return this.GetInt("id"); }
	}
	
	property int steamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}
	
	public void GetPlayerName(char[] buffer, int maxlength)
	{
		this.GetString("player_name", buffer, maxlength);
	}
	
	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}
	
	property int serverId
	{
		public get() { return this.GetInt("server_id"); }
	}
	
	property int mapId
	{
		public get() { return this.GetInt("map_id"); }
	}
	
	property int stage
	{
		public get() { return this.GetInt("stage"); }
	}
	
	public void GetMode(char[] buffer, int maxlength)
	{
		this.GetString("mode", buffer, maxlength);
	}
	
	property int tickRate
	{
		public get() { return this.GetInt("tickrate"); }
	}
	
	property float time
	{
		public get() { return this.GetFloat("time"); }
	}
	
	property int teleports
	{
		public get() { return this.GetInt("teleports"); }
	}
	
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}
	
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}
	
	property int updatedBySteamId64
	{
		public get() { return this.GetInt("updated_by"); }
	}
	
	public void GetServerName(char[] buffer, int maxlength)
	{
		this.GetString("server_name", buffer, maxlength);
	}
	
	public void GetMapName(char[] buffer, int maxlength)
	{
		this.GetString("map_name", buffer, maxlength);
	}
}

// =========================================================== //