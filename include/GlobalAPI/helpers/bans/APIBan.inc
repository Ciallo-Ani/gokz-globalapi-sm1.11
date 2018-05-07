// =========================================================== //

methodmap APIBan < Handle
{
	public APIBan(Handle hBan)
	{
		return view_as<APIBan>(hBan);
	}
	
	property int updatedById
	{
		public get() { return json_object_get_int(this, "updated_by_id"); }
	}
	
	property int Id
	{
		public get() { return json_object_get_int(this, "id"); }
	}
	
	public void GetStats(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "stats", buffer, maxlength);
	}
	
	public void GetBanType(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "ban_type", buffer, maxlength);
	}
	
	public void GetExpiresOn(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "expires_on", buffer, maxlength);
	}

	property int steamId64
	{
		public get() { return json_object_get_int(this, "steamid64"); }
	}
	
	public void GetPlayerName(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "player_name", buffer, maxlength);
	}
	
	public void GetNotes(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "notes", buffer, maxlength);
	}
	
	public void GetSteamId(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "steam_id", buffer, maxlength);
	}
	
	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "updated_on", buffer, maxlength);
	}
	
	property int serverId
	{
		public get() { return json_object_get_int(this, "server_id"); }
	}
	
	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "created_on", buffer, maxlength);
	}
	
}

// =========================================================== //