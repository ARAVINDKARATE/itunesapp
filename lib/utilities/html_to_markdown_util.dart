class HtmlToMarkdownUtil {
  static String convert(String htmlContent) {
    return htmlContent
        .replaceAll(RegExp(r'<\/?i>'), '_') // Convert <i> to Markdown italics
        .replaceAll('<strong>', '**') // Convert <strong> to Markdown bold
        .replaceAll('</strong>', '**')
        .replaceAll('<em>', '*') // Convert <em> to Markdown italics
        .replaceAll('</em>', '*')
        .replaceAll('<br />', '\n\n') // Convert <br /> to Markdown line breaks
        .replaceAll('</p>', '\n\n') // Convert closing paragraph to line breaks
        .replaceAll('<p>', '') // Remove opening paragraph tags
        .replaceAll('<\/?u>', '') // Remove any underline tags
        .replaceAll('&#xa0;', ' ') // Handle non-breaking spaces
        .replaceAll('<[^>]+>', '') // Remove any other HTML tags that are not handled
        .replaceAllMapped(RegExp(r'[\n]{3,}'), (match) => '\n\n'); // Ensure no excessive line breaks
  }
}
