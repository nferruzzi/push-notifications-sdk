package com.arellomobile.blackberry.push;

import net.rim.device.api.collection.util.LongHashtableCollection;
import net.rim.device.api.system.PersistentObject;
import net.rim.device.api.system.PersistentStore;

public class PushStore {
	private static final long KEY_NOTIFICATION = 1;
	private static final long KEY_PUSH_ENABLED = 2;

	private static PushStore _instance;

	private PersistentObject _store;
	private final Object _syncObject;
	private LongHashtableCollection _settings;
	private Boolean _isLock;

	private static final long GUID = 0x30120912ea356c9cL;

	public PushStore() {
		_store = PersistentStore.getPersistentObject(GUID);
		_syncObject = new Object();
		_isLock = new Boolean(false);
	}

	/**
	 * Retrieve notification.
	 */
	public static String getNotification() {
		String notification = (String) getInstance().get(KEY_NOTIFICATION);
		if (null == notification || notification.length() == 0) {
			notification = "";
			setNotification(notification);
		}
		return notification;
	}

	/**
	 * Save notification.
	 * 
	 * @param notification
	 *            The notification message to save.
	 */
	public static void setNotification(String notification) {
		getInstance().set(KEY_NOTIFICATION, notification);
	}

	/**
	 * Get push status
	 * 
	 * @return true if Push enabled
	 */
	public static Boolean isPushEnabled() {
		return (Boolean) getInstance().get(KEY_PUSH_ENABLED);
	}

	/**
	 * Set Push Enabled.
	 * 
	 * @param pushEnabled
	 *            boolean true or false
	 */
	public static void setPushEnabled(Boolean pushEnabled) {
		getInstance().set(KEY_PUSH_ENABLED, pushEnabled);
	}

	private synchronized static PushStore getInstance() {
		if (null == _instance) {
			_instance = new PushStore();
			// Disabled by default
			setPushEnabled(new Boolean(false));
		}
		return _instance;
	}

	private void set(long key, Object value) {
		synchronized (_syncObject) {
			_settings = (LongHashtableCollection) _store.getContents();
			if (null == _settings) {
				_settings = new LongHashtableCollection();
			}
			_settings.put(key, value);
			_store.setContents(_settings);
			_store.commit();
		}
	}

	private Object get(long key) {
		synchronized (_syncObject) {
			_settings = (LongHashtableCollection) _store.getContents();
			if (null != _settings && _settings.size() != 0) {
				return _settings.get(key);
			} else {
				return null;
			}
		}
	}

	public static void setPushLock() {
		getInstance().setPushLockEnable();
	}

	public static void releasePushLock() {
		getInstance().setPushLockDisable();
	}

	public static Boolean isPushLockEnable() {
		return getInstance().getPushLockStatus();
	}

	public void setPushLockEnable() {
		synchronized (_syncObject) {
			_isLock = new Boolean(true);
		}
	}

	public void setPushLockDisable() {
		synchronized (_syncObject) {
			_isLock = new Boolean(false);
		}
	}

	public Boolean getPushLockStatus() {
		synchronized (_syncObject) {
			return _isLock;
		}
	}
}
