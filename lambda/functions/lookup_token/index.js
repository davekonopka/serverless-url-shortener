console.log('Loading event');
var AWS = require("aws-sdk");
var docClient = new AWS.DynamoDB.DocumentClient();
exports.handle = function(event, context) {
    console.log("Request received:\n", JSON.stringify(event));
    console.log("Context received:\n", JSON.stringify(context));
    var destination_url = '';
    var content = '';
    var params = {
        TableName: "redir_urls",
        Key: {
            "token": event.token
        }
    };
    docClient.get(params, function(err, data) {
        if (err) console.log(err); // an error occurred

	if ("Item" in data && "destination_url" in data.Item) {
		destination_url = data.Item.destination_url;
		content = "<html><body>Moved: <a href=\"" + destination_url + "\">" + destination_url + "</a></body></html>";
		context.succeed({ "destination_url": destination_url, "content": content });
	} else {
		content = "<html><body><h1>Not Found</h1></body></html>";
		context.fail(content);
	}
    });
}
