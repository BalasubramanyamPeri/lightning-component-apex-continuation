global class MyController {

    // Called via JavaScript Remoting
    @RemoteAction
    global static Object callService(Integer count){
        // Make an HTTPRequest as we normally would
        // Remember to configure a Remote Site Setting for the service!
        String url = 'https://node-count.herokuapp.com/'+count;
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);

        // Create a Continuation for the HTTPRequest        
        Continuation con = new Continuation(60);
        con.state = con.addHttpRequest(req);
        con.continuationMethod = 'callback';        

        // Return it to the system for processing
        return con;
    }

    global static Object callback(Object state) {
        HttpResponse response = Continuation.getResponse((String)state);

        Integer statusCode = response.getStatusCode();
        if (statusCode >= 2000) {
            return 'Continuation error: ' + statusCode;
        }

        return response.getBody();
    }

}