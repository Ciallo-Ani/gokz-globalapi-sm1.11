// =========================================================== //

methodmap APIJumpstat < Handle
{
	public APIJumpstat(Handle hJump)
	{
		return view_as<APIJumpstat>(hJump);
	}

	property int Id
	{
		public get() { return json_object_get_int(this, "id"); }
	}

	property int serverId
	{
		public get() { return json_object_get_int(this, "server_id"); }
	}

	property int steamId64
	{
		public get() { return json_object_get_int(this, "steamid64"); }
	}

	public void GetName(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "player_name", buffer, maxlength);
	}

	public void GetSteamId(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "steam_id", buffer, maxlength);
	}

	property int jumpType
	{
		public get() { return json_object_get_int(this, "jump_type"); }
	}

	property float Distance
	{
		public get() { return json_object_get_float(this, "distance"); }
	}

	property int tickRate
	{
		public get() { return json_object_get_int(this, "tickrate"); }
	}

	property int mslCount
	{
		public get() { return json_object_get_int(this, "msl_count"); }
	}

	property int strafeCount
	{
		public get() { return json_object_get_int(this, "strafe_count"); }
	}

	property bool isCrouchBind
	{
		public get() { return json_object_get_bool(this, "is_crouch_bind"); }
	}

	property bool isForwardBind
	{
		public get() { return json_object_get_bool(this, "is_forward_bind"); }
	}

	property bool isCrouchBoost
	{
		public get() { return json_object_get_bool(this, "is_crouch_boost"); }
	}

	property int updatedById
	{
		public get() { return json_object_get_int(this, "updated_by_id"); }
	}

	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "created_on", buffer, maxlength);
	}

	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		json_object_get_string(this, "updated_on", buffer, maxlength);
	}
}

// =========================================================== //