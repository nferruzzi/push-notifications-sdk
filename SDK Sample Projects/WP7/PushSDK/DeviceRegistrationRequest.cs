using System;
using System.Diagnostics;
using System.Net;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Newtonsoft.Json;
using System.IO;
using System.Text;


namespace PushSDK
{
    
    public class DeviceRegistrationRequest
    {

        DeviceRegistrationRequestData requestData;

        public event EventHandler<WebRequestExceptionEvenArgs> ExceptionOccurs;
        public event EventHandler SuccessefulyRegistered;
        public event EventHandler SuccessefulyUnregistered;
        public event EventHandler<RequestErrorEventArgs> RegisterError;
        public event EventHandler<RequestErrorEventArgs> UnregisterError; 

        public void Register(string appID, Uri pushUri)
        {
            requestData.AppID = appID;
            requestData.DeviceId = pushUri;
            var req = HttpWebRequest.CreateHttp(Constants.requestDomain + Constants.registerRequest);
            req.Method = "POST";
            req.BeginGetRequestStream(new AsyncCallback(WriteToRequestStream), req);
        }

        private void ReadResponse(IAsyncResult asynchronousResult)
        {
            try
            {
                var req = (HttpWebRequest)asynchronousResult.AsyncState;
                bool wasSuccsess = false;
                string message="";
                // Get the response.
                HttpWebResponse response = (HttpWebResponse)req.EndGetResponse(asynchronousResult);
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    Stream streamResponse = response.GetResponseStream();
                    StreamReader streamRead = new StreamReader(streamResponse);
                    string responseString = streamRead.ReadToEnd();
                    var resp = JsonConvert.DeserializeObject<DeviceRegistrationResponseData>(responseString);
                    //Console.WriteLine(responseString);
                    // Close the stream object.
                    if (resp.Code == 200)
                    {
                        wasSuccsess = true;
                        if (req.RequestUri.Equals(new Uri(Constants.requestDomain + Constants.unregisterRequest)))
                        {
                            if (SuccessefulyUnregistered != null)
                            {
                                SuccessefulyUnregistered(this, null);
                            }
                        }
                        else
                        {
                            if (SuccessefulyRegistered != null)
                            {
                                SuccessefulyRegistered(this, null);
                            }
                        }
                    }
                    else
                    {
                        message = resp.Message;
                    }
                    streamResponse.Close();
                    streamRead.Close();
                }
                else
                {
                    message = response.StatusDescription;
                }
                if (!wasSuccsess)
                {
                    if (req.RequestUri.Equals(new Uri(Constants.requestDomain + Constants.unregisterRequest)))
                    {
                        if (UnregisterError != null)
                        {
                            UnregisterError(this, new RequestErrorEventArgs(message));
                        }
                    }
                    else
                    {
                        if (RegisterError != null)
                        {
                            RegisterError(this, new RequestErrorEventArgs(message));
                        }
                    }
                }

                // Release the HttpWebResponse.
                response.Close();
            }
            catch (Exception ex)
            {
                if (ExceptionOccurs != null)
                {
                    ExceptionOccurs(this, new WebRequestExceptionEvenArgs(ex));
                }
            }
        }

        private void WriteToRequestStream(IAsyncResult asynchronousResult)
        {
            try
            {
                HttpWebRequest request = (HttpWebRequest)asynchronousResult.AsyncState;
                // End the operation.
                Stream postStream = request.EndGetRequestStream(asynchronousResult);
                var str = JsonConvert.SerializeObject(requestData);
                str = "{ \"request\":" + str + "}";
                Debug.WriteLine("sending request: " + str);
                byte[] byteArray = Encoding.UTF8.GetBytes(str);
                postStream.Write(byteArray, 0, str.Length);
                postStream.Close();
                request.BeginGetResponse(new AsyncCallback(ReadResponse), request);
            }
            catch (Exception ex)
            {
                if (ExceptionOccurs != null)
                {
                    ExceptionOccurs(this, new WebRequestExceptionEvenArgs(ex));
                }
            }
        }


        public void Unregister()
        {
            var req = HttpWebRequest.CreateHttp(Constants.requestDomain + Constants.unregisterRequest);
            req.Method = "POST";
            req.BeginGetRequestStream(new AsyncCallback(WriteToRequestStream), req);   
        }
    }

    
    
}
