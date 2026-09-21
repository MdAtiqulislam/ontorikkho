class Pagination {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final dynamic nextPageUrl;
  final dynamic prevPageUrl;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
  };

  /// 🔥 copyWith added
  Pagination copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    dynamic nextPageUrl,
    dynamic prevPageUrl,
  }) {
    return Pagination(
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
    );
  }
}