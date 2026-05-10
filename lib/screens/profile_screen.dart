import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/watched_provider.dart';
import '../services/auth_service.dart';
import '../widgets/movie_card.dart';
import 'auth_screen.dart';
import 'movie_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(
              child: _buildSection(
                context,
                title: 'Mis Favoritos',
                icon: Icons.bookmark_rounded,
                child: Consumer<FavoritesProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) return _buildLoadingRow();
                    if (provider.favorites.isEmpty) {
                      return _buildEmptyHint('Aún no tienes favoritos.\nMarca películas con el ícono de bookmark.');
                    }
                    return _buildMovieRow(context, provider.favorites
                        .map((m) => MovieCard(
                              movie: m,
                              compact: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MovieDetailScreen(movie: m)),
                              ),
                            ))
                        .toList());
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                context,
                title: 'Películas Vistas',
                icon: Icons.visibility_rounded,
                child: Consumer<WatchedProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) return _buildLoadingRow();
                    if (provider.watched.isEmpty) {
                      return _buildEmptyHint('Aún no has marcado películas como vistas.\nAbre el detalle de una película para hacerlo.');
                    }
                    return _buildMovieRow(context, provider.watched
                        .map((m) => MovieCard(
                              movie: m,
                              compact: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MovieDetailScreen(movie: m)),
                              ),
                            ))
                        .toList());
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        final isAnonymous = auth.isAnonymous;
        final email = auth.currentUser?.email;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFE50914).withValues(alpha: 0.15),
                    child: Icon(
                      isAnonymous ? Icons.person_outline : Icons.person_rounded,
                      color: const Color(0xFFE50914),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAnonymous ? 'Invitado' : email ?? 'Mi perfil',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAnonymous
                              ? 'Sin cuenta — datos solo en este dispositivo'
                              : 'Cuenta activa — datos sincronizados',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (!isAnonymous)
                    IconButton(
                      icon: const Icon(Icons.logout,
                          color: Colors.white54, size: 22),
                      tooltip: 'Cerrar sesión',
                      onPressed: () => _confirmSignOut(context, auth),
                    ),
                ],
              ),
              if (isAnonymous) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFE50914).withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sync_rounded,
                          color: Color(0xFFE50914), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Crea una cuenta para sincronizar tus datos en todos tus dispositivos.',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13, height: 1.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _openAuth(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          backgroundColor:
                              const Color(0xFFE50914).withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'Crear\ncuenta',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFE50914),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFE50914), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 20),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMovieRow(BuildContext context, List<Widget> cards) {
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: c,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLoadingRow() {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          width: 120,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyHint(String text) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white38, fontSize: 13, height: 1.5),
      ),
    );
  }

  void _openAuth(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AuthScreen(),
    );
  }

  void _confirmSignOut(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text('Cerrar sesión',
            style: GoogleFonts.montserrat(color: Colors.white)),
        content: const Text('¿Deseas cerrar tu sesión?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
            },
            child: const Text('Cerrar sesión',
                style: TextStyle(color: Color(0xFFE50914))),
          ),
        ],
      ),
    );
  }
}
