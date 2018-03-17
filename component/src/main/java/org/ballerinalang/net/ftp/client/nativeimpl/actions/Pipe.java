/*
 * Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.net.ftp.client.nativeimpl.actions;

import org.ballerinalang.bre.Context;
import org.ballerinalang.model.types.TypeKind;
import org.ballerinalang.model.values.BConnector;
import org.ballerinalang.model.values.BStruct;
import org.ballerinalang.nativeimpl.io.IOConstants;
import org.ballerinalang.nativeimpl.io.channels.base.Channel;
import org.ballerinalang.natives.annotations.Argument;
import org.ballerinalang.natives.annotations.BallerinaAction;
import org.ballerinalang.natives.annotations.ReturnType;
import org.ballerinalang.net.ftp.client.nativeimpl.util.FTPConstants;
import org.wso2.transport.remotefilesystem.client.connector.contract.VFSClientConnector;
import org.wso2.transport.remotefilesystem.client.connector.contractimpl.VFSClientConnectorImpl;
import org.wso2.transport.remotefilesystem.message.RemoteFileSystemMessage;

import java.util.HashMap;
import java.util.Map;

/**
 * Pipe the once input stream to another channel.
 */
@BallerinaAction(
        packageName = "ballerina.net.ftp",
        actionName = "pipe",
        connectorName = FTPConstants.CONNECTOR_NAME,
        args = {@Argument(name = "ftpClientConnector", type = TypeKind.CONNECTOR),
                @Argument(name = "source", type = TypeKind.STRUCT, structType = "ByteChannel",
                        structPackage = "ballerina.io"),
                @Argument(name = "file", type = TypeKind.STRUCT, structType = "File",
                        structPackage = "ballerina.lang.files"),
                @Argument(name = "mode", type = TypeKind.STRING)},
        returnType = {@ReturnType(type = TypeKind.STRUCT, structType = "FTPClientError",
                                  structPackage = "ballerina.net.ftp")
        }
)
public class Pipe extends AbstractFtpAction {

    @Override
    public void execute(Context context) {
        BConnector clientConnector = (BConnector) context.getRefArgument(0);
        String url = (String) clientConnector.getNativeData(FTPConstants.URL);
        BStruct destination = (BStruct) context.getRefArgument(2);

        BStruct sourceChannel = (BStruct) context.getRefArgument(1);
        Channel byteChannel = (Channel) sourceChannel.getNativeData(IOConstants.BYTE_CHANNEL_NAME);
        RemoteFileSystemMessage message = new RemoteFileSystemMessage(byteChannel.getInputStream());
        //Create property map to send to transport.
        Map<String, String> propertyMap = new HashMap<>(5);
        propertyMap.put(FTPConstants.PROPERTY_URI, url + destination.getStringField(0));
        propertyMap.put(FTPConstants.PROPERTY_ACTION, FTPConstants.ACTION_WRITE);
        propertyMap.put(FTPConstants.PROTOCOL, FTPConstants.PROTOCOL_FTP);
        propertyMap.put(FTPConstants.FTP_PASSIVE_MODE, Boolean.TRUE.toString());
        String mode = context.getStringArgument(0);
        if (mode.equalsIgnoreCase("append") || mode.equalsIgnoreCase("a")) {
            propertyMap.put(FTPConstants.PROPERTY_APPEND, Boolean.TRUE.toString());
        }
        FTPClientConnectorListener connectorListener = new FTPClientConnectorListener(context);
        VFSClientConnector connector = new VFSClientConnectorImpl(propertyMap, connectorListener);
        connector.send(message);
    }
}