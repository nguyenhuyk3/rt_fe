import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/film/film.showtime.dart';
import 'package:rt_mobile/presentation/cubit/change_tab/change_tab.dart';
import 'package:rt_mobile/presentation/film_detail/film_detail_screen.dart';
import 'package:rt_mobile/presentation/home/bloc/film/bloc.dart';
import 'package:rt_mobile/presentation/splash/spash_view.dart';

class FilmCarousel extends StatelessWidget {
  const FilmCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmsBloc, FilmsState>(
      builder: (context, state) {
        if (state is FilmsLoading) {
          return Center(child: SplashPage());
        } else if (state is FilmsLoadSuccess) {
          return _FilmCarouselContainer(films: state.films);
        } else if (state is FilmsLoadFailed) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Đã có lỗi xảy ra',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class _FilmCarouselContainer extends StatelessWidget {
  final List<FilmShowtime> films;
  final PageController _pageController = PageController(
    viewportFraction: 0.7,
    initialPage: 0,
  );

  _FilmCarouselContainer({required this.films});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChangeTabCubit<int>>(
          create: (_) => ChangeTabCubit<int>(initialState: 0),
        ),
      ],
      child: Builder(
        builder: (context) {
          _pageController.addListener(() {
            final newPage = _pageController.page?.round() ?? 0;

            if (newPage != context.read<ChangeTabCubit<int>>().state) {
              context.read<ChangeTabCubit<int>>().changeTab(newPage);
            }
          });

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _Header(),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: films.length,
                  itemBuilder: (context, index) {
                    final film = films[index];

                    return GestureDetector(
                      onTap:
                          () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        FilmDetailScreen(filmId: film.filmId),
                              ),
                            ),
                          },
                      child: _CenteredFilmCard(
                        film: film,
                        index: index,
                        pageController: _pageController,
                      ),
                    );
                  },
                ),
              ),

              BlocBuilder<ChangeTabCubit<int>, int>(
                builder: (context, currentIndex) {
                  return _FilmIndicator(
                    length: films.length,
                    currentIndex: currentIndex,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: Text(
            'Đang công chiếu',
            style: TextStyle(
              color: Colors.white,
              fontSize: TITLE_H0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CenteredFilmCard extends StatelessWidget {
  final FilmShowtime film;
  final int index;
  final PageController pageController;

  const _CenteredFilmCard({
    required this.film,
    required this.index,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          double page =
              pageController.hasClients &&
                      pageController.position.haveDimensions
                  ? pageController.page!
                  : pageController.initialPage.toDouble();
          double diff = (page - index).abs();
          double scale = (1 - diff * 0.2).clamp(0.8, 1.0);
          double opacity = (1 - diff * 0.5).clamp(0.5, 1.0);
          double translateY = (1 - scale) * 50;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, translateY),
              child: Transform.scale(scale: scale, child: child),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                film.posterUrl,
                height: 480,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              film.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '${film.duration} • ${film.genres}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),

                const SizedBox(width: 4),

                Text(
                  '\${movie.rating}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),

                const SizedBox(width: 4),

                Text(
                  '(\${movie.votes})',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilmIndicator extends StatelessWidget {
  const _FilmIndicator({required this.length, required this.currentIndex});

  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.yellowAccent : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
