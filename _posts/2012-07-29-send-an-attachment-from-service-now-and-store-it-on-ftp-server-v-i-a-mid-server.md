---
layout: post
title: Send an Attachment from ServiceNow and Store It on an FTP Server via MID Server
tag: servicenow
---

Basically, we are trying to send an attachment to an FTP server as soon as it is attached. As I mentioned, it's always better to write the logic for writing the file to FTP in a MID server script include.

We will write a business rule on the attachment table so that whenever an entry is inserted, we call the MID script include, pass the attachment that was just inserted in base64 format, create a file (from the information in the attachment) on the FTP server using any of the writers/outbuffers in Java, and close the connection.

Name of the Business Rule :call_MIDServer_SendFile
Table: sys_attachment
When : After insert

```javascript
fnToMidserver();
function fnToMidserver(){

   try{
      var gr = new GlideRecord("your_table");
      gr.get(current.table_sys_id);
      var fileName ='SNOW_'+gr.number+'_'+gr.sys_id+'_'+current.file_name;
      var ftpServer = gs.getProperty("host");
      var username = gs.getProperty("login");
      var pswrd = gs.getProperty("password");
      var port= gs.getProperty("port");
      var type=gs.getProperty("type");
      var timeout=gs.getProperty("timeout");
      var passive=gs.getProperty("passive");
      var ftpFilePath = gs.getProperty("FTP Attachment");
      /* We encode the Attachment to base64 as we cannot transfer it as a plain string.The code below handles the conversion*/

      var StringUtil = Packages.com.glide.util.StringUtil;
      var sa = new  Packages.com.glide.ui.SysAttachment();
      var binData =  sa.getBytes(current);
      var encData =StringUtil.base64Encode(binData);

/*End of the code */
      var jspr = new JavascriptProbe('Integration');
      jspr.setName('FileToMidServer'); //Any descriptive name will do
      jspr.setJavascript("var ddr = new AttachmentSender();res = ddr.execute();");
      jspr.addParameter("targetFileName",fileName);
      jspr.addParameter("encodedData",encData);
      var cred = username+":"+pswrd;
      jspr.addParameter("ftpCred",cred);
      jspr.addParameter("ftpTargetServer",ftpServer);
      jspr.addParameter("ftpPort",port);
      jspr.addParameter("targetPath",ftpFilePath);
      jspr.addParameter("host",ftpServer);
      jspr.addParameter("transportMethod",type);
      jspr.create();
      gs.log('Completed: check Mid Server log');
   }
   catch(e){
      gs.log('exception in calling mid server : '+e);

   }
}
```
One of the challenges we faced in sending the base64 encoded string to the MID server was that we don't have the `StringUtil` class included with the MID server's JARs. After using the Reflection API, we came up with a different class, `Base64()`, and we use the `decode` method for the conversion into a plain string.

The Script Include goes this way :

Name : Attachment Sender

