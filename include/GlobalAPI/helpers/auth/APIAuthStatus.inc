// =========================================================== //

methodmap APIAuthStatus < Handle
{
	public APIAuthStatus(Handle hAuth)
	{
		return view_as<APIAuthStatus>(hAuth);
	}
	
	public bool GetType(char[] buffer, int maxlength)
	{
		return json_object_get_string(this, "type", buffer, maxlength) > 0;
	}
	
	property bool isValid
	{
		public get() { return json_object_get_bool(this, "isValid"); }
	}
	
	property int Identity
	{
		public get() { return json_object_get_int(this, "identity"); }
	}
}

// =========================================================== //