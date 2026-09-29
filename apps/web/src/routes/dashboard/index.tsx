import { Icon } from "@iconify/react";
import { useQuery } from "@tanstack/react-query";
import { createFileRoute } from "@tanstack/react-router";
import { subDays } from "date-fns";
import { useState } from "react";
import { DateRange } from "react-day-picker";
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  Line,
  LineChart,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

import { ChartCard, Surface } from "@/components/chart-card";
import { DatePickerWithRange } from "@/components/date-range-picker";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import apiClient from "@/lib/api-client";
import { DashboardStatsData, StatusCount } from "@/queries/dashboard-stats";
import { formatNumber } from "@/utils/chart-helpers";

export const Route = createFileRoute("/dashboard/")({
  component: RouteComponent,
});

const COLORS = {
  primary: "#3b82f6",
  secondary: "#8b5cf6",
  success: "#10b981",
  warning: "#f59e0b",
  danger: "#ef4444",
  orange: "#f97316",
};

const ARTICLE_STATUS_COLORS: Record<string, string> = {
  PENDING: COLORS.warning,
  REVIEWING: COLORS.primary,
  APPROVED: COLORS.success,
  REJECTED: COLORS.danger,
  REVISION_REQ: COLORS.secondary,
};

const POST_STATUS_COLORS: Record<string, string> = {
  DRAFT: COLORS.warning,
  PUBLISHED: COLORS.success,
  ARCHIVED: "#6b7280",
};

const TOOLTIP_STYLE = {
  borderRadius: "8px",
  border: "none",
  boxShadow: "0 4px 6px -1px rgb(0 0 0 / 0.1)",
};

function StatCard({
  label,
  value,
  icon,
  colorClass,
  sub,
}: {
  label: string;
  value: string | number;
  icon: string;
  colorClass: string;
  sub?: string;
}) {
  return (
    <Surface className='p-6'>
      <div className='flex items-center justify-between'>
        <div>
          <p className='text-muted-foreground text-sm font-medium'>{label}</p>
          <h3 className='mt-2 text-3xl font-bold'>{value}</h3>
          {sub && <p className='text-muted-foreground mt-1 text-xs'>{sub}</p>}
        </div>
        <div className={`flex h-12 w-12 items-center justify-center rounded-full ${colorClass}`}>
          <Icon
            icon={icon}
            className='h-6 w-6'
          />
        </div>
      </div>
    </Surface>
  );
}

function StatusDonut({
  data,
  colorMap,
}: {
  data: StatusCount[];
  colorMap: Record<string, string>;
}) {
  return (
    <ResponsiveContainer
      width='100%'
      height={300}
    >
      <PieChart>
        <Pie
          data={data}
          cx='50%'
          cy='50%'
          innerRadius={60}
          outerRadius={100}
          paddingAngle={4}
          dataKey='count'
          nameKey='status'
          label={({ status, percent }: { status?: string; percent?: number }) =>
            `${status ?? ""} (${((percent || 0) * 100).toFixed(0)}%)`
          }
          labelLine={false}
        >
          {data.map((entry) => (
            <Cell
              key={entry.status}
              fill={colorMap[entry.status] ?? COLORS.primary}
            />
          ))}
        </Pie>
        <Tooltip
          contentStyle={TOOLTIP_STYLE}
          formatter={(value, name) => [value, name]}
        />
        <Legend
          iconType='circle'
          formatter={(value) => value}
        />
      </PieChart>
    </ResponsiveContainer>
  );
}

