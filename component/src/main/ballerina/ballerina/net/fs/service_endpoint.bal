package ballerina.net.fs;

///////////////////////////////////
/// FileSystem Service Endpoint ///
///////////////////////////////////
public struct Service {
    string epName;
    ServiceEndpointConfiguration config;
}

@Description {value:"Configuration for HTTP service endpoint"}
@Field {value:"host: Host of the service"}
@Field {value: "events: File system events to watch. eg:- create, delete, modify"}
@Field {value: "recursive: Recursively monitor all folders in the given folder path"}
public struct ServiceEndpointConfiguration {
    string dirURI;
    string events;
    boolean recursive;
}

@Description {value:"Gets called when the endpoint is being initialized during the package initialization."}
@Param {value:"epName: The endpoint name"}
@Param {value:"config: The ServiceEndpointConfiguration of the endpoint"}
@Return {value:"Error occured during initialization"}
public function <Service ep> init (string epName, ServiceEndpointConfiguration config) {
    ep.epName = epName;
    ep.config = config;
    var err = ep.initEndpoint();
    if (err != null) {
        throw err;
    }
}

public native function <Service ep> initEndpoint () returns (error);

@Description {value:"Gets called every time a service attaches itself to this endpoint. Also happens at package initialization."}
@Param {value:"ep: The endpoint to which the service should be registered to"}
@Param {value:"serviceType: The type of the service to be registered"}
public native function <Service ep> register (type serviceType);

@Description {value:"Starts the registered service"}
public native function <Service ep> start ();

@Description {value:"Returns the connector that client code uses"}
@Return {value:"The connector that client code uses"}
public native function <Service ep> getConnector () returns (ServerConnector repConn);

@Description {value:"Stops the registered service"}
public native function <Service ep> stop ();

public connector ServerConnector () {}