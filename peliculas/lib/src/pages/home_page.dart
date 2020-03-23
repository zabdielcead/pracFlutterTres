import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_modelo.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cines') ,
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
              IconButton(
                          icon: Icon(Icons.search), 
                          onPressed: () {

                          }
                        )
        ],
      ),
      //body: SafeArea( //safearea respeta la parte de arriba del celular y lo baja el banner donde esta la hora bateria wifi
        //      child:  Text('Hola Mundo!!!!'),
          //  )
      body: SingleChildScrollView(
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // espacio entre las tarjetas y el titulo del infinite scroll
                    children: <Widget>[
                      _swiperTarjetas(),
                      _footer(context)
                    ],
                  ),
        ),
      ),    
      
    );
  }

  Widget _swiperTarjetas() {
    
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {  // snapshot tiene la data del future
        if(snapshot.hasData){

          return  CardSwiper(
                      peliculas: snapshot.data
                  );
        }else{
          return Container(
                            height: 400.0,
                            child: Center(
                                child : CircularProgressIndicator()
                            ),
                          );
        }

      },
    );
    //peliculasProvider.getEnCines();

    // swipper      https://pub.dev/packages/flutter_swiper#-installing-tab-
    //return CardSwiper(
      //        peliculas: [1,2,3,4,5]
    //);
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
                  padding: EdgeInsets.only(left:20.0),
                  child: Text( 
                        'Populares', 
                        style: Theme.of(context).textTheme.subhead
                  ),
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,    
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
               //snapshot.data?.forEach(  (p) => print(p.title) ); // data? si existe data haz el for each es como null safety
             
                  if(snapshot.hasData) {
                      return MovieHorizontal(
                                              peliculas: snapshot.data,
                                              siguientePagina: peliculasProvider.getPopulares,
                                              );
                  }else {   
                    return  Center(
                                child: CircularProgressIndicator (                                  
                              ),
                    );
                  }         

            },
          ),    
        ],
      ),
    );
  }
}