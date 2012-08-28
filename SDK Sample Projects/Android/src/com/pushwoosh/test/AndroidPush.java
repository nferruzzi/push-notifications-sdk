package com.pushwoosh.test;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.Toast;
import com.arellomobile.android.push.PushManager;
import com.arellomobile.android.push.exception.PushWooshException;
import com.arellomobile.android.push.tags.SendPushTagsAbstractAsyncTask;
import com.arellomobile.android.push.tags.SendPushTagsAsyncTask;
import com.arellomobile.android.push.tags.SendPushTagsCallBack;

import java.util.HashMap;
import java.util.Map;

public class AndroidPush extends Activity implements SendPushTagsCallBack
{
	// CHANGE IT
	private static final String APP_ID = null;
	// sender login for GCM
	// CHANGE IT
	public static final String SENDER_ID = null;

	/**
	 * Called when the activity is first created.
	 */
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		PushManager pushManager = new PushManager(this, APP_ID, SENDER_ID);
		pushManager.onStartup(this);

		checkMessage(getIntent());

		Map<String, Object> tags = new HashMap<String, Object>();
		tags.put("tag1", "value1");
		tags.put("tag2", 42);

		//		CHOOSE your best send tags example
		sendPush1(tags);
		sendPush2(tags);
		sendPush3(tags);
		sendPush4(tags);
	}

	private void sendPush1(Map<String, Object> tags)
	{
		new SendPushTagsAbstractAsyncTask(this)
		{
			@Override
			protected void taskStarted()
			{
				Toast.makeText(AndroidPush.this, "taskStarted", Toast.LENGTH_SHORT).show();
			}

			@Override
			protected void onSentTagsSuccess(Map<String, String> skippedTags)
			{
				Toast.makeText(AndroidPush.this, "onSentTagsSuccess: skipped tags: " + skippedTags.toString(),
						Toast.LENGTH_SHORT).show();
			}

			@Override
			protected void onSentTagsError(PushWooshException e)
			{
				Toast.makeText(AndroidPush.this, "onSentTagsError: error: " + e.getMessage(), Toast.LENGTH_SHORT)
						.show();
			}
		}.execute((Map<String, Object>) tags);
	}

	private void sendPush2(Map<String, Object> tags)
	{
		new SendPushTagsAsyncTask(this, this).execute((Map<String, Object>) tags);
	}

	private void sendPush3(final Map<String, Object> tags)
	{
		new AsyncTask<Void, Void, Void>()
		{
			@Override
			protected Void doInBackground(Void... voids)
			{
				try
				{
					final Map<String, String> skippedTags = PushManager.sendTagsFromBG(AndroidPush.this, tags);
					runOnUiThread(new Runnable()
					{
						@Override
						public void run()
						{
							Toast.makeText(AndroidPush.this,
									"onSentTagsSuccess: skipped tags: " + skippedTags.toString(), Toast.LENGTH_SHORT)
									.show();
						}
					});
				}
				catch (final PushWooshException e)
				{
					e.printStackTrace();
					runOnUiThread(new Runnable()
					{
						@Override
						public void run()
						{
							Toast.makeText(AndroidPush.this, "onSentTagsError: error: " + e.getMessage(),
									Toast.LENGTH_SHORT).show();
						}
					});
				}

				return null;
			}
		}.execute((Void) null);
	}

	private void sendPush4(Map<String, Object> tags)
	{
		PushManager.sendTagsFromUI(this, tags, this);
	}

	@Override
	protected void onNewIntent(Intent intent)
	{
		super.onNewIntent(intent);

		checkMessage(intent);
	}

	private void checkMessage(Intent intent)
	{
		if (null != intent)
		{
			if (intent.hasExtra(PushManager.PUSH_RECEIVE_EVENT))
			{
				showMessage("push message is " + intent.getExtras().getString(PushManager.PUSH_RECEIVE_EVENT));
			}
			else if (intent.hasExtra(PushManager.REGISTER_EVENT))
			{
				showMessage("register");
			}
			else if (intent.hasExtra(PushManager.UNREGISTER_EVENT))
			{
				showMessage("unregister");
			}
			else if (intent.hasExtra(PushManager.REGISTER_ERROR_EVENT))
			{
				showMessage("register error");
			}
			else if (intent.hasExtra(PushManager.UNREGISTER_ERROR_EVENT))
			{
				showMessage("unregister error");
			}
		}
	}

	private void showMessage(String message)
	{
		Toast.makeText(this, message, Toast.LENGTH_LONG).show();
	}

	@Override
	public void taskStarted()
	{
		Toast.makeText(AndroidPush.this, "taskStarted", Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onSentTagsSuccess(Map<String, String> skippedTags)
	{
		Toast.makeText(AndroidPush.this, "onSentTagsSuccess: skipped tags: " + skippedTags.toString(),
				Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onSentTagsError(PushWooshException e)
	{
		Toast.makeText(AndroidPush.this, "onSentTagsError: error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
	}
}
