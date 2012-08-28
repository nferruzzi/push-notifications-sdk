using System;

namespace PushSDK.Classes
{
    public class CustomEventArgs<T> : EventArgs
    {
        public T Result { get; set; }
    }
}