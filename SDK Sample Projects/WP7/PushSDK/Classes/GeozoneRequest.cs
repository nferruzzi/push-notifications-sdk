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

namespace PushSDK.Classes
{
    [JsonObject]
    public class GeozoneRequest
    {
        [JsonProperty("application")]
        public string AppId { get; set; }

        [JsonProperty("hwid")]
        public string HardwareId
        {
            get { return SDKHelpers.GetDeviceUniqueId(); }
        }

        [JsonProperty("lat")]
        public double Lat { get; set; }
        
        [JsonProperty("lng")]
        public double Lon { get; set; }
    }
}
