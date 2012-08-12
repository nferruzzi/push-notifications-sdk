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

namespace PushSDK
{
    public partial class PushPage : PhoneApplicationPage
    {
        public PushPage()
        {
            //InitializeComponent();
        }

        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            service = (Application.Current as IPushWooshApp).NotificationService;
            if (NavigationContext.QueryString.ContainsKey("content"))
            {
                service.LastPushContent = NavigationContext.QueryString["content"];
            }
            else
            {
                service.LastPushContent = null;
            }
            NavigationService.Navigate(service.FirstPage);
        }

        PWNotificationService service;

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            base.OnNavigatedFrom(e);
            service.RaisePushEvent();
            NavigationService.RemoveBackEntry();
        }
    }
}