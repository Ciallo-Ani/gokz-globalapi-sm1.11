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



/*
	Helper methodmap for wrapping data related to requests
*/
methodmap GlobalAPIRequestData < JSON_Object
{
   /**
 	* Creates a new GlobalAPIRequestData
 	*
 	* @param pluginName			Name of the plugin
 	* @return					A new GlobalAPIRequestData handle
 	*/
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

   /**
 	* Sets a key as default
 	*
 	* @note						This sets them as "Handle" type
 	* @note						- See GlobalAPI.inc for default values
 	* @param key				Key to set as default
 	* @noreturn
 	*/
	public void SetDefault(char[] key)
	{
		this.SetHandle(key);
		this.SetKeyHidden(key, true);
	}
	
   /**
 	* Sets url to the request data
 	*
 	* @param url				Url to set
 	* @noreturn
 	*/
	public void AddUrl(char[] url)
	{
		this.SetString("url", url);
		this.SetKeyHidden("url", true);
	}
	
   /**
 	* Sets endpoint to the request data
 	*
 	* @param endpoint			Endpoint to set
 	* @noreturn
 	*/
	public void AddEndpoint(char[] endpoint)
	{
		this.SetString("endpoint", endpoint);
		this.SetKeyHidden("endpoint", true);
	}
	
   /**
	* Sets body file path to the request data
	*
	* @note						Path to file with data to be posted
	* @param path				Body file (path) to set
	* @noreturn
	*/
	public void AddBodyFile(char[] path)
	{
		this.SetString("bodyFile", path);
		this.SetKeyHidden("bodyFile", true);
	}

   /**
	* Sets data file path to the request data
	*
	* @note						Path for downloaded files
	* @param path				Data path to set
	* @noreturn
	*/
	public void AddDataPath(char[] path)
	{
		this.SetString("dataFilePath", path);
		this.SetKeyHidden("dataFilePath", true);
	}

    /*
 		Get or set the request's "acceptType"
 	*/
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

    /*
 		Get or set the request's "contentType"
 	*/
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
	
    /*
 		Get or set the request's "keyRequired"
 	*/
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
	
	/*
		Get or set the request's "isRetried"
 	*/
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
	
	/*
		Get or set the request's "bodyLength"
 	*/
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

    /*
 		Get or set the request's "status"
 	*/
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

    /*
 		Get or set the request's "responseTime"
 	*/
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

    /*
 		Get or set the request's "requestType"
 	*/
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

    /*
 		Get or set the request's "failure"
 	*/
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

    /*
 		Get or set the request's "callback"
 	*/
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
	
	/*
		Get or set the request's "data"
 	*/
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

   /**
 	* Adds a number to the request data
 	*
 	* @note						Default values are added as "defaults"
 	* @note						See GlobalAPI.inc for the default values
 	* @param key				Key name to set
 	* @param value				Value of the key
 	* @noreturn
 	*/
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

   /**
 	* Adds a float to the request data
 	*
 	* @note						Default values are added as "defaults"
 	* @note						See GlobalAPI.inc for the default values
 	* @param key				Key name to set
 	* @param value				Value of the key
 	* @noreturn
 	*/
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

   /**
 	* Adds a string to the request data
 	*
 	* @note						Default values are added as "defaults"
 	* @note						See GlobalAPI.inc for the default values
 	* @param key				Key name to set
 	* @param value				Value of the key
 	* @noreturn
 	*/
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

   /**
 	* Adds a boolean to the request data
 	*
 	* @note						Default values are added as "defaults"
 	* @note						See GlobalAPI.inc for the default values
 	* @param key				Key name to set
 	* @param value				Value of the key
 	* @noreturn
 	*/
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

   /**
 	* Converts all of the request data into a query string representation
 	*
 	* @note						This ignores "hidden" keys
 	* @param queryString		Buffer to store the result in
 	* @param maxlength			Max length of the buffer
 	* @noreturn
 	*/
	public void ToString(char[] queryString, int maxlength)
	{
		StringMapSnapshot paramsMap = this.Snapshot();

		char key[64];
		char value[1024];

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

/**
 * Converts a boolean into a string representation
 *
 * @param value					Boolean value to convert
 * @param buffer				Buffer to store the result in
 * @param maxlength				Max length of the buffer
 * @noreturn
 */
stock void BoolToString(bool value, char[] buffer, int maxlength)
{
	FormatEx(buffer, maxlength, "%s", value ? "true" : "false");
}

/**
 * Appends key and value into a query string representation
 *
 * @note						Index 0 "constructs" the query string, other numbers will "append"
 * @param index					Index of the key & value
 * @param buffer				Buffer to store result in
 * @param maxlength				Max length of the buffer
 * @param key					Key to append
 * @param value					Value of the key
 * @noreturn
 */
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