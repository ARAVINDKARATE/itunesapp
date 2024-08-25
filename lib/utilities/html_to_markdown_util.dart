class HtmlToMarkdownUtil {
  static String convert(String htmlContent) {
    return htmlContent
        .replaceAll(RegExp(r'<\/?i>'), '_')
        .replaceAll('<strong>', '**')
        .replaceAll('</strong>', '**')
        .replaceAll('<em>', '*')
        .replaceAll('</em>', '*')
        .replaceAll('<br />', '\n\n')
        .replaceAll('</p>', '\n\n')
        .replaceAll('<p>', '')
        .replaceAll('<\/?u>', '')
        .replaceAll('&#xa0;', ' ')
        .replaceAll('<[^>]+>', '')
        .replaceAllMapped(RegExp(r'[\n]{3,}'), (match) => '\n\n');
  }
}
