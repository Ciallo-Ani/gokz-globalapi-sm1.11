// =========================================================== //

static char gC_acceptTypePhrases[][] =
{
	"application/json",
	"application/octet-stream"
};

static char gC_contentTypePhrases[][] =
{
	"application/json",
	"application/octet-stream"
};

// =========================================================== //

methodmap GlobalAPIRequest < Handle
{
	public GlobalAPIRequest(char[] url, EHTTPMethod method)
	{
		Handle request = SteamWorks_CreateHTTPRequest(method, url);
		return view_as<GlobalAPIRequest>(request);
	}

	public bool SetTimeout(int seconds)
	{
		return SteamWorks_SetHTTPRequestAbsoluteTimeoutMS(this, seconds * 1000);
	}
	
	public bool SetBody(GlobalAPIRequestData hData, char[] body, int maxlength)
	{
		return SteamWorks_SetHTTPRequestRawPostBody(this, gC_contentTypePhrases[hData.contentType], body, maxlength);
	}
	
	public bool SetData(any data)
	{
		return SteamWorks_SetHTTPRequestContextValue(this, data);
	}
	
	public bool SetContextValue(any data1, any data2)
	{
		return SteamWorks_SetHTTPRequestContextValue(this, data1, data2);
	}
	
	public void SetCallbacks()
	{
		SteamWorks_SetHTTPCallbacks(this, Global_HTTP_Completed, Global_HTTP_Headers, Global_HTTP_DataReceived);
	}
	
	public bool SetAuthHeader()
	{
		return BuildAuthenticationHeader(this);
	}
	
	public bool SetAcceptHeaders(GlobalAPIRequestData hData)
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "Accept", gC_acceptTypePhrases[hData.acceptType]);
	}
	
	public bool SetPoweredByHeader()
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "X-Powered-By", "GlobalAPI Plugin " ... GlobalAPI_Plugin_Version);
	}

	public bool SetContentTypeHeader(GlobalAPIRequestData hData)
	{
		return SteamWorks_SetHTTPRequestHeaderValue(this, "Content-Type", gC_contentTypePhrases[hData.contentType]);
	}
	
	public bool SetRequestOriginHeader(GlobalAPIRequestData hData)
	{
		char pluginName[GlobalAPI_Max_PluginName_Length + 12];
		hData.GetString("pluginName", pluginName, sizeof(pluginName));
		
		if (hData.isRetried) StrCat(pluginName, sizeof(pluginName), " [Retried]");
		return SteamWorks_SetHTTPRequestHeaderValue(this, "X-RequestOrigin", pluginName);
	}

	public bool Send(GlobalAPIRequestData hData)
	{
		return SendRequest(this, hData);
	}
}

// =========================================================== //