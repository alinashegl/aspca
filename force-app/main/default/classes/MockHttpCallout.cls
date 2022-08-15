@isTest
global class MockHttpCallout implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://maps.googleapis.com/maps/api/geocode/json?latlng=40.75335663830957,-73.99213560828238&result_type=street_address&key=AIzaSyB_vRSHbde-6dByBFtnz-shb4CjuG8OPH0', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Response Data
        Map<String, Object> responseMap = new Map<String, Object>();
        
        List<Object> resultsList = new List<Object>();
        Map<String, Object> resultsMap = new Map<String, Object>();
        resultsMap.put('formatted_address', '269 W 36th St, New York, NY 10018, USA');
        resultsList.add(resultsMap);
        responseMap.put('results', resultsList);
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(responseMap));
        res.setStatusCode(200);
        return res;
    }
}