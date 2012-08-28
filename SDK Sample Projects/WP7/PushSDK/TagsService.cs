using System;
using System.Collections.Generic;
using System.Linq;
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
using Newtonsoft.Json.Linq;
using PushSDK.Classes;

namespace PushSDK
{
    public class TagsService
    {
        private readonly string _appId;

        private readonly WebClient _webClient = new WebClient();

        public event EventHandler<CustomEventArgs<List<KeyValuePair<string, string>>>> OnSendingComplete;
        public event EventHandler<CustomEventArgs<string>> OnError;

        public TagsService(string appId)
        {
            _appId = appId;
            _webClient.UploadStringCompleted += UploadStringCompleted;
        }

        public void SendRequest(List<KeyValuePair<string,object>> tagList)
        {
            _webClient.UploadStringAsync(Constants.TagsUrl, BuildRequest(tagList));
        }

        private string BuildRequest(IEnumerable<KeyValuePair<string, object>> tagList)
        {
            JObject tags = new JObject();
            foreach (var tag in tagList)
            {
                tags.Add(new JProperty(tag.Key, tag.Value));
            }

            return (new JObject(
                new JProperty("request",
                              new JObject(
                                  new JProperty("application", _appId),
                                  new JProperty("hwid", SDKHelpers.GetDeviceUniqueId()),
                                  new JProperty("tags", tags))))).ToString();
        }

        private void UploadStringCompleted(object sender, UploadStringCompletedEventArgs e)
        {
            if (e.Error == null)
            {

                JObject jRoot = JObject.Parse(e.Result);
                if (JsonHelpers.GetStatusCode(jRoot) == 200)
                {
                    var skippedTags = new List<KeyValuePair<string, string>>();

                    if (jRoot["response"].HasValues)
                    { 
                        JArray jItems = jRoot["response"]["skipped"] as JArray;

                        skippedTags = jItems.Select(jItem => new KeyValuePair<string, string>(jItem.Value<string>("tag"), jItem.Value<string>("reason"))).ToList();
                    }

                    OnSendingComplete(this, new CustomEventArgs<List<KeyValuePair<string, string>>>{Result = skippedTags});
                }
                else
                    OnError(this, new CustomEventArgs<string> { Result = JsonHelpers.GetStatusMessage(jRoot) });
            }
            else
                OnError(this, new CustomEventArgs<string> { Result = e.Error.Message });
        }
    }
}
