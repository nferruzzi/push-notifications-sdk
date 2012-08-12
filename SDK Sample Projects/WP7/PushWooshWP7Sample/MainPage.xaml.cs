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

namespace PushWooshWP7Sample
{
    public partial class MainPage : PhoneApplicationPage
    {
        // Constructor
        public MainPage()
        {
            InitializeComponent();

            this.Loaded += new RoutedEventHandler(MainPage_Loaded);
            ((App)Application.Current).NotificationService.PushAccepted += new EventHandler<PushSDK.PWNotificationEventArgs>(NotificationService_PushAccepted);
        }

        void NotificationService_PushAccepted(object sender, PushSDK.PWNotificationEventArgs e)
        {
            PushContent.Text = e.NotificationContent??"*no content*";
        }

        // Load data for the ViewModel Items
        private void MainPage_Loaded(object sender, RoutedEventArgs e)
        {
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ((App)Application.Current).NotificationService.UnsubscribeFromPushes();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            ((App)Application.Current).RootFrame.Navigate(new Uri("/Page1.xaml",  UriKind.Relative));
        }
    }
}