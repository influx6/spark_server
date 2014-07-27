library spec;

import 'dart:io';
import 'dart:async';
import 'package:spark_server/server.dart';
import 'package:hub/hub.dart';
import 'package:spark_utils/utils.dart';

void main(){

   Server.register();
   SparkUtils.register();

   var n =  Sparkflow.create('basic-server','a basic test fbp server');
   n.use('spark.server/protocols/http','tserver');
   n.use('spark.utils/utils/consolepackets','pkprint');

   n.use('spark.server/protocols/routeboy','doc');
   n.use('spark.server/protocols/pageview','doc_view');

   n.use('spark.server/protocols/routeboy','root');
   n.use('spark.server/protocols/viewfn','rootview');

   n.use('spark.server/protocols/routeboy','doc_hm');
   n.use('spark.server/protocols/vfs_file','doc_file');

   n.use('spark.server/protocols/routeboy','dirlist');
   n.use('spark.server/protocols/vfs_dir','dirlist_dir');

   n.ensureBinding('tserver','io:req','doc','io:reqs');
   n.ensureSetBinding('tserver','io:req',['dirlist','doc_hm','doc','root'],'io:req');

   n.ensureBinding('doc','io:req','doc_view','view:req');
   n.ensureBinding('root','io:req','root_view','view:req');
   n.ensureBinding('doc_hm','io:req','doc_file','view:req');
   n.ensureBinding('dirlist','io:req','dirlist_dir','view:req');

   n.ensureBinding('root','io:req','root_view','view:req');

   n.schedulePacket('tserver','io:conf',{ 
     'port':3001 
   });

   n.schedulePacket('rootview','view:fn',(c,r){
      r.enableDefaults();
      r.on('get',(rr) => rr..send('Welcome TestPage.com')..end());
   });

   n.schedulePacket('doc','io:conf',{ 
     'route': new RegExp('/')
   });

   n.schedulePacket('doc','io:conf',{ 
     'route': new RegExp('/doc')
   });

   n.schedulePacket('doc_hm','io:conf',{ 
     'route': new RegExp('/text.md')
   });

   n.schedulePacket('dirlist','io:conf',{ 
     'route': new RegExp('/assets')
   });

   n.schedulePacket('doc_view','view:conf',{ 
     'view':'../assets/views/home/index.html'
   });

   n.schedulePacket('vf','view:conf',{ 
     'view':'../assets/words.text' 
   });

   n.boot().then((_){
      

   });

}
