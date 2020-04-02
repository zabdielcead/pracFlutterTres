import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_modelo.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
      'Spiderman',
      'Aquaman',
      'Batman',
      'Iron Man',
      'Iron Man 2',
      'Superman',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan América',

  ];


  @override
  List<Widget> buildActions(BuildContext context) {
   // acciones del appBar iconicos de tache por ejemplo 
    return [
      IconButton(
        icon: Icon(Icons.clear) , 
        onPressed: () {
          //print('CLICK');
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar por ejemplo icono de regresar 
    return  IconButton(
        icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow, 
                  progress: transitionAnimation
              ) , 
        onPressed: () {
          close(context, null);
        }
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando la persona excribe
  /*
    final listaSugerida= (query.isEmpty ) ? peliculasRecientes : peliculas.where(
                                                                              (p) => p.toLowerCase().startsWith(query.toLowerCase())
                                                                              ).toList();
    return ListView.builder(
                itemCount: listaSugerida.length,
                itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.movie),
                      title: Text(listaSugerida[i]),
                      onTap: ( ){ //seleciione uno de la lista
                          seleccion = listaSugerida[i];
                          showResults(context); //showResults es propio del delegate llama buildResults
                      }
                    );
                }
          );

      */    

      if( query.isEmpty ){
        return Container();
      }

      return FutureBuilder(
                        future: peliculasProvider.buscarPelicula(query),                       
                        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
                              if(snapshot.hasData)    {
                                final peliculas = snapshot.data;
                                return ListView(
                                  children: peliculas.map( (pelicula)  { // va a crear un mapa 
                                      return ListTile(
                                          leading : FadeInImage(
                                                      placeholder: AssetImage('assets/img/no-image.jpg'), 
                                                      image: NetworkImage(pelicula.getPosterImg()),
                                                      width: 50.0,
                                                      fit: BoxFit.contain
                                                    ),
                                                    title: Text(pelicula.title),
                                                    subtitle: Text(pelicula.originalTitle),
                                                    onTap: (){
                                                      close(context, null);
                                                      pelicula.uniqueID = '';
                                                      Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                                                    },
                                      );
                                  }).toList()
                                );
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                        }
                       );


  }

}