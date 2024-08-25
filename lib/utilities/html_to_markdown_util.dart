class HtmlToMarkdownUtil {
  // Converts HTML content to Markdown format
  static String convert(String htmlContent) {
    // Replace italic and emphasis tags with Markdown equivalents
    htmlContent = htmlContent
        .replaceAll(RegExp(r'<\/?i>'), '_')
        .replaceAll('<em>', '*')
        .replaceAll('</em>', '*')
        .replaceAll('<strong>', '**')
        .replaceAll('</strong>', '**')
        .replaceAll('<u>', '')
        .replaceAll('</u>', '');

    // Handle line breaks and paragraphs
    htmlContent = htmlContent
        .replaceAll('<br />', '\n\n')
        .replaceAll('</p>', '\n\n')
        .replaceAll('<p>', '') // Paragraphs can be replaced by new lines
        .replaceAll('&#xa0;', ' '); // Replace non-breaking spaces

    // Remove remaining HTML tags
    htmlContent = htmlContent.replaceAll(RegExp(r'<[^>]+>'), '');

    // Replace multiple newlines with a maximum of two
    htmlContent = htmlContent.replaceAllMapped(RegExp(r'[\n]{3,}'), (match) => '\n\n');

    return htmlContent.trim(); // Trim leading and trailing whitespaces
  }
}
