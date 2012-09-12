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
using Newtonsoft.Json.Linq;

namespace PushSDK.Classes
{
    public static class JsonHelpers
    {
       

        public static int GetStatusCode(JObject jRoot)
        {
            return jRoot.Value<int>("status_code");
        }

        public static string GetStatusMessage(JObject jRoot)
        {
            return jRoot.Value<string>("status_message");
        }
    }
}
