/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content.integration.crosswalks;

import java.util.List;
import java.util.Map;

import org.dspace.content.Item;
import org.dspace.content.MetadataValue;
import org.dspace.core.ConfigurationManager;

/**
 * Implements virtual field processing for generate wos html tag map element
 *
 * @author l.pascarelli
 *
 */
public class VirtualFieldWosElement implements VirtualFieldDisseminator {

	private static final String fieldPubmedID = ConfigurationManager.getProperty("cris", "ametrics.identifier.pmid");
	private static final String fieldWosID = ConfigurationManager.getProperty("cris", "ametrics.identifier.ut");
	private static final String fieldDoiID = ConfigurationManager.getProperty("cris", "ametrics.identifier.doi");

	@Override
	public String[] getMetadata(Item item, Map<String, String> fieldCache, String fieldName) {
		String result = "<map name=\"" + item.getID() + "\">";
		List<MetadataValue> MetadataValuePMID = item.getMetadataByMetadataString(fieldPubmedID);
		if (MetadataValuePMID != null && MetadataValuePMID.size() > 0) {
			result += "<val name=\"pmid\">" + MetadataValuePMID[0].value + "</val>";
		}
		List<MetadataValue> MetadataValueDoi = item.getMetadataByMetadataString(fieldDoiID);
		if (MetadataValueDoi != null && MetadataValueDoi.size() > 0) {
			result += "<val name=\"doi\">" + MetadataValueDoi[0].value + "</val>";
		}
		List<MetadataValue> MetadataValueWos = item.getMetadataByMetadataString(fieldWosID);
		if (MetadataValueWos != null && MetadataValueWos.size() > 0) {
			result += "<val name=\"ut\">" + MetadataValueWos[0].value + "</val>";
		}
		result += "</map>";
		return new String[]{result};
	}
}