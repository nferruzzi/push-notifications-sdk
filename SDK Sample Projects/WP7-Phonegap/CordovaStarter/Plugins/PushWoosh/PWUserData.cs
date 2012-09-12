using Microsoft.Phone.Shell;
using PushSDK;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;

namespace Cordova.Extension.Commands
{
    public class PWUserData : BaseCommand
    {
        private static NotificationService NotificationService
        {
            get { return ((PhonePushApplicationService)PhoneApplicationService.Current).NotificationService; }
        }

        public void GetUserData(string options)
        {
           DispatchCommandResult(new PluginResult(PluginResult.Status.OK, NotificationService.UserData));
        }
    }
}
