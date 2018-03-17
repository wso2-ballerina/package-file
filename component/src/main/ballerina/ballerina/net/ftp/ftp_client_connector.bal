package ballerina.net.ftp;

import ballerina.file;
import ballerina.io;

@Description {value:"Represents an error which will occur while FTP client operations"}
@Field {value:"message:  An error message explaining about the error"}
@Field {value:"cause: The error(s) that caused FTPClientError to get thrown"}
public struct FTPClientError {
    string message;
    error[] cause;
}

@Description {value:"FTP client connector for outbound FTP file requests"}
@Param { value:"connectorOptions: connector options" }
public connector ClientConnector (ClientEndpointConfiguration config) {

    @Description {value:"Retrieves blob value of a file"}
    @Param {value:"file: The file to be read"}
    @Return {value:"channel: A ByteChannel that represent the data source"}
    @Return {value:"Error occured during FTP client invocation"}
    native action read (file:File file) (io:ByteChannel, FTPClientError);

    @Description {value:"Copies a file from a given location to another"}
    @Param {value:"target: File/Directory that should be copied"}
    @Param {value:"destination: Location where the File/Directory should be pasted"}
    @Return {value:"Error occured during FTP client invocation"}
    native action copy (file:File source, file:File destination) (FTPClientError);

    @Description {value:"Moves a file from a given location to another"}
    @Param {value:"target: File/Directory that should be moved"}
    @Param {value:"destination: Location where the File/Directory should be moved to"}
    native action move (file:File target, file:File destination) (FTPClientError);

    @Description {value:"Deletes a file from a given location"}
    @Param {value:"target: File/Directory that should be deleted"}
    @Return {value:"Error occured during FTP client invocation"}
    native action delete (file:File target) (FTPClientError);

    @Description {value:"Writes a file using the given blob"}
    @Param {value:"blob: Content to be written"}
    @Param {value:"file: Destination path of the file"}
    @Param {value:"mode: Whether to append or overwrite the given content ['append' | 'a' or 'overwrite' | 'o']"}
    @Return {value:"Error occured during FTP client invocation"}
    native action write (blob content, file:File file, string mode) (FTPClientError);

    @Description {value:"Create a file or folder"}
    @Param {value:"file: Path of the file"}
    @Param {value:"isDir: Specify whether it is a file or a folder"}
    @Return {value:"Error occured during FTP client invocation"}
    native action createFile (file:File file, boolean isDir) (FTPClientError);

    @Description {value:"Checks the existence of a file"}
    @Param {value:"file: File struct containing path information"}
    @Return {value:"boolean: The availability of the file"}
    native action exists (file:File file) (boolean, FTPClientError);

    @Description {value:"Pipe the content to a file using the given ByteChannel"}
    @Param {value:"channel: Content to be written"}
    @Param {value:"file: Destination path of the file"}
    @Param {value:"mode: Whether to append or overwrite the given content ['append' | 'a' or 'overwrite' | 'o']"}
    @Return {value:"Error occured during FTP client invocation"}
    native action pipe (io:ByteChannel channel, file:File file, string mode) (FTPClientError);
}