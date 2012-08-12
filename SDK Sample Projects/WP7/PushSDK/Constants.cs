using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;

namespace PushSDK
{
    internal static class Constants
    {
        // request consts
        public static int deviceType = 5;
    	public static string requestDomain = "https://cp.pushwoosh.com/json/1.2/";
        public static string registerRequest = "/registerDevice";
        public static string unregisterRequest = "/unregisterDevice";

        //channel consts
        public static string channelName = "CMS WP7";
    }
}
