package com.altimetrik.orchestration.util;

import java.util.Map;

import com.intuit.karate.Runner;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;

/**
 * This class contains all methods related to Mongo DB operations
 * 
 * @author smulani
 *
 */

public class MongoDBConnector {

	@SuppressWarnings("deprecation")
	public MongoDBConnector() {
		result = Runner.runFeature("classpath:com/altimetrik/orchestration/feature/mongodb-confi.feature", null, true);
		mongo = new MongoClient(result.get("mongoDBURL").toString(),
				Integer.parseInt(result.get("mongoDBPort").toString()));
		db = mongo.getDB(result.get("mongoDBName").toString());
		collection = db.getCollection(result.get("mongoDBCollection").toString());
	}

	Map<String, Object> result;
	public static MongoClient mongo;
	public static DB db;
	public static DBCollection collection;

	@SuppressWarnings({ "deprecation" })
	public static void main(String[] args) {
		mongo = new MongoClient("localhost", 27017);
		db = mongo.getDB("mydb");
		collection = db.getCollection("account");

		getRecordCountsInCollection();
		getFirstRecordInCollection();
		getAllRecordsFromACollection();
		// getRecordByacctName("Test User 62524");
		getRecordByAttribute("acctId", "CITI54454");
		getAttributeValueByOtherAttribute("acctName", "TestUser_16526", "acctId");
		getNestedAttributeValueByOtherAttribute("acctName", "TestUser_16526", "contacts", "email");
	}

	/**
	 * This method is used to get count of all the records from the collection
	 */
	private static void getRecordCountsInCollection() {
		long dbObject = collection.count();
		System.out.println(dbObject);
	}

	/**
	 * This method is used to get first record from the collection
	 */
	private static void getFirstRecordInCollection() {
		DBObject dbObject = collection.findOne();
		System.out.println(dbObject);
	}

	/**
	 * This method is used to get all records from the collection
	 */
	private static void getAllRecordsFromACollection() {
		DBCursor cursor = collection.find();
		while (cursor.hasNext()) {
			System.out.println(cursor.next());
		}
	}

	/**
	 * This method is used to get a value of given attribute from the collection
	 */
	private static void getRecordByAttribute(String strAttri, String strName) {
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put(strAttri, strName);

		DBCursor cursor = collection.find(whereQuery);
		while (cursor.hasNext()) {
			System.out.println(cursor.next());
		}
	}

	/**
	 * This method is used to get a value of given attribute using another
	 * attribute's value from the collection
	 */
	private static void getAttributeValueByOtherAttribute(String strAttri1, String strAttriValue1, String strAttri2) {
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put(strAttri1, strAttriValue1);
		BasicDBObject fields = new BasicDBObject();
		fields.put(strAttri2, 1);

		DBCursor cursor = collection.find(whereQuery, fields);
		while (cursor.hasNext()) {
			String temp = cursor.next().get(strAttri2).toString();
			System.out.println(temp);
		}
	}

	/**
	 * This method is used to get a value of given nested attribute value from the
	 * collection
	 */
	private static void getNestedAttributeValueByOtherAttribute(String strAttri1, String strAttriValue1,
			String strAttri2, String Attri3) {
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put(strAttri1, strAttriValue1);
		BasicDBObject fields = new BasicDBObject();
		fields.put(strAttri2, 1);

		DBCursor cursor = collection.find(whereQuery, fields);
		while (cursor.hasNext()) {
			String temp = cursor.next().get(strAttri2).toString();
			System.out.println(temp);
			if (temp.contains(",")) {
				String strNested[] = temp.split(",");
				for (String s1 : strNested) {
					if (s1.contains(Attri3)) {
						String result = (s1.split(":")[1]).replace("\"", "").replace("}", "").trim();
						System.out.println(result);
					}
				}
			}
		}
	}

	/**
	 * This method is used to get a value of given attribute using Account Name from
	 * the collection
	 */
	public String getAttributeValueByAccountName(String strAttriValue1, String strAttri2) {
		String strValue = "";
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put("acctName", strAttriValue1);
		BasicDBObject fields = new BasicDBObject();
		fields.put(strAttri2, 1);

		DBCursor cursor = collection.find(whereQuery, fields);
		while (cursor.hasNext()) {
			strValue = cursor.next().get(strAttri2).toString().trim();
			System.out.println(strValue);
		}
		return strValue;
	}

	/**
	 * This method is used to get a record using Account Name from the collection
	 */
	public String getRecordByacctName(String strName) {

		String strValue = "";
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put("acctName", strName);

		DBCursor cursor = collection.find(whereQuery);
		while (cursor.hasNext()) {
			strValue = cursor.next().toString();
			System.out.println(strValue);
		}
		return strValue;
	}

	/**
	 * This method is used to get a value of given nested attribute using Account
	 * Name from the collection
	 */

	public String getNestedAttributeValueByAccountName(String strAttriValue1, String strAttri2, String Attri3) {
		String strValue = "";
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put("acctName", strAttriValue1);
		BasicDBObject fields = new BasicDBObject();
		fields.put(strAttri2, 1);

		DBCursor cursor = collection.find(whereQuery, fields);
		while (cursor.hasNext()) {
			String temp = cursor.next().get(strAttri2).toString();
			System.out.println(temp);
			if (temp.contains(",")) {
				String strNested[] = temp.split(",");
				for (String s1 : strNested) {
					if (s1.contains(Attri3)) {
						strValue = (s1.split(":")[1]).replace("\"", "").replace("}", "").trim();
						System.out.println(strValue);
					}
				}
			}
		}
		return strValue;
	}

	/**
	 * This method is used to get a value of given attribute using Account ID from
	 * the collection
	 */

	public String getAttributeValueByAccountID(String strAttriValue1, String strAttri2) {
		String strValue = "";
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put("acctId", strAttriValue1);
		BasicDBObject fields = new BasicDBObject();
		fields.put(strAttri2, 1);

		DBCursor cursor = collection.find(whereQuery, fields);
		while (cursor.hasNext()) {
			strValue = cursor.next().get(strAttri2).toString().trim();
			System.out.println(strValue);
		}
		return strValue;
	}

	/**
	 * This method is used to get a value of given nested attribute using Account ID
	 * from the collection
	 */
	public String getNestedAttributeValueByAccountID(String strAttriValue1, String strAttri2, String Attri3) {
		String strValue = "";
		BasicDBObject whereQuery = new BasicDBObject();
		whereQuery.put("acctId", strAttriValue1);
		BasicDBObject fields = new BasicDBObject();
		fields.put(strAttri2, 1);

		DBCursor cursor = collection.find(whereQuery, fields);
		while (cursor.hasNext()) {
			String temp = cursor.next().get(strAttri2).toString();
			System.out.println(temp);
			if (temp.contains(",")) {
				String strNested[] = temp.split(",");
				for (String s1 : strNested) {
					if (s1.contains(Attri3)) {
						strValue = (s1.split(":")[1]).replace("\"", "").replace("}", "").trim();
						System.out.println(strValue);
					}
				}
			}
		}
		return strValue;
	}

}
