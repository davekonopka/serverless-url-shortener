console.log('Loading event');
var AWS = require("aws-sdk");
var docClient = new AWS.DynamoDB.DocumentClient();
exports.handle = function(event, context) {
    var token = (event.token == undefined ? "NO TOKEN" : event.token);
    var url = (event.url == undefined ? "NO URL" : event.url);
    console.log("Request received:\n", JSON.stringify(event));
    console.log("Context received:\n", JSON.stringify(context));

    table = "redir_urls";

    var params = {
        TableName: table,
        Key:{
            "token": token
        },
        UpdateExpression: "set destination_url=:p",
        ExpressionAttributeValues:{
            ":p":url
        },
        ReturnValues:"UPDATED_NEW"
    };

    console.log("Updating the item...");
    docClient.update(params, function(err, data) {
        if (err) {
            console.error("Unable to update item. Error JSON:", JSON.stringify(err, null, 2));
        } else {
            console.log("UpdateItem succeeded:", JSON.stringify(data, null, 2));
        }
    });
    context.succeed();
}
