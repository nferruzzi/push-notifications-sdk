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
using Microsoft.Phone.Notification;
using System.Diagnostics;
using System.Collections.ObjectModel;

namespace PushSDK
{
	public class PWNotificationService
	{

		private DeviceRegistrationRequest registrationRequest;


		/// <summary>
		/// Get pushes channel
		/// </summary>
		private HttpNotificationChannel notificationChannel;

		/// <summary>
		/// Get push chanell uri
		/// </summary>
		public Uri ChannelUri
		{
			get
			{
				return notificationChannel.ChannelUri;
			}
		}


		/// <summary>
		/// Get application ID at server
		/// </summary>
		public string AppID
		{
			get;
			private set;
		}

		/// <summary>
		/// Relative uri to first page of application
		/// </summary>
		public Uri FirstPage
		{
			get;
			set;
		}

		/// <summary>
		/// Get content of last push notification
		/// </summary>
		public string LastPushContent
		{
			get;
			internal set;
		}

		private Collection<Uri> liveTileUris
		{
			get;
			set;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="appID">application ID at server</param>
		public PWNotificationService(string appID, Uri firstPage)
		{
			FirstPage = firstPage;
			AppID = appID;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="appID">application ID at server</param>
		public PWNotificationService(string appID, Uri firstPage, Collection<Uri> uris)
		{
			FirstPage = firstPage;
			AppID = appID;
			liveTileUris = uris;
		}

		/// <summary>
		/// Creates push channel and regestrite it at pushwoosh server to send unauthenticated pushes
		/// </summary>
		public void SubscribeToPushService()
		{
			SubscribeToPushService(false);
		}

		/// <summary>
		/// Creates push channel and regestrite it at pushwoosh server
		/// <param name="authenticated">
		/// set true if you use certificate to send pushes, otherwise false
		/// </param>
		/// </summary>        
		public void SubscribeToPushService(bool authenticated)
		{
			//First, try to pick up existing channel
			notificationChannel = HttpNotificationChannel.Find(Constants.channelName);

			if (null != notificationChannel)
			{
				Debug.WriteLine("Channel Exists - no need to create a new one");
				SubscribeToChannelEvents();

				Debug.WriteLine("Register the URI with 3rd party web service. URI is:" + notificationChannel.ChannelUri);
				//if (Request == null) Request = new DeviceRegistrationRequest();
				//Request.DeviceId = Channel.ChannelUri;
				SubscribeToService(AppID);

				
				Debug.WriteLine("Subscribe to the channel to Tile and Toast notifications");
				SubscribeToNotifications();

				//Dispatcher.BeginInvoke(() => UpdateStatus("Channel recovered"));
			}
			else
			{
				Debug.WriteLine("Trying to create a new channel...");
				//Create the channel
				if (authenticated)
				{
					notificationChannel = new HttpNotificationChannel(Constants.channelName, "wp7.pushwoosh.com");
				}
				else
				{
					notificationChannel = new HttpNotificationChannel(Constants.channelName);
				}
				Debug.WriteLine("New Push Notification channel created successfully");

				SubscribeToChannelEvents();


				Debug.WriteLine("Trying to open the channel");
				notificationChannel.Open();

			}
		}


		/// <summary>
		/// Unsubscribe from pushes at pushwoosh server
		/// </summary>
		public void UnsubscribeFromPushes()
		{
			if (registrationRequest == null) return;
			notificationChannel.UnbindToShellTile();
			notificationChannel.UnbindToShellToast();
			registrationRequest.Unregister();
		}

		/// <summary>
		/// User wants to see push
		/// </summary>
		public event EventHandler<PWNotificationEventArgs> PushAccepted;

		/// <summary>
		/// Push channel error occurred
		/// </summary>
		public event EventHandler<NotificationChannelErrorEventArgs> ChannelErrorOccurred;


		/// <summary>
		/// Uri of push channel was updated
		/// </summary>
		public event EventHandler<NotificationChannelUriEventArgs> ChannelUriUpdated;

		#region private logic

		internal void RaisePushEvent()
		{
			if (PushAccepted != null)
			{
				var eventArgs = new PWNotificationEventArgs();
				eventArgs.NotificationContent = LastPushContent;
				PushAccepted(this, eventArgs);
			}
		}

		private void SubscribeToService(string appID)
		{
			if (registrationRequest == null) registrationRequest = new DeviceRegistrationRequest();
			 registrationRequest.Register(appID, notificationChannel.ChannelUri);
		}

		private void SubscribeToChannelEvents()
		{
			//Register to UriUpdated event - occurs when channel successfully opens
			notificationChannel.ChannelUriUpdated += new EventHandler<NotificationChannelUriEventArgs>(Channel_ChannelUriUpdated);

			//general error handling for push channel
			notificationChannel.ErrorOccurred += new EventHandler<NotificationChannelErrorEventArgs>(Channel_ErrorOccurred);

			notificationChannel.ShellToastNotificationReceived += new EventHandler<NotificationEventArgs>(Channel_ShellToastNotificationReceived);

		}

		void Channel_ShellToastNotificationReceived(object sender, NotificationEventArgs e)
		{
			System.Windows.Deployment.Current.Dispatcher.BeginInvoke(() =>
			{

				var msg = new Coding4Fun.Phone.Controls.MessagePrompt();
				var stack = new StackPanel();
				var titleTextBlock = new TextBlock() { Text = "Show push details?", FontSize = 24 };
				stack.Children.Add(titleTextBlock);
				if (e.Collection.ContainsKey("wp:Text1"))
				{
					var pushTitleTextBlock = new TextBlock() { Text = e.Collection["wp:Text1"], FontSize = 20 };
					stack.Children.Add(pushTitleTextBlock);
				}
				if (e.Collection.ContainsKey("wp:Text2"))
				{
					var pushBodyTextBlock = new TextBlock() { Text = e.Collection["wp:Text2"], FontSize = 18, TextWrapping = TextWrapping.Wrap };
					stack.Children.Add(pushBodyTextBlock);
				}

				if (e.Collection.ContainsKey("wp:Param"))
				{
					ParsePushContent(e.Collection["wp:Param"]);
				}

				msg.Body = stack;
				msg.IsCancelVisible = true;
				msg.Completed += new EventHandler<Coding4Fun.Phone.Controls.PopUpEventArgs<string, Coding4Fun.Phone.Controls.PopUpResult>>(msg_Completed);
				msg.Show();
			}
			);
		}

		void ParsePushContent(string param)
		{
			if (param == null)
			{
				LastPushContent = null;
				return;
			}
			var ind = param.IndexOf("content=");
			if (ind < 0)
			{
				LastPushContent = null;
				return;
			}
			LastPushContent = HttpUtility.UrlDecode(param.Substring(ind + 8));
		}

		void msg_Completed(object sender, Coding4Fun.Phone.Controls.PopUpEventArgs<string, Coding4Fun.Phone.Controls.PopUpResult> e)
		{
			if (e.PopUpResult == Coding4Fun.Phone.Controls.PopUpResult.Ok)
			{
				if (PushAccepted != null)
				{

					var eventArgs = new PWNotificationEventArgs();
					eventArgs.NotificationContent = LastPushContent;
					PushAccepted(sender, eventArgs);
				}
			}
			else
			{

			}
		}

		private void Channel_ErrorOccurred(object sender, NotificationChannelErrorEventArgs e)
		{
			Debug.WriteLine("Error:" + e.Message);
			if (ChannelErrorOccurred != null)
				ChannelErrorOccurred(sender, e);
		}

		private void SubscribeToNotifications()
		{
			//////////////////////////////////////////
			// Bind to Toast Notification 
			//////////////////////////////////////////
			try
			{
				if (notificationChannel.IsShellToastBound == true)
				{
					Debug.WriteLine("Already bounded (register) to to Toast notification");
				}
				else
				{
					Debug.WriteLine("Registering to Toast Notifications");
					notificationChannel.BindToShellToast();
				}
			}
			catch (Exception)
			{
				// handle error here
			}

			//////////////////////////////////////////
			// Bind to Tile Notification 
			//////////////////////////////////////////
			try
			{
				if (notificationChannel.IsShellTileBound == true)
				{
					Debug.WriteLine("Already bounded (register) to Tile Notifications");

				}
				else
				{
					Debug.WriteLine("Registering to Tile Notifications");

					// you can register the phone application to receive tile images from remote servers [this is optional]
					if (liveTileUris != null)
						notificationChannel.BindToShellTile(liveTileUris);
					else
						notificationChannel.BindToShellTile();
				}
			}
			catch (Exception ex)
			{

				//handle error here
			}

		}

		private void Channel_ChannelUriUpdated(object sender, NotificationChannelUriEventArgs e)
		{
			Debug.WriteLine("Channel opened. Got Uri:\n" + notificationChannel.ChannelUri.ToString());
			Debug.WriteLine("Subscribing to channel events");
			SubscribeToService(AppID);
			SubscribeToNotifications();
			if (ChannelUriUpdated != null)
			{
				ChannelUriUpdated(sender, e);
			}
		}

		#endregion

	}
}
