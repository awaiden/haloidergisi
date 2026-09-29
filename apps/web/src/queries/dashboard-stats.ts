export interface StatusCount {
  status: string;
  count: number;
}

export interface TimeSeriesPoint {
  date: string;
  count: number;
}

export interface DashboardStatsData {
  totalVisits: number;
  totalUsers: number;
  totalMessages: number;
  totalArticles: number;
  totalPosts: number;
  totalLikes: number;
  totalDislikes: number;
  articlesByStatus: StatusCount[];
  postsByStatus: StatusCount[];
  visitsOverTime: TimeSeriesPoint[];
  usersOverTime: TimeSeriesPoint[];
  messagesOverTime: TimeSeriesPoint[];
  articlesOverTime: TimeSeriesPoint[];
}
