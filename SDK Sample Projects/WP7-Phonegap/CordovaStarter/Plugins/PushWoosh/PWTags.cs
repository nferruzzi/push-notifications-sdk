using Microsoft.Phone.Shell;
using PushSDK;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;
using WP7CordovaClassLib.Cordova.JSON;

namespace Cordova.Extension.Commands
{
    public class PWTags : BaseCommand
    {
        private static NotificationService NotificationService
        {
            get { return ((PhonePushApplicationService)PhoneApplicationService.Current).NotificationService; }
        }

        public void SendTags(string options)
        {
            NotificationService.Tags.OnSendingComplete += (sender, args) => DispatchCommandResult(new PluginResult(PluginResult.Status.OK, JsonHelper.Serialize(args.Result)));
           
            NotificationService.Tags.SendRequest(options);
        }
    }
}
