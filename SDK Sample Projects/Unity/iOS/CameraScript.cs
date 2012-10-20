using UnityEngine;
using System.Collections;

public class CameraScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Debug.Log(PushNotifications.getPushToken());
		PushNotifications.setIntTag("DeviceType", 5);
		PushNotifications.setStringTag("DeviceName", "Shader");
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
