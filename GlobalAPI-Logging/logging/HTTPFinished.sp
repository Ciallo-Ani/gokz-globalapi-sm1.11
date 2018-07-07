// =========================================================== //

public void Log_Finished_HTTPRequest(GlobalAPIRequestData hData)
{	
	char params[MAX_PARAMS_LENGTH] = "-";
	hData.ToString(params, sizeof(params));
	
	char url[MAX_URL_LENGTH];
	hData.GetString("url", url, sizeof(url));
	
	char pluginName[40];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));
	
	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);
	
	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPFinished_LogFile, "a+");
	
	hLogFile.WriteLine("%s (%s) API call finished!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => Status: %d", logTag, hData.status);
	hLogFile.WriteLine("%s    => Failure: %s", logTag, hData.failure ? "YES" : "NO");
	hLogFile.WriteLine("%s     => URL: %s", logTag, url);
	hLogFile.WriteLine("%s      => Params: %s", logTag, params);
	hLogFile.Close();

	Call_Global_OnLogged();
	Call_Global_OnFinishLogged();
}

// =========================================================== //