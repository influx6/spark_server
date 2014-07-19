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
   n.use('spark.server/protocols/websocks','hm_ws');
   n.use('spark.server/protocols/routeboy','hmr');
   n.use('spark.utils/utils/applyfn','homereq');
   n.use('spark.server/protocols/routeboy','abr');
   n.use('spark.utils/utils/applyfn','abreq');
   n.use('spark.utils/utils/consolepackets','pkprint');

   n.ensureBinding('tserver','io:req','hmr','in:reqs');
   n.ensureBinding('tserver','io:req','abr','in:reqs');
   n.ensureBinding('tserver','io:req','pkprint','prt:in');
   /*n.ensureBinding('pkprint','prt:in','tserver','io:req');*/
   n.ensureBinding('hmr','io:req','pkprint','prt:in');
   n.ensureBinding('agr','io:req','pkprint','prt:in');
   n.ensureBinding('hmr','io:req','homereq','apply:in');
   n.ensureBinding('abr','io:req','abrreq','apply:in');


   n.addIIP('tserver',{ 'port':3001 });
   n.addIIP('hmr',{ 'route':new RegExp(r'home') });
   n.addIIP('abr',{ 'route':new RegExp(r'about') });

   var fp = Funcs.compose(Funcs.tag('ConnectionStream',"{tag} -> {res} \n"),Funcs.prettyPrint);
   n.network.connectionStream.on(fp);

   n.boot().then((_){

   });
}
