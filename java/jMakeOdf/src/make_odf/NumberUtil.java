package make_odf;

public class NumberUtil {

	private NumberUtil() {
	}

	public static String format(int number) {
		return String.format("%03d", number);
	}

}
