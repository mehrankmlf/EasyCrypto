/**
 Enum to represent a HTTP request method.

 */
public enum HTTPMethod : Equatable {

    /** The GET method requests a representation of the specified resource. Requests using GET should only retrieve data. */
    case get

    /**
     The POST method is used to submit an entity to the specified resource, often causing a change in state or side effects on the server.
     */
    case post

    /**
     The PUT method replaces all current representations of the target resource with the request payload.
     */
    case put

    /**
     The DELETE method deletes the specified resource.
     */
    case delete
    
     var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
