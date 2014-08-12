package make_odf;

public class OdfWriterException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public OdfWriterException() {
	}

	public OdfWriterException(String message) {
		super(message);
	}

	public OdfWriterException(Throwable cause) {
		super(cause);
	}

	public OdfWriterException(String message, Throwable cause) {
		super(message, cause);
	}

	public OdfWriterException(String message, Throwable cause,
			boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

}
