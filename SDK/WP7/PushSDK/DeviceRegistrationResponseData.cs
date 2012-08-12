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
using Newtonsoft.Json;

namespace PushSDK
{
    [JsonObject]
    public class DeviceRegistrationResponseData
    {
        [JsonProperty("status_message")]
        public string Message { get; set; }

        [JsonProperty("status_code")]
        public int Code { get; set; }
    }
}
