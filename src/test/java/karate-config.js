function() {    
  var config = {
    baseUrl: 'http://localhost:9090',
    path_CreateAccount: '/api/v1/createaccount',
	path_DeleteAccount: '/api/v1/deleteaccount',
	path_UpdateAccount: '/api/v1/updateaccount',
	path_GetAccount: '/api/v1/getaccount/graphql',
	mongoDBURL: 'localhost',
	mongoDBPort: '27017',
	mongoDBName: 'mydb',
	mongoDBCollection: 'account',
  }
  return config;
}