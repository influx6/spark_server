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
   n.use('spark.server/protocols/routeboy','abr');
   n.use('spark.utils/utils/applyfn','homereq');
   n.use('spark.utils/utils/applyfn','abreq');
   n.use('spark.utils/utils/consolepackets','pkprint');
   n.use('spark.utils/utils/consolepackets','pkprint');

   n.ensureBinding('tserver','io:req','hmr','io:req');
   n.ensureBinding('tserver','io:req','abr','io:req');
   n.ensureBinding('tserver','io:req','pkprint','prt:in');
   n.ensureBinding('hmr','io:stream','homereq','apply:in');
   n.ensureBinding('abr','io:stream','abreq','apply:in');


   n.schedulePacket('tserver',{ 'port':3001 });
   n.schedulePacket('hmr',{ 'route':new RegExp(r'/home') });
   n.schedulePacket('abr',{ 'route':new RegExp(r'/about') });

   n.schedulePacket('homereq','apply:fn',(r){
      var req = r, res = req.response;
      res.statusCode = 200;
      res.write('Welcome Home!');
      res.close();
   });
   n.schedulePacket('abreq','apply:fn',(r){
      var req = r, res = req.response;
      res.statusCode = 200;
      res.write('Welcome to about!');
      res.close();
   });

   n.boot().then((_){
      
       _.filter('hmr').then((r){
          print(r.data.sd.get('param'));
          r.data.port('io:reqs').tap((n) => print("hmr io:reqs got $n"));
       });

       _.filter('abr').then((r){
          print(r.data.sd.get('param'));
          r.data.port('io:reqs').tap((n) => print("abr io:reqs got $n"));
       });
   });
}
