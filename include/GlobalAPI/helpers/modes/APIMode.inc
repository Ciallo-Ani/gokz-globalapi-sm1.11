// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Mode_Helper_included_
#endinput
#endif
#define _GlobalAPI_Mode_Helper_included_

// =========================================================== //

#include <json>
#include <GlobalAPI/iterable>

// =========================================================== //

methodmap APIMode < JSON_Object
{
	public APIMode(JSON_Object hMode)
	{
		return view_as<APIMode>(hMode);
	}
	
	property int id
	{
		public get() { return this.GetInt("id"); }
	}
	
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}

	public void GetDescription(char[] buffer, int maxlength)
	{
		this.GetString("description", buffer, maxlength);
	}
	
	property int latestVersion
	{
		public get() { return this.GetInt("latest_version"); }
	}

	public void GetLatestVersionDesc(char[] buffer, int maxlength)
	{
		this.GetString("latest_version_description", buffer, maxlength);
	}
	
	public void GetWebsite(char[] buffer, int maxlength)
	{
		this.GetString("website", buffer, maxlength);
	}
	
	public void GetRepository(char[] buffer, int maxlength)
	{
		this.GetString("repo", buffer, maxlength);
	}
	
	property int contactSteamId64
	{
		public get() { return this.GetInt("contact_steamid64"); }
	}
	
	// TODO Add supported_tickrates
	
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}
	
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}
	
	property int updatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}
}

// =========================================================== //
