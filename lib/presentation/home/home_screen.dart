import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/repositories/film.dart';
import 'package:rt_mobile/presentation/home/bloc/film/bloc.dart';
import 'package:rt_mobile/presentation/home/view/film_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filmRepository = RepositoryProvider.of<FilmRepository>(context);

    return BlocProvider(
      create:
          (_) => FilmsBloc(filmRepository: filmRepository)..add(FilmsFetched()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),

              const SizedBox(width: MAX_HEIGTH_SIZED_BOX),

              const Text(
                'Xin chào!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
        body: SafeArea(
          /* 
            ListView is a widget in Flutter used to display a scrollable list of child widgets vertically or horizontally.
            Main features of ListView:
              - Can display a long list of elements without having to create all the widgets at once (lazy loading support).
              - Supports scrolling when the content exceeds the screen size.
              - Can be used to create simple or complex lists, depending on how you build the items.
          */
          child: ListView(
            /* 
              shrinkWrap: true in ListView is an attribute that helps to allow ListView to shrink itself according 
                to the size of the content inside instead of taking up all the available space.
            */
            shrinkWrap: true,
            children: [FilmCarousel()],
          ),
        ),
      ),
    );
  }
}
