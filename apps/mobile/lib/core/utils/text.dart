/// Plain-text preview of markdown: drops syntax, links' URLs and extra
/// whitespace, for one- or two-line excerpts in lists.
String plainTextExcerpt(String markdown) => markdown
    .replaceAllMapped(RegExp(r'!?\[([^\]]*)\]\([^)]*\)'), (m) => m[1]!)
    .replaceAll(RegExp(r'[#*_`>~|]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
