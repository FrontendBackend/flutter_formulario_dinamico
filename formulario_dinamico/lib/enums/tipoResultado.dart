enum TipoResultado {
  info,
  error,
  warning,
  success,
  none;

  static TipoResultado fromString(String value) {
    switch (value.toUpperCase()) {
      case 'INFO':
        return TipoResultado.info;
      case 'ERROR':
        return TipoResultado.error;
      case 'WARNING':
        return TipoResultado.warning;
      case 'SUCCESS':
        return TipoResultado.success;
      case 'NONE':
        return TipoResultado.none;
      default:
        throw Exception('TipoResultado desconocido: $value');
    }
  }

  String get value {
    return toString().split('.').last.toUpperCase();
  }
}
