using System;
using System.Collections.Generic;
using System.IO.IsolatedStorage;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using Microsoft.Phone.Info;

namespace PushSDK.Classes
{
    public static class SDKHelpers
    {
        public static string GetDeviceUniqueId()
        {
            string result = string.Empty;
            object uniqueId;

            if (DeviceExtendedProperties.TryGetValue("DeviceUniqueId", out uniqueId))
            {
                var resultByte = (byte[]) uniqueId;

                result = resultByte.Aggregate(result, (current, item) => String.Format("{0}{1:X2}", current, item));
            }

            return result;
        }

        public static ToastPush ParsePushData(string url) //TODO: Заполнить обработку данных
        {
            var pushParams = ParseQueryString(HttpUtility.UrlDecode(url));

            string content = pushParams.ContainsKey("content") ? pushParams["content"] : string.Empty;
            string hash = pushParams.ContainsKey("p") ? pushParams["p"] : string.Empty;
            int htmlId = pushParams.ContainsKey("h") ? Convert.ToInt32(pushParams["h"]) : -1;
            Uri htmlUrl = pushParams.ContainsKey("l") ? new Uri(pushParams["l"], UriKind.Absolute) : null;
            string customData = pushParams.ContainsKey("u") ? pushParams["u"] : string.Empty;

            return new ToastPush{Contnet = content, Hash = hash, HtmlId = htmlId, Url = htmlUrl, UserData = customData};
        }

        private static Dictionary<string,string> ParseQueryString(string s)
        {
            var list = new Dictionary<string, string>();
           
            // remove anything other than query string from url
            if (s.Contains("?"))
            {
                s = s.Substring(s.IndexOf('?') + 1);
            }

            foreach (string vp in Regex.Split(s, "&"))
            {
                string[] singlePair = Regex.Split(vp, "=");
                if (singlePair.Length == 2)
                    list[singlePair[0]] = singlePair[1];
                else
                    // only one key with no value specified in query string
                    list[singlePair[0]] = string.Empty;
            }
            return list;
        }
    }
}