// =========================================================== //

methodmap APIJumpstats < Handle
{
	public APIJumpstats(Handle hJumps)
	{
		return view_as<APIJumpstats>(hJumps);
	}
	
	property int Count
	{
		public get() { return json_array_size(this); }
	}
	
	public Handle GetById(int index)
	{
		return json_array_get(this, index);
	}
}

// =========================================================== //