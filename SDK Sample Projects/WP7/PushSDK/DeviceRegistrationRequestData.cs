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
using System.Threading;
using Microsoft.Phone.Info;

namespace PushSDK
{
    [JsonObject]
    public struct DeviceRegistrationRequestData
    {
        [JsonProperty("application")]
        public string AppID
        {
            get;
            set;
        }

        [JsonProperty("device_type")]
        public int DeviceType
        {
            get { return Constants.deviceType; }
        }

        [JsonProperty("device_id")]
        public Uri DeviceId { get; set; }


        [JsonProperty("language")]
        public string Language
        {
            get { return Thread.CurrentThread.CurrentCulture.TwoLetterISOLanguageName; }
        }


        //Note: to get a result requires ID_CAP_IDENTITY_DEVICE         
        // to be added to the capabilities of the WMAppManifest         
        // this will then warn users in marketplace  
        [JsonProperty("hw_id")]
        public string HardwareId
        {
            get
            {
                string result = null;
                object uniqueId;
                if (DeviceExtendedProperties.TryGetValue("DeviceUniqueId", out uniqueId))
                {
                    var bytes = (byte[])uniqueId;
                    foreach (var num in bytes)
                    {
                        result = String.Format("{0}{1:X2}", result, num);

                    }
                }
                return result;
            }
        }

        [JsonProperty("timezone")]
        public double Timezone
        {
            get
            {
                return TimeZoneInfo.Local.BaseUtcOffset.TotalSeconds;
            }
        }
    }
}