```javascript
var AttachmentSender = Class.create();

AttachmentSender.prototype = {
   initialize : function() {
          this.debug = false;

      //If you would like to move processed files to a target location, set the next two parameters.
      //Make sure your file name ends up being unique. We will not overwrite a file by the same name
      //in the target directory...
      this.moveProcessedFiles = true;
      this.MIDSERVER_PROCESSED_FILE_PATH = "processed/";

      this.resLog = "FTP Log: \n";
      this.log("Initializing SNDataRetriever");
      this.MIDSERVER_FILE_PATH = "work/";
      this.MIDSERVER_FILE_NAME = probe.getParameter('targetFileName');

      this.Encoded_Data = probe.getParameter('encodedData');

      this.useProxy = this.getConfigParameter("mid.proxy.use_proxy");
      if (this.useProxy){
         this.proxyHost =this.getConfigParameter("mid.proxy.host");
         this.proxyPort =this.getConfigParameter("mid.proxy.port");
         this.proxyUser =this.getConfigParameter("mid.proxy.username");
         this.proxyPass =this.getConfigParameter("mid.proxy.password");
      }
      this.user = this.getConfigParameter("mid.instance.username");
      this.password = this.getConfigParameter("mid.instance.password");

      var ftpCredArr = this.decryptCredentials(probe.getParameter('ftpCred'));
      this.ftpUser = ftpCredArr[0];
      this.ftpPass = ftpCredArr[1];
      this.log('ftp username : '+ftpCredArr[0]);
      this.log('ftp password : '+ftpCredArr[1]);
      this.ftpTargetServer = probe.getParameter('ftpTargetServer');
      this.ftpPort = (this.isANumber(probe.getParameter('ftpPort'))) ? (probe.getParameter('ftpPort')) : null;

      this.targetPath = probe.getParameter('targetPath');
      this.targetFileName = probe.getParameter('targetFileName');

      this.host = probe.getParameter('host');

      this.transportMethod = probe.getParameter('transportMethod');

      if (this.debug){
         this.log("\n********** Debug Info **********\nuser: " + this.user + "\npass: " + this.password + "\ntransportMethod: " + this.transportMethod + "\nreport: " + this.reportURL+ "\nhost: "+ this.host);
         this.log("\n********** Proxy Info **********\nproxyNeeded: " + this.proxyNeeded +"\nproxyUser : " + this.proxyUser + "\nproxyPass :" + this.proxyPass );
         this.log("\nproxyHost: " + this.proxyHost + "\nproxyPort:" + this.proxyPort);
         this.log("\n********** FTP Info ************\nftpUser: "+ this.ftpUser + "\nftpPass: " + this.ftpPass + "\nftpPort: " + this.ftpPort);
         this.log("\n********** End of Debug ********\n\n");
      }

   },
   
   getConfigParameter: function(parm){
      var m= Packages.com.service_now.mid.MIDServer.get();
      var config = m.getConfig();
      var res = config.getParameter(parm);
      var res2 = config.getProperty(parm);
      if (res){
         return res;
      }
      else if (res2){
         return res2;
      }
      else{
         config = Packages.com.service_now.mid.services.Config.get();
         return config.getProperty(parm);
      }

   },

   decryptCredentials: function(data) {
      var cred = new String(data);
      var e = new Packages.com.glide.util.Encrypter();

      var jsCred = cred + '';
      var usernamePass = e.decrypt(jsCred);
      var credArr = usernamePass.split(":", 2);
      return credArr;
   },

   saveToFile: function(targetPath) {
      var tmpLoc;
      var result = true;
      var strContent=new Packages.com.glide.util.Base64().decode(this.Encoded_Data);

      try{
         tmpLoc = this.MIDSERVER_FILE_PATH + this.MIDSERVER_FILE_NAME;

         var fos = new Packages.java.io.FileOutputStream(tmpLoc);

         for(var index=0 ; index<strContent.length ; index++){
            fos.write(strContent[index].toString());
         }
         fos.close();


         this.log("File saved to: " + tmpLoc);

      }
      catch(e){

         result = false;
      }
      return result;
   },

   copyToFTP: function() {
      var tmpLoc;
      var connectionType;
      var ftpSuccess = false;

      if (this.transportMethod == "FTPS (Auth SSL)"){
         connectionType = "AUTH_SSL_FTP_CONNECTION";
         if (!this.ftpPort) {this.ftpPort = 21;}
         }
      else if (this.transportMethod == "FTPS (Auth TLS)"){
         connectionType = "AUTH_TLS_FTP_CONNECTION";
         if (!this.ftpPort) {this.ftpPort = 21;}
         }
      else if (this.transportMethod == "FTPS (Implicit SSL)"){
         connectionType = "IMPLICIT_SSL_FTP_CONNECTION";
         if (!this.ftpPort) {this.ftpPort = 990;}
         }
      else if (this.transportMethod == "FTPS (Implicit TLS)"){
         connectionType = "IMPLICIT_TLS_FTP_CONNECTION";
         if (!this.ftpPort) {this.ftpPort = 990;}
         }
      else{
         connectionType = "FTP_CONNECTION";
         if (!this.ftpPort) {this.ftpPort = 21;}
         }
      this.log("ConnectionType: " + connectionType + " and port: " + this.ftpPort);

      var pt = new Packages.java.util.Properties();
      pt.setProperty("connection.host", this.ftpTargetServer);
      pt.setProperty("connection.port", this.ftpPort);
      pt.setProperty("user.login", this.ftpUser);
      pt.setProperty("user.password", this.ftpPass);
      pt.setProperty("connection.type", connectionType);
      pt.setProperty("connection.timeout", "10000");
      pt.setProperty("connection.passive", "true");

      try{
         var connection = Packages.org.ftp4che.FTPConnectionFactory.getInstance(pt);

         var fromFile = new Packages.org.ftp4che.util.ftpfile.FTPFile(this.MIDSERVER_FILE_PATH, this.MIDSERVER_FILE_NAME);
         var toFile = new Packages.org.ftp4che.util.ftpfile.FTPFile(this.targetPath, this.targetFileName);
      }
      catch(e){

      }
      var connectionLog = "Connection Log:\n";
      var connected = false;
      try{
         connection.connect();
         this.log("Connecting to " + this.ftpTargetServer + " on port " + this.ftpPort);

         connection.noOperation();
         connected = true;
      }
      catch(e){
         connectionLog += "\nException in block B: " + e;
         connected = false;
      }

      if (connected == true){
         try{
            this.log("Connected...");
            this.log("Uploading " + fromFile + " to " + toFile);
            connection.uploadFile(fromFile, toFile);
            this.log("File successfully uploaded\n\n");
            connection.disconnect();
            ftpSuccess = true;
         }
         catch(e){
            connectionLog += "\n**********FAILURE: Connection to FTP server failed**************\n";
            connectionLog += "\nException in block C: \n" + e;
         }
      }
      else{
         connectionLog += "\n**********FAILURE: Connection to FTP server failed**************\n";
      }

      this.log(connectionLog);
      return ftpSuccess;
   },

   moveProcessedFile: function(){

      file = new Packages.java.io.File(this.MIDSERVER_FILE_PATH+this.MIDSERVER_FILE_NAME);// Work directory
      dir = new Packages.java.io.File(this.MIDSERVER_PROCESSED_FILE_PATH);// Move file to new (processed) directory
      success = file.renameTo(new Packages.java.io.File(dir, file.getName()));

      if (!success) {
         this.log('File was not successfully moved!');
      }
      else{
         this.log("File was moved from TMP directory to a processed directory");
      }
   },

   getLog: function() {
      return this.resLog;
   },

   log: function(data) {
      ms.log(data);
      this.resLog+="\n"+data;
   },

   isANumber: function(data) {
      data = data + '';
      return ((data - 0) == data && data.length > 0);
   },


   execute: function() {
      var result = '';

      var pushRes = true;

      var saveRes = this.saveToFile(this.targetPath+ this.targetFileName);
      if(saveRes == true){
         pushRes = this.copyToFTP();
         result = "Sucess";
         //Move tmp file to a processed directory
         if (saveRes && pushRes && this.moveProcessedFiles){
            this.moveProcessedFile();
         }
      }
      else{
         result = "Failed";
         this.log("The report was empty?");
      }
     return result;
   },

   type : "AttachmentSender"
};
```


All the methods are mostly taken from `SNDataRetriever`; however, only one method needs mentioning: `moveProcessedFile`. This is used to copy the file from one directory to another (on the MID server) once the transfer to FTP is done. Also, notice that we used `FileOutputStream()` in the `saveToFile()` function to create a file on the FTP server.

**Acknowledgments:**
1.  The entire code was written by Mohammed. I am just blogging it.
2.  Again, as you can observe, most of the code is from ServiceNow Guru. We just modified it, and I blogged it so that it may come in handy for anybody.