function RouteComponent() {
  const [date, setDate] = useState<DateRange | undefined>({
    from: subDays(new Date(), 30),
    to: new Date(),
  });

  const from = date?.from?.toISOString();
  const to = date?.to?.toISOString();

  const { data, isLoading } = useQuery({
    queryKey: ["dashboard-stats", { from, to }],
    queryFn: async () => {
      const { data } = await apiClient.get<DashboardStatsData>("/stats/dashboard", {
        params: { from, to },
      });
      return data;
    },
  });

  const stats = data;

  return (
    <div className='space-y-6'>
      {/* Header */}
      <div className='flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between'>
        <div>
          <h1 className='text-3xl font-bold tracking-tight'>Dashboard</h1>
          <p className='text-muted-foreground'>
            Uygulamanızın genel istatistikleri ve performans verileri.
          </p>
        </div>
        <div className='flex items-center space-x-2'>
          <DatePickerWithRange
            date={date}
            setDate={setDate}
          />
        </div>
      </div>

      {isLoading && (
        <div className='text-muted-foreground py-12 text-center text-sm'>Yükleniyor…</div>
      )}

      {stats && (
        <>
          {/* Stat Cards */}
          <div className='grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6'>
            <StatCard
              label='Seçili Dönem Ziyaretleri'
              value={formatNumber(stats.totalVisits)}
              icon='mdi:eye'
              colorClass='bg-primary/10 text-primary'
            />
            <StatCard
              label='Yeni Kullanıcılar'
              value={formatNumber(stats.totalUsers)}
              icon='mdi:account-group'
              colorClass='bg-secondary/10 text-secondary'
            />
            <StatCard
              label='Gelen Mesajlar'
              value={formatNumber(stats.totalMessages)}
              icon='mdi:message'
              colorClass='bg-emerald-500/10 text-emerald-600'
            />
            <StatCard
              label='Yazı Başvuruları'
              value={formatNumber(stats.totalArticles)}
              icon='mdi:file-document-edit-outline'
              colorClass='bg-orange-500/10 text-orange-500'
            />
            <StatCard
              label='Toplam Gönderi'
              value={formatNumber(stats.totalPosts)}
              icon='mdi:post-outline'
              colorClass='bg-yellow-500/10 text-yellow-600'
            />
            <StatCard
              label='Beğeni / Beğenmeme'
              value={`${formatNumber(stats.totalLikes)} / ${formatNumber(stats.totalDislikes)}`}
              icon='mdi:thumb-up-outline'
              colorClass='bg-rose-500/10 text-rose-500'
              sub={`Toplam: ${formatNumber(stats.totalLikes + stats.totalDislikes)}`}
            />
          </div>

          {/* Time-Series Charts Row 1 */}
          <div className='grid grid-cols-1 gap-6 xl:grid-cols-2'>
            <ChartCard
              title='Sayfa Ziyaretleri'
              description='Seçili dönemdeki günlük ziyaret eğilimi'
            >
              <ResponsiveContainer
                width='100%'
                height={300}
              >
                <LineChart data={stats.visitsOverTime}>
                  <CartesianGrid
                    strokeDasharray='3 3'
                    vertical={false}
                    opacity={0.3}
                  />
                  <XAxis
                    dataKey='date'
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <YAxis
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <Tooltip contentStyle={TOOLTIP_STYLE} />
                  <Legend iconType='circle' />
                  <Line
                    type='monotone'
                    dataKey='count'
                    stroke={COLORS.primary}
                    strokeWidth={3}
                    name='Ziyaret'
                    dot={false}
                    activeDot={{ r: 6, fill: COLORS.primary }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </ChartCard>

            <ChartCard
              title='Kullanıcı Kayıtları'
              description='Seçili dönemdeki yeni kayıt olan kullanıcılar'
            >
              <ResponsiveContainer
                width='100%'
                height={300}
              >
                <AreaChart data={stats.usersOverTime}>
                  <defs>
                    <linearGradient
                      id='colorUsers'
                      x1='0'
                      y1='0'
                      x2='0'
                      y2='1'
                    >
                      <stop
                        offset='5%'
                        stopColor={COLORS.secondary}
                        stopOpacity={0.4}
                      />
                      <stop
                        offset='95%'
                        stopColor={COLORS.secondary}
                        stopOpacity={0}
                      />
                    </linearGradient>
                  </defs>
                  <CartesianGrid
                    strokeDasharray='3 3'
                    vertical={false}
                    opacity={0.3}
                  />
                  <XAxis
                    dataKey='date'
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <YAxis
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <Tooltip contentStyle={TOOLTIP_STYLE} />
                  <Legend iconType='circle' />
                  <Area
                    type='monotone'
                    dataKey='count'
                    stroke={COLORS.secondary}
                    strokeWidth={3}
                    fillOpacity={1}
                    fill='url(#colorUsers)'
                    name='Kayıt'
                  />
                </AreaChart>
              </ResponsiveContainer>
            </ChartCard>
          </div>

          {/* Time-Series Charts Row 2 */}
          <div className='grid grid-cols-1 gap-6 xl:grid-cols-2'>
            <ChartCard
              title='Yazı Başvuruları Trendi'
              description='Seçili dönemdeki günlük başvuru sayısı'
            >
              <ResponsiveContainer
                width='100%'
                height={300}
              >
                <AreaChart data={stats.articlesOverTime}>
                  <defs>
                    <linearGradient
                      id='colorArticles'
                      x1='0'
                      y1='0'
                      x2='0'
                      y2='1'
                    >
                      <stop
                        offset='5%'
                        stopColor={COLORS.orange}
                        stopOpacity={0.4}
                      />
                      <stop
                        offset='95%'
                        stopColor={COLORS.orange}
                        stopOpacity={0}
                      />
                    </linearGradient>
                  </defs>
                  <CartesianGrid
                    strokeDasharray='3 3'
                    vertical={false}
                    opacity={0.3}
                  />
                  <XAxis
                    dataKey='date'
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <YAxis
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <Tooltip contentStyle={TOOLTIP_STYLE} />
                  <Legend iconType='circle' />
                  <Area
                    type='monotone'
                    dataKey='count'
                    stroke={COLORS.orange}
                    strokeWidth={3}
                    fillOpacity={1}
                    fill='url(#colorArticles)'
                    name='Başvuru'
                  />
                </AreaChart>
              </ResponsiveContainer>
            </ChartCard>

            <ChartCard
              title='Gelen Mesaj Aktivitesi'
              description='Seçili dönemdeki günlük mesaj hacmi'
            >
              <ResponsiveContainer
                width='100%'
                height={300}
              >
                <BarChart data={stats.messagesOverTime}>
                  <CartesianGrid
                    strokeDasharray='3 3'
                    vertical={false}
                    opacity={0.3}
                  />
                  <XAxis
                    dataKey='date'
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <YAxis
                    tick={{ fontSize: 12 }}
                    tickLine={false}
                    axisLine={false}
                  />
                  <Tooltip
                    contentStyle={TOOLTIP_STYLE}
                    cursor={{ fill: "rgba(0,0,0,0.05)" }}
                  />
                  <Legend iconType='circle' />
                  <Bar
                    dataKey='count'
                    fill={COLORS.success}
                    name='Mesaj'
                    radius={[4, 4, 0, 0]}
                    barSize={30}
                  />
                </BarChart>
              </ResponsiveContainer>
            </ChartCard>
          </div>

          {/* Status Donut Charts */}
          <div className='grid grid-cols-1 gap-6 xl:grid-cols-2'>
            <ChartCard
              title='Başvuru Durumu Dağılımı'
              description='Yazı başvurularının güncel durum dağılımı'
            >
              <StatusDonut
                data={stats.articlesByStatus}
                colorMap={ARTICLE_STATUS_COLORS}
              />
            </ChartCard>

            <ChartCard
              title='Gönderi Durumu Dağılımı'
              description='Tüm gönderilerin durum dağılımı'
            >
              <StatusDonut
                data={stats.postsByStatus}
                colorMap={POST_STATUS_COLORS}
              />
            </ChartCard>
          </div>

          {/* Detailed Table */}
          <ChartCard
            title='Detaylı Sayfa Ziyaretleri'
            description='Seçili döneme ait sayfa başına ziyaret istatistikleri'
          >
            <div className='max-h-[300px] overflow-auto'>
              <Table>
                <TableHeader className='bg-background/95 sticky top-0 backdrop-blur'>
                  <TableRow>
                    <TableHead>Sayfa</TableHead>
                    <TableHead className='text-right'>Ziyaret Sayısı</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {[...stats.visitsOverTime]
                    .sort((a, b) => b.count - a.count)
                    .map((visit, i) => (
                      <TableRow key={i}>
                        <TableCell className='text-sm font-medium'>{visit.date}</TableCell>
                        <TableCell className='text-right'>{visit.count}</TableCell>
                      </TableRow>
                    ))}
                  {stats.visitsOverTime.length === 0 && (
                    <TableRow>
                      <TableCell
                        colSpan={2}
                        className='text-muted-foreground h-24 text-center'
                      >
                        Bu tarih aralığında ziyaret verisi bulunamadı.
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </div>
          </ChartCard>
        </>
      )}
    </div>
  );
}
