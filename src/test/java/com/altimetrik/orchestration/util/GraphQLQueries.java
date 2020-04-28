package com.altimetrik.orchestration.util;

/**
 * This class contains all Graph QL related queries
 * 
 * @author smulani
 *
 */
public class GraphQLQueries {
	/**
	 * This method is used to return query of get account by Account ID
	 * 
	 * @param acctID
	 * @return
	 */

	public String getAccountByID(String acctID) {
		String strID = "";
		strID = "{\naccount(acctId: \"" + acctID
				+ "\")\n{id acctId acctName amount bankDetails{bankId bankName ifsc branchCode}\ncontacts{contactNumber email}\naddressDetails{addressLine1 addressLine2 city state country zip landmark}\namount accountType status\naudit{createdBy createdDate modifiedBy modifiedDate}\n}\n}";
		return strID;
	}
}
