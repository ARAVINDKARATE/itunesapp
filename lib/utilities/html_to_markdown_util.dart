class HtmlToMarkdownUtil {
  static String convert(String htmlContent) {
    return htmlContent
        .replaceAll('<br />', '\n\n')
        .replaceAll('&#xa0;', ' ')
        .replaceAll('<strong>', '**')
        .replaceAll('</strong>', '**')
        .replaceAll('<em>', '*')
        .replaceAll('</em>', '*')
        .replaceAll('<p>', '')
        .replaceAll('</p>', '\n\n');
  }
}
