import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import * as z from "zod";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import apiClient from "@/lib/api-client";
import { Article } from "@/types";
import { getCdnUrl } from "@/utils/cdn";

const statusFormSchema = z.object({
  status: z.enum(["PENDING", "REVIEWING", "APPROVED", "REJECTED", "REVISION_REQ"]),
  adminNote: z.string().optional(),
});

const contentFormSchema = z.object({
  title: z.string().min(3, "Başlık en az 3 karakter olmalıdır."),
  content: z.string().optional(),
  fileUrl: z.string().optional(),
});

type StatusFormValues = z.infer<typeof statusFormSchema>;
type ContentFormValues = z.infer<typeof contentFormSchema>;

export const Route = createFileRoute("/dashboard/submissions/$articleId")({
  component: SubmissionDetailPage,
});

function SubmissionDetailPage() {
  const { articleId } = Route.useParams();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [isEditing, setIsEditing] = useState(false);

  const { data: article } = useQuery({
    queryKey: ["submission", articleId],
    queryFn: async () => {
      const { data } = await apiClient.get<Article>(`/articles/${articleId}`);
      return data;
    },
  });

  const statusForm = useForm<StatusFormValues>({
    resolver: zodResolver(statusFormSchema),
    defaultValues: { status: "PENDING", adminNote: "" },
  });

  const contentForm = useForm<ContentFormValues>({
    resolver: zodResolver(contentFormSchema),
    defaultValues: { title: "", content: "" },
  });

  useEffect(() => {
    if (article) {
      statusForm.reset({
        status: article.status,
        adminNote: article.adminNote || "",
      });
      contentForm.reset({
        title: article.title,
        content: article.content || "",
        fileUrl: article.fileUrl || "",
      });
    }
  }, [article, statusForm, contentForm]);

  const statusMutation = useMutation({
    mutationFn: async (values: StatusFormValues) => {
      await apiClient.patch(`/articles/${articleId}/status`, values);
    },
    onSuccess: () => {
      toast.success("Yazı durumu güncellendi.");
      void queryClient.invalidateQueries({ queryKey: ["submission", articleId] });
      void queryClient.invalidateQueries({ queryKey: ["submissions"] });
    },
    onError: (error) => toast.error(apiClient.resolveApiError(error).message),
  });

  const contentMutation = useMutation({
    mutationFn: async (values: ContentFormValues) => {
      await apiClient.patch(`/articles/${articleId}`, values);
    },
    onSuccess: () => {
      toast.success("Yazı içeriği güncellendi.");
      setIsEditing(false);
      void queryClient.invalidateQueries({ queryKey: ["submission", articleId] });
      void queryClient.invalidateQueries({ queryKey: ["submissions"] });
    },
    onError: (error) => toast.error(apiClient.resolveApiError(error).message),
  });

  const deleteMutation = useMutation({
    mutationFn: async () => {
      await apiClient.delete(`/articles/${articleId}`);
    },
    onSuccess: () => {
      toast.success("Yazı silindi.");
      void navigate({ to: "/dashboard/submissions", search: {} as never });
      void queryClient.invalidateQueries({ queryKey: ["submissions"] });
    },
    onError: (error) => toast.error(apiClient.resolveApiError(error).message),
  });

  if (!article) return <div>Yükleniyor...</div>;

  return (
    <div className='space-y-6'>
      <div className='flex items-center justify-between'>
        <Button
          variant='ghost'
          onClick={() => window.history.back()}
        >
          <Icon
            icon='mdi:arrow-left'
            className='mr-2 h-4 w-4'
          />
          Geri Dön
        </Button>
        <div className='flex gap-2'>
          <Button
            variant='outline'
            onClick={() => setIsEditing(!isEditing)}
          >
            <Icon
              icon={isEditing ? "mdi:close" : "mdi:pencil"}
              className='mr-2 h-4 w-4'
            />
            {isEditing ? "İptal" : "İçeriği Düzenle"}
          </Button>

          <Button
            variant='destructive'
            onClick={() => {
              if (
                window.confirm(
                  "Bu yazıyı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
                )
              ) {
                deleteMutation.mutate();
              }
            }}
            disabled={deleteMutation.isPending}
          >
            <Icon
              icon='mdi:trash-can'
              className='mr-2 h-4 w-4'
            />
            Yazıyı Sil
          </Button>
        </div>
      </div>

      <div className='grid gap-8 lg:grid-cols-3'>
        <div className='space-y-6 lg:col-span-2'>
          <Card>
            <CardHeader>
              <CardTitle>Yazı İçeriği</CardTitle>
              <CardDescription>
                Yazar: {article.author?.profile?.name || article.author?.email} | İlan:{" "}
                {article.call?.title}
              </CardDescription>
            </CardHeader>
            <CardContent>
              {isEditing ? (
                <Form {...contentForm}>
                  <form
                    onSubmit={contentForm.handleSubmit((v) => contentMutation.mutate(v))}
                    className='space-y-4'
                  >
                    <FormField
                      control={contentForm.control}
                      name='title'
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Başlık</FormLabel>
                          <FormControl>
                            <Input {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={contentForm.control}
                      name='content'
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>İçerik</FormLabel>
                          <FormControl>
                            <Textarea
                              {...field}
                              className='min-h-[400px]'
                            />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <div className='flex justify-end gap-2'>
                      <Button
                        type='button'
                        variant='ghost'
                        onClick={() => setIsEditing(false)}
                      >
                        Vazgeç
                      </Button>
                      <Button
                        type='submit'
                        disabled={contentMutation.isPending}
                      >
                        Kaydet
                      </Button>
                    </div>
                  </form>
                </Form>
              ) : (
                <>
                  <h3 className='mb-4 text-xl font-bold'>{article.title}</h3>
                  {article.fileUrl && (
                    <div className='bg-primary/5 border-primary/20 mt-6 rounded-xl border p-5'>
                      <div className='flex items-center justify-between gap-4'>
                        <div className='flex items-center gap-3 overflow-hidden'>
                          <div className='bg-primary/10 text-primary flex h-10 w-10 shrink-0 items-center justify-center rounded-lg'>
                            <Icon
                              icon='solar:document-bold-duotone'
                              className='h-6 w-6'
                            />
                          </div>
                          <div className='min-w-0'>
                            <p className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                              Gönderilen Makale Dosyası
                            </p>
                            <p className='text-foreground truncate text-sm font-medium'>
                              {article.fileUrl}
                            </p>
                          </div>
                        </div>
                        <Button
                          asChild
                          variant='default'
                          size='sm'
                          className='shrink-0 shadow-sm'
                        >
                          <a
                            href={getCdnUrl(article.fileUrl)}
                            target='_blank'
                            rel='noreferrer'
                          >
                            <Icon
                              icon='solar:file-download-bold-duotone'
                              className='mr-1.5 h-4 w-4'
                            />
                            İndir / Görüntüle
                          </a>
                        </Button>
                      </div>
                    </div>
                  )}
                  {article.content && (
                    <div className='mt-6 border-t pt-4'>
                      <p className='text-muted-foreground mb-2 text-xs font-semibold tracking-wider uppercase'>
                        Ek Notlar / Açıklama
                      </p>
                      <div className='prose prose-sm text-muted-foreground max-w-none leading-relaxed whitespace-pre-wrap'>
                        {article.content}
                      </div>
                    </div>
                  )}
                </>
              )}
            </CardContent>
          </Card>
        </div>

        <div className='space-y-6'>
          <Card>
            <CardHeader>
              <CardTitle>Yazı Durumu</CardTitle>
            </CardHeader>
            <CardContent>
              <Form {...statusForm}>
                <form
                  onSubmit={statusForm.handleSubmit((v) => statusMutation.mutate(v))}
                  className='space-y-4'
                >
                  <FormField
                    control={statusForm.control}
                    name='status'
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Durum</FormLabel>
                        <Select
                          onValueChange={field.onChange}
                          defaultValue={field.value}
                          value={field.value}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder='Durum seçin' />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value='PENDING'>Beklemede</SelectItem>
                            <SelectItem value='REVIEWING'>İnceleniyor</SelectItem>
                            <SelectItem value='APPROVED'>Onaylandı</SelectItem>
                            <SelectItem value='REJECTED'>Reddedildi</SelectItem>
                            <SelectItem value='REVISION_REQ'>Revize Gerekli</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  <FormField
                    control={statusForm.control}
                    name='adminNote'
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Editör Notu (Yazara görünür)</FormLabel>
                        <FormControl>
                          <Textarea
                            {...field}
                            placeholder='Yazara iletilecek not...'
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  <Button
                    type='submit'
                    className='w-full'
                    disabled={statusMutation.isPending}
                  >
                    Durumu Güncelle
                  </Button>
                </form>
              </Form>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
