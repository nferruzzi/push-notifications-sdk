using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using Microsoft.Phone.Shell;
using PushSDK;

namespace PushWooshWP7Sample
{
    public partial class MainPage 
    {
        private readonly NotificationService _service = ((PhonePushApplicationService)PhoneApplicationService.Current).NotificationService;

        public MainPage()
        {
            InitializeComponent();

            _service.Tags.OnError += (sender, args) => MessageBox.Show("Error while sending the tags: \n" + args.Result);
            _service.Tags.OnSendingComplete += (sender, args) =>
                                                   {
                                                       MessageBox.Show("Tag has been sent!");
                                                       DisplaySkippedTags(args.Result);
                                                   };
            _service.OnPushTokenUpdated += (sender, args) =>
                                               {
                                                   tbPushToken.Text = args.Result.ToString();
                                               };

            tbPushToken.Text = _service.PushToken;
            ResetMyMainTile();
        }

        private void ButtonClick(object sender, RoutedEventArgs e)
        {
            _service.UnsubscribeFromPushes();
        }

        private void btnSendTag_Click(object sender, RoutedEventArgs e)
        {
            var tagsList = new List<KeyValuePair<string, object>>();

            object value;
            int iValue;
            if (int.TryParse(tbTagValue.Text, out iValue))
                value = iValue;
            else if (tbTagValue.Text.IndexOf(',') != -1)
                value = tbTagValue.Text.Replace(", ", ",").Split(',');
            else
                value = tbTagValue.Text;

            tagsList.Add(new KeyValuePair<string, object>(tbTagTitle.Text, value));
            _service.Tags.SendRequest(tagsList);

        }

        private void DisplaySkippedTags(IEnumerable<KeyValuePair<string, string>> skippedTags)
        {
            StringBuilder builder = new StringBuilder();
            builder.AppendLine("These tags has been ignored:");

            foreach (var tag in skippedTags)
            {
                builder.AppendLine(string.Format("{0} : {1}", tag.Key, tag.Value));
            }
        }

        private void CheckBox_Checked(object sender, RoutedEventArgs e)
        {
            _service.GeoZone.Start();
        }

        private void CheckBox_Unchecked(object sender, RoutedEventArgs e)
        {
            _service.GeoZone.Stop();
        }

        private void ResetMyMainTile()
        {

            ShellTile tileToFind = ShellTile.ActiveTiles.First();
            if (tileToFind != null)
            {

                StandardTileData newTileData = new StandardTileData
                {
                    Title = "Push Woosh",
                    BackgroundImage = new Uri("Background.png", UriKind.RelativeOrAbsolute),
                    Count = 0,
                    BackTitle = "",
                    BackBackgroundImage = new Uri("doesntexist.png", UriKind.RelativeOrAbsolute),
                    BackContent = ""
                };

                tileToFind.Update(newTileData);
            }
        }
    }
}