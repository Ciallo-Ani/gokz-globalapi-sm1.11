// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_RequestData_included_
#endinput
#endif
#define _GlobalAPI_RequestData_included_

// =========================================================== //

#include <json>

// =========================================================== //

// TODO: Consider adding some of the properties on the constructor
// Such as isRetried, keyRequired, these properties are only set
// if the plugin does so, GetBool() would return false on
// non existing properties, but if we wanted to dump the properties
// these keys would not exist. This might be useful for debugging.

methodmap GlobalAPIRequestData < JSON_Object
{
	public GlobalAPIRequestData(char[] pluginName = "Unknown")
	{
		JSON_Object requestData = new JSON_Object();

		requestData.SetString("pluginName", pluginName);
		requestData.SetKeyHidden("pluginName", true);

		requestData.SetInt("acceptType", 0);
		requestData.SetKeyHidden("acceptType", true);

		requestData.SetInt("contentType", 0);
		requestData.SetKeyHidden("contentType", true);

		return view_as<GlobalAPIRequestData>(requestData);
	}

	public void SetDefault(char[] key)
	{
		this.SetHandle(key);
		this.SetKeyHidden(key, true);
	}

	public void AddUrl(char[] url)
	{
		this.SetString("url", url);
		this.SetKeyHidden("url", true);
	}

	public void AddDataPath(char[] path)
	{
		this.SetString("dataFilePath", path);
		this.SetKeyHidden("dataFilePath", true);
	}

	property int acceptType
	{
		public get()
		{
			return this.GetInt("acceptType");
		}
		public set(int type)
		{
			this.SetInt("acceptType", type);
		}
	}

	property int contentType
	{
		public get()
		{
			return this.GetInt("contentType");
		}
		public set(int type)
		{
			this.SetInt("contentType", type);
		}
	}
	
	property bool keyRequired
	{
		public get()
		{
			return this.GetBool("keyRequired");
		}
		public set(bool required)
		{
			this.SetBool("keyRequired", required);
			this.SetKeyHidden("keyRequired", true);
		}
	}
	
	property bool isRetried
	{
		public get()
		{
			return this.GetBool("isRetried");
		}
		public set(bool retried)
		{
			this.SetBool("isRetried", retried);
			this.SetKeyHidden("isRetried", true);
		}
	}
	
	property int bodyLength
	{
		public get()
		{
			return this.GetInt("bodyLength");
		}
		public set(int length)
		{
			this.SetInt("bodyLength", length);
			this.SetKeyHidden("bodyLength", true);
		}
	}

	property int status
	{
		public get()
		{
			return this.GetInt("status");
		}
		public set(int status)
		{
			this.SetInt("status", status);
			this.SetKeyHidden("status", true);
		}
	}

	property int responseTime
	{
		public get()
		{
			return this.GetInt("responseTime");
		}
		public set(int responseTime)
		{
			this.SetInt("responseTime", responseTime);
			this.SetKeyHidden("responseTime", true);
		}
	}

	property int requestType
	{
		public get()
		{
			return this.GetInt("requestType");
		}
		public set(int type)
		{
			this.SetInt("requestType", type);
			this.SetKeyHidden("requestType", true);
		}
	}

	property bool failure
	{
		public get()
		{
			return this.GetBool("failure");
		}
		public set(bool failure)
		{
			this.SetBool("failure", failure);
			this.SetKeyHidden("failure", true);
		}
	}

	property Handle callback
	{
		public get()
		{
			return view_as<Handle>(this.GetInt("callback"));
		}
		public set(Handle hFwd)
		{
			this.SetHandle("callback", hFwd);
			this.SetKeyType("callback", Type_Int);
			this.SetKeyHidden("callback", true);
		}
	}
	
	property any data
	{
		public get()
		{
			return this.GetInt("data");
		}
		public set(any data)
		{
			this.SetInt("data", data);
			this.SetKeyHidden("data", true);
		}
	}

	public void AddNum(char[] key, int value)
	{
		if (value == -1)
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetInt(key, value);
		}
	}

	public void AddFloat(char[] key, float value)
	{
		if (value == -1.000000)
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetFloat(key, value);
		}
	}

	public void AddString(char[] key, char[] value)
	{
		if (StrEqual(value, ""))
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetString(key, value);
		}
	}

	public void AddBool(char[] key, bool value)
	{
		if (value != true && value != false)
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetBool(key, value);
		}
	}

	public void ToString(char[] queryString, int maxlength)
	{
		StringMapSnapshot paramsMap = this.Snapshot();

		char key[64]; // MAX_QUERYPARAM_LENGTH
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