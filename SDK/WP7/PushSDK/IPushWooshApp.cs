using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PushSDK
{
    public interface IPushWooshApp
    {
        PWNotificationService NotificationService { get; set; }        
    }
}
