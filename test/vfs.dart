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
   n.use('spark.server/utils/serverConsole','console');

   n.use('spark.server/protocols/routeboy','doc');
   n.use('spark.server/protocols/pageview','doc_view');

   n.use('spark.server/protocols/routeboy','root');
   n.use('spark.server/protocols/viewfn','root_view');

   n.use('spark.server/protocols/routeboy','doc_hm');
   n.use('spark.server/protocols/vfs_file','doc_file');

   n.use('spark.server/protocols/routeboy','dirlist');
   n.use('spark.server/protocols/vfs_dir','dirlist_dir');

   n.ensureBinding('tserver','io:req','doc','io:reqs');
   n.ensureBinding('tserver','io:req','console','in:req');

   n.ensureSetBinding('tserver','io:req',['dirlist','doc_hm','doc','root'],'io:req');

   n.ensureBinding('doc','io:stream','doc_view','view:req');
   n.ensureBinding('root','io:stream','root_view','view:req');
   n.ensureBinding('doc_hm','io:stream','doc_file','view:req');
   n.ensureBinding('dirlist','io:stream','dirlist_dir','view:req');
   n.ensureBinding('doc_file','view:errors','console','in:req');


   n.schedulePacket('tserver','io:conf',{ 
     'port':3001,
   });

   n.schedulePacket('root_view','view:fn',(c,r){
      r.enableDefaults();
      r.on('get',(rr) => rr..send('Welcome TestPage.com')..end());
   });

   n.schedulePacket('root','io:conf',{ 
     'route': new RegExp(r'^/$')
   });

   n.schedulePacket('doc','io:conf',{ 
     'route': new RegExp(r'/doc')
   });

   n.schedulePacket('doc_view','view:conf',{ 
     'view':'../assets/views/home/index.html'
   });

   n.network.tap('doc_file','view:req',Funcs.tag('view:req'));

   n.schedulePacket('doc_hm','io:conf',{ 
     'route': new RegExp(r'/text.md'),
   });

   n.schedulePacket('doc_file','view:conf',{ 
     'view': '../assets/text.md',
     'writable': true
   });

   n.schedulePacket('dirlist','io:conf',{ 
     'route': new RegExp(r'/assets')
   });

   n.schedulePacket('dirlist_dir','view:conf',{ 
     'view':'../assets' 
   });

   n.boot().then((_){
      

   });

}
