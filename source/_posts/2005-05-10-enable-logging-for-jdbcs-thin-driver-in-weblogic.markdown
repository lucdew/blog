--- 
layout: post
title: Enable logging for JDBC&#39;s thin driver in Weblogic
wordpress_id: 117
wordpress_url: http://www.dewavrin.info/?p=117
categories: 
- weblogic
tags: []

---
Here's a quick and dirty tip to enable JDBC logging for Oracle thin drivers.Enabling JDBC logging for connections of a pool is straightforward with JDBC connectionproxies like p6spy tool. Sadly some applications still don't use connection poolsconfigured on J2EE application server and connect directly to database withoutretrieving a connection from a pool and with the JDBC URL hardcoded.For the latters, you can still trace JDBC activity.To do so,-  1) Configure Weblogic server, to use the Oracle's debug thin driver which is called ojdbc14_g.jarand its located in the $WEBLOGIC_HOME/server/ext/jdbc/oracle/ directory.Just add it in the server's CLASSPATH the path to this library.
-  2) Put the following class in the server's CLASSPATH to control the logging level. The default one (2)is very high it creates a huge amount of log. This class takes as first argument the log levelwhich should go from 1 (lower) to 3 (higher)<pre lang="java">import oracle.jdbc.driver.OracleLog;import weblogic.logging.NonCatalogLogger;/** * Class that sets the Oracle's thin driver log level * */public class OracleLoggingSetter {   protected final static NonCatalogLogger logger = new NonCatalogLogger("OracleLoggingSetter");   static final int LOWLOGLEVEL=1;   static final int MEDIUMLOGLEVEL=2;   static final int HIGHLOGLEVEL=3;   public static void main(String[] args) {   int loglevel=0;   try {   loglevel=Integer.parseInt(args[0]);   }   catch(NumberFormatException e) {   logger.error("Wrong oracle log level");   return;   }   switch (loglevel) {case 1:logger.info("Setting oracle low log level ");OracleLog.setLogVolume(LOWLOGLEVEL);break;case 2:logger.info("Setting oracle default log level ");OracleLog.setLogVolume(MEDIUMLOGLEVEL);break;case 3:logger.info("Setting oracle high log level ");OracleLog.setLogVolume(HIGHLOGLEVEL);break;default:logger.info("log level is incorrect or unspecified, no action performed ");break;}   }}</pre>
-  3) Configure Weblogic to use this startup class and give the log level as an argument (1 is fineand doesn't fill too quickly).(On the Startup &amp; shutdown node of the adminisration console )
-  4) Enable JDBC logging for the Weblogic server in the administration console.(Server node -&gt; Logging tab -&gt; JDBC tab )
-  5) Restart the server
Now you should see the connection string used, the SQL (prepared)statementsand the Oracle's session attributes in the JDBC log file.Note that enabling logging has a great impact on performance even when the logging levelis low.
