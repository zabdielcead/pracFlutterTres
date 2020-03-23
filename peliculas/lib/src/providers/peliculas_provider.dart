
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:peliculas/src/models/pelicula_modelo.dart';

class PeliculasProvider {
  String _apikey    = 'b517fc113b3a276f51c69fabbbec189d';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';
  
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast(); // broadcast para que muchos puedan escuchar el stream

  //insertar información al stream funcion que recibe una lista de pelicula
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  //otro emitir la info stream escucharlo
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{
    final resp =  await http.get( url );
     final decodedData = json.decode(resp.body) ;
     final peliculas = new Peliculas.fromJsonList(decodedData['results']);
     //print(decodedData['results']);
     return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async{
      final url = Uri.https(_url, '3/movie/now_playing', {
        'api_key' : _apikey,
        'language' : _language
      });
      
   
      return await _procesarRespuesta(url);
  }

    Future<List<Pelicula>> getPopulares() async{
      if( _cargando) return [];
      _cargando = true;

      _popularesPage++;
      print('cargando siguientes...');
      final url = Uri.https(_url, '3/movie/popular', {
        'api_key'  : _apikey,
        'language' : _language,
        'page'     : _popularesPage.toString()
      });

      final resp = await _procesarRespuesta(url);
      
      _populares.addAll(resp);

      popularesSink(_populares);
      _cargando = false;
      return resp;

  }
}