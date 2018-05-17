// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Params_included_
#endinput
#endif
#define _GlobalAPI_Params_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap GlobalAPIRequestParams < JSON_Object
{
	public GlobalAPIRequestParams()
	{
		return view_as<GlobalAPIRequestParams>(new JSON_Object());
	}

	public void SetDefault(char[] key)
	{
		this.SetKeyHidden(key, true);
		this.SetKeyType(key, Type_Null);
	}

	public void AddUrl(char[] url)
	{
		this.SetString("url", url);
		this.SetKeyHidden("url", true);
	}

	public void AddFailure(bool failure)
	{
		this.SetBool("failure", failure);
		this.SetKeyHidden("failure", true);
	}

	public void AddData(any data)
	{
		this.SetInt("data", data);
		this.SetKeyHidden("data", true);
	}

	public void AddCallback(Handle hFwd)
	{
		this.SetHandle("callback", hFwd);
		this.SetKeyHidden("callback", true);
		this.SetKeyType("callback", Type_Int);
	}

	public void AddNum(char[] key, int value)
	{
		this.SetInt(key, value);
		if (value == -1)
		{
			this.SetDefault(key);
		}
	}

	public void AddFloat(char[] key, float value)
	{
		this.SetFloat(key, value);
		if (value == -1.000000)
		{
			this.SetDefault(key);
		}
	}

	public void AddString(char[] key, char[] value)
	{
		this.SetString(key, value);
		if (StrEqual(value, ""))
		{
			this.SetDefault(key);
		}
	}

	public void AddBool(char[] key, bool value)
	{
		this.SetBool(key, value);
		if (value != true && value != false)
		{
			this.SetDefault(key);
		}
	}

	public void ToString(char[] queryString, int maxlength)
	{
		StringMapSnapshot paramsMap = this.Snapshot();

		char key[128];
		char value[1024]; // MAX_QUERYPARAM_LENGTH * 16

		int paramCount = 0;

		for (int i = 0; i < paramsMap.Length; i++)
		{
			paramsMap.GetKey(i, key, sizeof(key));

			if (!this.GetKeyHidden(key) && !json_is_meta_key(key))
			{
				switch(this.GetKeyType(key))
				{
					case Type_String:
					{
						this.GetString(key, value, sizeof(value));
					}
					case Type_Float:
					{
						float temp = this.GetFloat(key);
						FloatToString(temp, value, sizeof(value));
					}
					case Type_Int:
					{
						int temp = this.GetInt(key);
						IntToString(temp, value, sizeof(value));
					}
					case Type_Bool:
					{
						bool temp = this.GetBool(key);
						BoolToString(temp, value, sizeof(value));
					}
				}
				AppendToQueryString(paramCount, queryString, maxlength, key, value);
				paramCount++;
			}
		}
		delete paramsMap;
	}
}

// ======================== HELPERS ========================== //

stock void BoolToString(bool value, char[] buffer, int maxlength)
{
	FormatEx(buffer, maxlength, "%s", value ? "true" : "false");
}

stock void AppendToQueryString(int index, char[] buffer, int maxlength, char[] key, char[] value)
{
	if (index == 0)
	{
		Format(buffer, maxlength, "?%s=%s", key, value);
	}
	else
	{
		Format(buffer, maxlength, "%s&%s=%s", buffer, key, value);
	}
}

// =========================================================== //