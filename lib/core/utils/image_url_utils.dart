class ImageUrlUtils {
  static const String imageBaseUrl = 'http://192.168.1.27:5010';

  static String? normalize(String? url) {
    if (url == null || url.isEmpty) return null;
    
    // If it's already a full URL with right port, return it
    if (url.startsWith('http') && url.contains(':5010')) return url;

    // Handle port 5000 from API and map to 5010 for images
    if (url.contains(':5000')) {
      return url.replaceFirst(':5000', ':5010');
    }
    
    if (url.contains('localhost')) {
       return url.replaceFirst('localhost', '192.168.1.27').replaceFirst(':5000', ':5010');
    }

    // If it's a relative path
    if (url.startsWith('/')) {
      return '$imageBaseUrl$url';
    }
    
    if (!url.startsWith('http')) {
      return '$imageBaseUrl/$url';
    }

    return url;
  }
}
