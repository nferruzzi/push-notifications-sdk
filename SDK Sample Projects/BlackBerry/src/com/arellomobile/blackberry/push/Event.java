package com.arellomobile.blackberry.push;

public class Event {
	public static final int STATUS_FAIL = 0;
	public static final int STATUS_SUCCESS = 1;

	public static final int CHANGING_PUSH_STATUS = 0;
	public static final int REGISTER_EVENT = 1;
	public static final int UN_REGISTER_EVENT = 2;
	public static final int HANDLE_MESSAGE = 3;

	private int _status;
	private int _what;
	private String _error;

	public Event(int status, int what, String error) {
		this(status);
		_what = what;
		_error = error;
	}

	public Event(int status, int what) {
		this(status);
		_what = what;
	}

	private Event(int status) {
		_status = status;
		_what = -1;
		_error = "";
	}

	public static Event getAlreadyStartChangePushEvent(String error) {
		return new Event(STATUS_FAIL, CHANGING_PUSH_STATUS, error);
	}

	public static Event getRegisterEvent() {
		return new Event(STATUS_SUCCESS, REGISTER_EVENT);
	}

	public static Event getRegisterFailEvent(String error) {
		return new Event(STATUS_FAIL, REGISTER_EVENT, error);
	}

	public static Event getUnRegisterEvent() {
		return new Event(STATUS_SUCCESS, UN_REGISTER_EVENT);
	}

	public static Event getUnRegisterFailEvent(String error) {
		return new Event(STATUS_FAIL, UN_REGISTER_EVENT, error);
	}

	public static Event getHandleMessageFailEvent(String error) {
		return new Event(STATUS_FAIL, HANDLE_MESSAGE, error);
	}

	public int getStatus() {
		return _status;
	}

	public int getWhat() {
		return _what;
	}

	public String getError() {
		return _error;
	}
}
