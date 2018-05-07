// =========================================================== //

//...

// =========================================================== //

methodmap GlobalAPIRequestParams < StringMap
{
	public GlobalAPIRequestParams()
	{
		return view_as<GlobalAPIRequestParams>(new StringMap());
	}
	
	public void Add(char[] key, char[] value)
	{
		TrimString(value);
		if (!StrEqual(value, "") && !StrEqual(value, "-1") && !StrEqual(value, "-1.000000"))
		{
			this.SetString(key, value);
		}
	}
	
	public void AddAll(StringMap hData)
	{
		StringMapSnapshot params = hData.Snapshot();
		
		char key[MAX_QUERYPARAM_LENGTH];
		char value[MAX_QUERYPARAM_LENGTH];
		
		for (int i; i < params.Length; i++)
		{
			params.GetKey(i, key, sizeof(key));

			if (!StrEqual(key, "callback") && !StrEqual(key, "data") && !StrEqual(key, "url"))
			{
				hData.GetString(key, value, sizeof(value));
				this.Add(key, value);
			}
		}
		params.Close();
	}
	
	public void Build(char[] queryString, int maxlength)
	{
		static char key[MAX_QUERYPARAM_LENGTH];
		static char value[MAX_QUERYPARAM_LENGTH];

		StringMapSnapshot paramsMap = this.Snapshot();
		
		for (int i = 0; i < paramsMap.Length; i++)
		{
			paramsMap.GetKey(i, key, sizeof(key));
			this.GetString(key, value, sizeof(value));
			
			if (i == 0)
			{
				Format(queryString, maxlength, "?%s=%s", key, value);
			}
			
			else
			{
				Format(queryString, maxlength, "%s&%s=%s", queryString, key, value);
			}
		}
		
		delete paramsMap;
		delete this;
	}
}

// =========================================================== //