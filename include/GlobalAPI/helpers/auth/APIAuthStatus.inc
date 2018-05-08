// =========================================================== //

methodmap APIAuthStatus < JSON_Object
{
	public APIAuthStatus(JSON_Object hAuth)
	{
		return view_as<APIAuthStatus>(hAuth);
	}
	
	public bool GetType(char[] buffer, int maxlength)
	{
		return this.GetString("type", buffer, maxlength);
	}
	
	property bool isValid
	{
		public get() { return this.GetBool("isValid"); }
	}
	
	property int Identity
	{
		public get() { return this.GetInt("identity"); }
	}
}

// =========================================================== //