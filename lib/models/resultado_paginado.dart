class ResultadoPaginado<T> {
  final List<T> items;
  final int totalPaginas;
  final bool tieneSiguiente;

  ResultadoPaginado({
    required this.items,
    required this.totalPaginas,
    required this.tieneSiguiente,
  });
}