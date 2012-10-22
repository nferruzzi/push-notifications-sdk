#include "s3e.h"
#include "s3ePushWoosh.h"
#include "IwDebug.h"
#include <string>

std::string message;

int32 OnPushRegistered(char* token, void* userData)
{
    IwTrace(PUSHWOOSH, ("TEST 10"));
    if (token)
    {
        IwTrace(PUSHWOOSH, ("TEST 13"));
        message += token;
        IwTrace(PUSHWOOSH, ("TEST 15"));
    }
    else
    {
        IwTrace(PUSHWOOSH, ("TEST 19"));
        message += std::string("Error: ");
        IwTrace(PUSHWOOSH, ("TEST 21"));
    }
    return 0;
}

int32 OnPushReceived(char* text, void* userData)
{
    message = std::string("Message: " + std::string(text));
	return 0;
}

int32 OnPushRegisterError(char* error, void* userData)
{
	return 0;
}

// Main entry point for the application
int main()
{
    message = "`xffffff";

    if (s3ePushWooshNotificationsAvailable())
	{
		s3ePushWooshRegister(S3E_PUSHWOOSH_REGISTRATION_SUCCEEDED, (s3eCallback)&OnPushRegistered, 0);
		s3ePushWooshRegister(S3E_PUSHWOOSH_MESSAGE_RECEIVED, (s3eCallback)&OnPushReceived, 0);
		s3ePushWooshRegister(S3E_PUSHWOOSH_REGISTRATION_ERROR, (s3eCallback)&OnPushRegisterError, 0);

		s3ePushWooshNotificationRegister();
	}

    // Wait for a quit request from the host OS
    while (!s3eDeviceCheckQuitRequest())
    {
        // Fill background blue
        s3eSurfaceClear(0, 0, 255);

        // Print a line of debug text to the screen at top left (0,0)
        // Starting the text with the ` (backtick) char followed by 'x' and a hex value
        // determines the colour of the text.
		s3eDebugPrint(120, 150, message.c_str(), 0);
		// else
		// 	s3eDebugPrint(120, 150, "`xffffffNot available :(", 0);

        // Flip the surface buffer to screen
        s3eSurfaceShow();

        // Sleep for 0ms to allow the OS to process events etc.
        s3eDeviceYield(0);
    }
    return 0;
}
