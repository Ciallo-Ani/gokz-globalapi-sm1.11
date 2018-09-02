// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Request_included_
#endinput
#endif
#define _GlobalAPI_Request_included_

// =========================================================== //

/*
	Helper methodmap for wrapping SteamWorks requests
*/
methodmap GlobalAPIRequest < Handle
{
   /**
 	* Creates a new GlobalAPIRequest
 	*
 	* @param url				URL of the request
 	* @param method				SteamWorks k_ETTPMethod of the request
 	* @return					A new GlobalAPIRequest handle
 	*/
	public GlobalAPIRequest(char[] url, EHTTPMethod method)
	{
		Handle request = SteamWorks_CreateHTTPRequest(method, url);
		return view_as<GlobalAPIRequest>(request);
	}

   /**
 	* Sets request timeout
 	*
 	* @param seconds			Timeout in seconds
 	* @return					Whether the operation was successful
 	*/
	public bool SetTimeout(int seconds)
	{
		return SteamWorks_SetHTTPRequestAbsoluteTimeoutMS(this, seconds * 1000);
	}
	
   /**
 	* Sets request body
 	*
 	* @note						Body is set as application/json
 	* @param body				Request body to set
 	* @param maxlength			Maxlength of the body
 	* @return					Whether the operation was successful
 	*/
	public bool SetBody(char[] body, int maxlength)
	{
		return SteamWorks_SetHTTPRequestRawPostBody(this, "application/json", body, maxlength);
	}
	
   /**
 	* Sets a request context value
 	*
 	* @param data				Any data to pass
 	* @return					Whether the operation was successful
 	*/
	public bool SetData(any data)
	{
		return SteamWorks_SetHTTPRequestContextValue(this, data);
	}
	
   /**
 	* Sets 2 request context values
 	*
 	* @param data				Any data to pass
 	* @param data2				Any other data to pass
 	* @return					Whether the operation was successful
 	*/
	public bool SetContextValue(any data1, any data2)
	{
		return SteamWorks_SetHTTPRequestContextValue(this, data1, data2);
	}
	
   /**
 	* Sets predefined HTTP callbacks
 	*
 	* @note						Predefined values respectively: 
	* @note 					Global_HTTP_Completed, Global_HTTP_Headers and Global_HTTP_DataReceived
 	* @noreturn
 	*/
	public void SetCallbacks()
	{
		SteamWorks_SetHTTPCallbacks(this, Global_HTTP_Completed, Global_HTTP_Headers, Global_HTTP_DataReceived);
	}
	
   /**
 	* Builds an authentication header
 	*
 	* @return					Whether the operation was successful
 	*/
	public bool SetAuthHeader()
	{
		return BuildAuthenticationHeader(this);
	}
	
   /**
 	* Sets predefined Accept, Accept-Charset and Accept-Encoding headers
 	*
 	* @note						Predefined values respectively: 
	* @note 					"application/json", "utf-8" and "gzip"
 	* @return					Whether the operation was successful
 	*/
	public bool SetAcceptHeaders()
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "Accept", "application/json")
		&& SteamWorks_SetHTTPRequestHeaderValue(this, "Accept-Charset", "utf-8")
		&& SteamWorks_SetHTTPRequestHeaderValue(this, "Accept-Encoding", "gzip");
	}
	
   /**
 	* Sets "powered by" header
 	*
 	* @return					Whether the operation was successful
 	*/
	public bool SetPoweredByHeader()
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "X-Powered-By", "GlobalAPI Plugin " ... GlobalAPI_Plugin_Version);
	}
	
   /**
 	* Sets request origin header
 	*
 	* @param hData				GlobalAPIRequestData handle containing "pluginName" key
 	* @return					Whether the operation was successful
 	*/
	public bool SetRequestOriginHeader(GlobalAPIRequestData hData)
	{
		char pluginName[GlobalAPI_Max_PluginName_Length + 12];
		hData.GetString("pluginName", pluginName, sizeof(pluginName));
		
		if (hData.isRetried) StrCat(pluginName, sizeof(pluginName), " [Retried]");
		return SteamWorks_SetHTTPRequestHeaderValue(this, "X-RequestOrigin", pluginName);
	}

   /**
 	* Sends our request with all available data
 	*
 	* @param hData				GlobalAPIRequestData handle with all required keys
 	* @return					Whether the operation was successful
 	*/
	public bool Send(GlobalAPIRequestData hData)
	{
		return SendRequest(this, hData);
	}
}

// =========================================================== //