// =========================================================== //

//...

// =========================================================== //

methodmap GlobalAPIRequest < Handle
{
	public GlobalAPIRequest(char[] url, EHTTPMethod method)
	{
		Handle request = SteamWorks_CreateHTTPRequest(method, url);
		return view_as<GlobalAPIRequest>(request);
	}
	
	property bool isTimedOut
	{
		public get()
		{ 
			bool value; 
			SteamWorks_GetHTTPRequestWasTimedOut(this, value);
			return value;
		}
	}

	public bool SetTimeout(int seconds)
	{
		return SteamWorks_SetHTTPRequestAbsoluteTimeoutMS(this, seconds * 1000);
	}
	
	public bool SetBody(char[] body, int maxlength)
	{
		return SteamWorks_SetHTTPRequestRawPostBody(this, "application/json", body, maxlength);
	}
	
	public bool SetData(any data)
	{
		return SteamWorks_SetHTTPRequestContextValue(this, data);
	}
	
	public bool SetContextValue(any data1, any data2)
	{
		return SteamWorks_SetHTTPRequestContextValue(this, data1, data2);
	}
	
	public void SetCallback(SteamWorksHTTPDataReceived dataReceived)
	{
		SteamWorks_SetHTTPCallbacks(this, HTTPCompleted, HTTPHeaders, dataReceived);
	}
	
	public bool SetAuthHeader()
	{
		return BuildAuthenticationHeader(this);
	}
	
	public bool SetAcceptHeaders()
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "Accept", "application/json")
		&& SteamWorks_SetHTTPRequestHeaderValue(this, "Accept-Charset", "utf-8")
		&& SteamWorks_SetHTTPRequestHeaderValue(this, "Accept-Encoding", "gzip");
	}
	
	public bool SetPoweredByHeader()
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "X-Powered-By", "GlobalAPI Plugin " ... GlobalAPI_Plugin_Version);
	}

	public bool Send()
	{
		return SendRequest(this);
	}
}

// =========================================================== //