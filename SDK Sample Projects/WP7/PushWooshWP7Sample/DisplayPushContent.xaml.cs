using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using PushSDK;
using PushSDK.Classes;

namespace PushWooshWP7Sample
{
    public partial class DisplayPushContent : PhoneApplicationPage
    {
        public DisplayPushContent()
        {
            InitializeComponent();

            ((PhonePushApplicationService)PhoneApplicationService.Current).NotificationService.OnPushAccepted += NotificationServiceOnPushAccepted;
        }

        void NotificationServiceOnPushAccepted(object sender, CustomEventArgs<string> e)
        {
            tbPushContent.Text = e.Result ?? "*no content*";
            tbUserData.Text = ((PhonePushApplicationService) PhoneApplicationService.Current).NotificationService.UserData ?? "*no content*";

        }
    }
}