import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_modelo.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({ @required this.peliculas , @required this.siguientePagina});

  final _pageController =  new PageController(  
                                          initialPage: 1,
                                          viewportFraction: 0.3
            );   // es para que mande que ya llego al final del scroll y ejecute el servicio

  

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
            if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){ //para que cuando llegue casi al final vaya cargando la otras fotos
                  print('cargar siguientes peliculas');
                  siguientePagina();

            }
    });


    return Container(
        height: _screenSize.height * 0.35,
        child: PageView.builder( // deslizar como widget paginas con el dedo lista escrolleable se va dibujando conforme los va utilizando
          pageSnapping: false,
          controller:_pageController,
          itemCount: peliculas.length,
          itemBuilder:(context, i) {
           
            return _tarjeta(context, peliculas[i]);
          },
         // children: _tarjetas(context),
        ),
    );
  }


  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    return Container(
            margin: EdgeInsets.only(right : 15.0),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FadeInImage(
                      image: NetworkImage(pelicula.getPosterImg()),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      fit: BoxFit.cover,
                      height: 160.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  pelicula.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
        );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
        return Container(
            margin: EdgeInsets.only(right : 15.0),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FadeInImage(
                      image: NetworkImage(pelicula.getPosterImg()),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      fit: BoxFit.cover,
                      height: 160.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  pelicula.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
        );
    }).toList();
  }
}