using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class PushNotificationsIOS : MonoBehaviour {

	[System.Runtime.InteropServices.DllImport("__Internal")]
	extern static public void setListenerName(string listenerName);

	[System.Runtime.InteropServices.DllImport("__Internal")]
	extern static public System.IntPtr _getPushToken();
	
	[System.Runtime.InteropServices.DllImport("__Internal")]
	extern static public void setIntTag(string tagName, int tagValue);

	[System.Runtime.InteropServices.DllImport("__Internal")]
	extern static public void setStringTag(string tagName, string tagValue);
	
	// Use this for initialization
	void Start () {
		setListenerName(this.gameObject.name);
		Debug.Log(getPushToken());
	}

	
	static public string getPushToken()
	{
		return Marshal.PtrToStringAnsi(_getPushToken());
	}

	void onRegisteredForPushNotifications(string token)
	{
		//do handling here
		Debug.Log(token);
	}

	void onFailedToRegisteredForPushNotifications(string error)
	{
		//do handling here
		Debug.Log(error);
	}

	void onPushNotificationsReceived(string payload)
	{
		//do handling here
		Debug.Log(payload);
	}
}
