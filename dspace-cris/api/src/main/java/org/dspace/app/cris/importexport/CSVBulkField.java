package org.dspace.app.cris.importexport;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import jxl.Cell;

public class CSVBulkField implements IBulkChangeField {

	private Cell element;

	public static String REGEX_REPEATABLE_SPLIT = "###";

	public CSVBulkField(Cell element) {
		this.element = element;
	}

	@Override
	public int size() {
		return element.getContents().split(REGEX_REPEATABLE_SPLIT).length;
	}

	@Override
	public IBulkChangeFieldValue get(int y) {
		return new CSVBulkFieldValue(element, y);
	}

	public static String match(String value, Pattern pattern, int match) {
		Matcher tagmatch = pattern.matcher(value);
		while (tagmatch.find()) {
			return tagmatch.group(match);
		}
		return "";
	}

}
