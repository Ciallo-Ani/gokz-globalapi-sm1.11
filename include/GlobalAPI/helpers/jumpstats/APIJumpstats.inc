// =========================================================== //

methodmap APIJumpstats < JSON_Object
{
	public APIJumpstats(JSON_Object hJumps)
	{
		return view_as<APIJumpstats>(hJumps);
	}
	
	property int Count
	{
		public get() { return this.Length; }
	}
	
	public JSON_Object GetById(int index)
	{
		return this.GetObjectIndexed(index);
	}
}

// =========================================================== //