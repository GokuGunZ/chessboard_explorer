import 'package:flutter/material.dart';

/// Una scacchiera minimal solo per visualizzare una posizione.
/// Non gestisce logica di mosse, è solo rendering statico.
class MiniChessboard extends StatelessWidget {
  final String fen;
  final double size;
  final Color? highlightColor;

  const MiniChessboard({
    super.key,
    required this.fen,
    this.size = 60,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final pieces = _fenToBoard(fen);
    final squareSize = size / 8;

    return Container(
      width: size,
      height: size,
      decoration: highlightColor != null
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: highlightColor!,
                  blurRadius: 12,
                  spreadRadius: 4,
                ),
              ],
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(8, (rank) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(8, (file) {
              final isLightSquare = (rank + file).isEven;
              final piece = pieces[rank][file];

              return Container(
                width: squareSize,
                height: squareSize,
                color: isLightSquare ? Colors.brown[200] : Colors.brown[700],
                child: piece != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Center(
                          child: Text(
                            piece,
                            style: TextStyle(fontSize: squareSize * 0.8),
                          ),
                        ),
                      )
                    : null,
              );
            }),
          );
        }),
      ),
    );
  }

  /// Converte il FEN in una matrice 8x8 di simboli (stringhe tipo ♙, ♜, …).
  List<List<String?>> _fenToBoard(String fen) {
    final board = List.generate(8, (_) => List<String?>.filled(8, null));
    final rows = fen.split(' ')[0].split('/');

    const pieceMap = {
      'p': '♟',
      'r': '♜',
      'n': '♞',
      'b': '♝',
      'q': '♛',
      'k': '♚',
      'P': '♙',
      'R': '♖',
      'N': '♘',
      'B': '♗',
      'Q': '♕',
      'K': '♔',
    };

    for (int rank = 0; rank < 8; rank++) {
      int file = 0;
      for (final char in rows[rank].split('')) {
        if (RegExp(r'[1-8]').hasMatch(char)) {
          file += int.parse(char);
        } else {
          board[rank][file] = pieceMap[char];
          file++;
        }
      }
    }
    return board;
  }
}
