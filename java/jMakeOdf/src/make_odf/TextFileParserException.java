package make_odf;

public class TextFileParserException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public TextFileParserException() {
	}

	public TextFileParserException(String message) {
		super(message);
	}

	public TextFileParserException(Throwable cause) {
		super(cause);
	}

	public TextFileParserException(String message, Throwable cause) {
		super(message, cause);
	}

	public TextFileParserException(String message, Throwable cause,
			boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

}
