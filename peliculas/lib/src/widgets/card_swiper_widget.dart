import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_modelo.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;
  
  CardSwiper({   @required this.peliculas});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;  // nos da el tamaño de la pantalla y asi podemos determinar el ancho y alto de las cards

    return  Container(
                padding: EdgeInsets.only(top:10.0),              
                child: Swiper(
                            layout:  SwiperLayout.STACK,
                            itemWidth: _screenSize.width * 0.7, // ancho de la pántalla 70%
                            itemHeight: _screenSize.height * 0.5,
                            itemBuilder: (BuildContext context,int index){
                              peliculas[index].uniqueID = '${peliculas[index].id}-tarjeta';
                              return Hero(
                                            tag: peliculas[index].uniqueID,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: GestureDetector(

                                                onTap: () => Navigator.pushNamed(context, 'detalle', arguments:peliculas[index]),
                                                child: FadeInImage (
                                                        image: NetworkImage( peliculas[index].getPosterImg()),      //Image.network("http://via.placeholder.com/350x150",fit: BoxFit.cover,)
                                                        placeholder: AssetImage('assets/img/no-image.jpg'),
                                                        fit: BoxFit.cover
                                                      ) 
                                              )       
                                        ),
                              );
                            },
                            itemCount: peliculas.length,
                            //pagination: new SwiperPagination(), // aparecen tres puntitos 
                            //control: new SwiperControl(), // flechas para ir paginando 
                        ),
            );
  }
  /* moviedb  user. zabdielcead
    b517fc113b3a276f51c69fabbbec189d 
    https://developers.themoviedb.org/3/movies/get-now-playing  // endpoints y ejemplos

    img url https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg

  */
}