package com.arellomobile.blackberry.push;

public class PushStatus {
	public static final byte STATUS_BB_NOT_REGISTERED = 0;
	public static final byte STATUS_BB_PENDING = 1;
	public static final byte STATUS_BB_ACTIVE = 2;
	public static final byte STATUS_BB_FAILED = 3;
	public static final byte STATUS_PUSHWOOSH_ACTIVE = 4;
	public static final byte STATUS_PUSHWOOSH_NOT_REGISTERED = 5;
	public static final byte STATUS_PUSHWOOSH_FAILED = 6;
	public static final byte REASON_NETWORK_ERROR = 7;
	public static final byte REASON_REJECTED_BY_SERVER = 8;
	public static final byte REASON_SIM_CHANGE = 9;
	public static final byte REASON_INVALID_PARAMETERS = 10;
	public static final byte REASON_API_CALL = 11;

	private int _status;
	private int _reason;
	private String _error;

	private PushStatus(byte status) {
		_status = status;
		_reason = -1;
		_error = "";
	}

	public int getStatus() {
		return _status;
	}

	public int getReason() {
		return _reason;
	}

	public String getError() {
		return _error;
	}

	static PushStatus getStatusBBActive() {
		return new PushStatus(STATUS_BB_ACTIVE);
	}

	static PushStatus getStatusBBFailed(int reason, String error) {
		PushStatus pushStatus = new PushStatus(STATUS_BB_FAILED);
		pushStatus._reason = reason;
		pushStatus._error = error;
		return pushStatus;
	}

	public static PushStatus getStatusBBNotRegistered() {
		return new PushStatus(STATUS_BB_NOT_REGISTERED);
	}

	static PushStatus getStatusBBPending() {
		return new PushStatus(STATUS_BB_PENDING);
	}

	static PushStatus getStatusPushActive() {
		return new PushStatus(STATUS_PUSHWOOSH_ACTIVE);
	}

	static PushStatus getStatusPushFail(String error) {
		PushStatus status = new PushStatus(STATUS_BB_FAILED);
		status._reason = PushStatus.REASON_NETWORK_ERROR;
		status._error = error;
		return status;
	}

	static PushStatus getStatusPushNotRegistered() {
		return new PushStatus(STATUS_PUSHWOOSH_NOT_REGISTERED);
	}

	public String toString() {
		return "status = " + _status + "; reason = " + _reason + "; error = "
				+ _error;
	}
}
