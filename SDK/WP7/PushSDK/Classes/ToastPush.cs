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

namespace PushSDK.Classes
{
    public class ToastPush
    {
        public string Hash { get; set; }

        public int HtmlId { get; set; }

        public Uri Url { get; set; }

        public string Contnet { get; set; }

        public string UserData { get; set; }

    }
}
