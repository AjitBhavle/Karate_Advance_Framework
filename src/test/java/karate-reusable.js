function() {
	    var GraphQLQueries = Java.type('com.altimetrik.orchestration.util.GraphQLQueries');
        var getAcct = new GraphQLQueries();
		var MongoDBConnector = Java.type('com.altimetrik.orchestration.util.MongoDBConnector');           
        var getData = new MongoDBConnector();
  return {
     getRandomString: function(s) {
        var text = "";
        var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        for (var i = 0; i < s; i++)
          text += possible.charAt(Math.floor(Math.random() * possible.length));
        return text;
      },
    getAcctByID: function(arg) {
        return getAcct.getAccountByID(arg);  
      },
    getValueByAttribute: function(arg1,arg2) {
        return getData.getAttributeValueByAccountName(arg1,arg2);  
      },
 	getValueByAttribute: function(arg1,arg2,arg3) {
        return getData.getNestedAttributeValueByAccountName(arg1,arg2,arg3);  
      },
 	getValueByAttributeAndAcctID: function(arg1,arg2) {
        return getData.getAttributeValueByAccountID(arg1,arg2);
      },
  	getValueByNestedAttributeAndAcctID: function(arg1,arg2,arg3) {
        return getData.getNestedAttributeValueByAccountID(arg1,arg2,arg3);  
      }
  }
}