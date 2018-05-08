// =========================================================== //

methodmap APIJumpstat < JSON_Object
{
	public APIJumpstat(JSON_Object hJump)
	{
		return view_as<APIJumpstat>(hJump);
	}

	property int Id
	{
		public get() { return this.GetInt("id"); }
	}

	property int serverId
	{
		public get() { return this.GetInt("server_id"); }
	}

	property int steamId64
	{
		public get() { return this.GetInt("steamid64"); }
	}

	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("player_name", buffer, maxlength);
	}

	public void GetSteamId(char[] buffer, int maxlength)
	{
		this.GetString("steam_id", buffer, maxlength);
	}

	property int jumpType
	{
		public get() { return this.GetInt("jump_type"); }
	}

	property float Distance
	{
		public get() { return this.GetFloat("distance"); }
	}

	property int tickRate
	{
		public get() { return this.GetInt("tickrate"); }
	}

	property int mslCount
	{
		public get() { return this.GetInt("msl_count"); }
	}

	property int strafeCount
	{
		public get() { return this.GetInt("strafe_count"); }
	}

	property bool isCrouchBind
	{
		public get() { return this.GetBool("is_crouch_bind"); }
	}

	property bool isForwardBind
	{
		public get() { return this.GetBool("is_forward_bind"); }
	}

	property bool isCrouchBoost
	{
		public get() { return this.GetBool("is_crouch_boost"); }
	}

	property int updatedById
	{
		public get() { return this.GetInt("updated_by_id"); }
	}

	public void GetCreatedOn(char[] buffer, int maxlength)
	{
		this.GetString("created_on", buffer, maxlength);
	}

	public void GetUpdatedOn(char[] buffer, int maxlength)
	{
		this.GetString("updated_on", buffer, maxlength);
	}
}

// =========================================================== //