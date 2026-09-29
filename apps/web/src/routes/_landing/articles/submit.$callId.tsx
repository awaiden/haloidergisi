import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import * as z from "zod";

import { FieldFileInput } from "@/components/file-input";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
  FormDescription,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useAuth } from "@/hooks/use-auth";
import apiClient from "@/lib/api-client";
import { SubmissionCall, Article } from "@/types";
import { getCdnUrl } from "@/utils/cdn";

const formSchema = z.object({
  title: z
    .string()
    .min(3, "Başlık en az 3 karakter olmalıdır.")
    .max(100, "Başlık 100 karakteri geçemez."),
  fileUrl: z.string().min(1, "Lütfen makalenizin/yazınızın dosyasını yükleyin."),
  content: z.string().optional(),
});

type FormValues = z.infer<typeof formSchema>;

export const Route = createFileRoute("/_landing/articles/submit/$callId")({
  component: SubmitArticlePage,
});

function SubmitArticlePage() {
  const { callId } = Route.useParams();
  const navigate = useNavigate();
  const { data: user, isLoading: isAuthLoading } = useAuth();

  const { data: call, isError: isCallError } = useQuery({
    queryKey: ["submission-call", callId],
    queryFn: async () => {
      const { data } = await apiClient.get<SubmissionCall>(`/submission-calls/${callId}`);
      return data;
    },
  });

  const { data: submissionCheck, isLoading: isCheckLoading } = useQuery({
    queryKey: ["check-submission", callId],
    queryFn: async () => {
      const { data } = await apiClient.get<{ hasSubmitted: boolean; articleId?: string }>(
        `/submission-calls/${callId}/check-submission`,
      );
      return data;
    },
    retry: false,
    enabled: !isAuthLoading && !!user,
  });

  const { data: existingArticle, isLoading: isArticleLoading } = useQuery({
    queryKey: ["article", submissionCheck?.articleId],
    queryFn: async () => {
      if (!submissionCheck?.articleId) return null;
      const { data } = await apiClient.get<Article>(`/articles/${submissionCheck.articleId}`);
      return data;
    },
    enabled: !!submissionCheck?.articleId,
  });

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: "",
      fileUrl: "",
      content: "",
    },
  });

  useEffect(() => {
    if (existingArticle) {
      form.reset({
        title: existingArticle.title,
        fileUrl: existingArticle.fileUrl || "",
        content: existingArticle.content || "",
      });
    }
  }, [existingArticle, form]);

  const canEdit =
    !existingArticle ||
    existingArticle.status === "PENDING" ||
    existingArticle.status === "REVISION_REQ";

  const mutation = useMutation({
    mutationFn: async (values: FormValues) => {
      if (!user) throw new Error("Lütfen önce giriş yapın.");
      if (!canEdit) throw new Error("Bu yazı şu anda düzenlenemez.");

      if (submissionCheck?.hasSubmitted && submissionCheck.articleId) {
        await apiClient.patch(`/articles/${submissionCheck.articleId}`, values);
      } else {
        await apiClient.post("/articles", { ...values, callId });
      }
    },
    onSuccess: () => {
      toast.success(
        submissionCheck?.hasSubmitted ? "Yazınız güncellendi!" : "Yazınız başarıyla gönderildi!",
      );
      void navigate({ to: "/articles/my" });
    },
    onError: (error) => {
      const resolved = apiClient.resolveApiError(error);
      toast.error(resolved.message);
    },
  });

  function onSubmit(values: FormValues) {
    mutation.mutate(values);
  }

  if (isAuthLoading) {
    return (
      <div className='flex min-h-[60vh] flex-col items-center justify-center'>
        <Icon
          icon='line-md:loading-twotone-loop'
          className='text-primary mb-4 h-12 w-12'
        />
        <p className='text-muted-foreground animate-pulse font-medium'>Kimlik doğrulanıyor...</p>
      </div>
    );
  }

  if (!user) {
    return (
      <div className='container mx-auto px-4 py-20 text-center'>
        <div className='mx-auto max-w-md space-y-6'>
          <div className='bg-primary/5 mx-auto w-fit rounded-full p-6'>
            <Icon
              icon='solar:lock-password-bold-duotone'
              className='text-primary h-20 w-20'
            />
          </div>
          <div className='space-y-2'>
            <h2 className='text-3xl font-bold tracking-tight'>Erişim Kısıtlı</h2>
            <p className='text-muted-foreground text-lg'>
              Yazı gönderimi yapabilmek için HALO topluluğunun bir parçası olmalısınız.
            </p>
          </div>
          <div className='flex flex-col justify-center gap-3 pt-4 sm:flex-row'>
            <Button
              asChild
              size='lg'
              className='px-8'
            >
              <Link to='/login'>Giriş Yap</Link>
            </Button>
            <Button
              variant='outline'
              size='lg'
              onClick={() => window.history.back()}
            >
              Geri Dön
            </Button>
          </div>
        </div>
      </div>
    );
  }

  if (isCallError) {
    return (
      <div className='container mx-auto px-4 py-20 text-center'>
        <Icon
          icon='solar:danger-bold-duotone'
          className='text-destructive mx-auto mb-6 h-20 w-20'
        />
        <h2 className='mb-2 text-3xl font-bold'>İlan Bulunamadı</h2>
        <p className='text-muted-foreground mb-8 text-lg'>
          Aradığınız ilan yayından kaldırılmış veya taşınmış olabilir.
        </p>
        <Button
          size='lg'
          onClick={() => navigate({ to: "/articles" })}
        >
          İlanlara Göz At
        </Button>
      </div>
    );
  }

  if (!call || isCheckLoading || (submissionCheck?.articleId && isArticleLoading)) {
    return (
      <div className='flex min-h-[60vh] flex-col items-center justify-center'>
        <Icon
          icon='line-md:loading-twotone-loop'
          className='text-primary mb-4 h-12 w-12'
        />
        <p className='text-muted-foreground animate-pulse'>İçerik hazırlanıyor...</p>
      </div>
    );
  }

  const titleLength = form.watch("title")?.length || 0;
  const fileUrlValue = form.watch("fileUrl");

  return (
    <div className='container mx-auto max-w-4xl px-4 py-12'>
      <div className='mb-8 space-y-4'>
        <Button
          variant='ghost'
          size='sm'
          onClick={() => window.history.back()}
          className='text-muted-foreground hover:text-foreground -ml-2'
        >
          <Icon
            icon='solar:arrow-left-linear'
            className='mr-2 h-4 w-4'
          />
          Geri Dön
        </Button>
        <div className='flex flex-col gap-4 md:flex-row md:items-end md:justify-between'>
          <div className='space-y-1'>
            <h1 className='text-4xl font-extrabold tracking-tight lg:text-5xl'>{call.title}</h1>
            <p className='text-muted-foreground text-xl'>Yazı Gönderim Formu</p>
          </div>
          <div className='bg-primary/10 text-primary flex w-fit items-center gap-2 rounded-full px-3 py-1 text-sm font-medium'>
            <Icon icon='solar:calendar-date-bold-duotone' />
            Son Tarih:{" "}
            {new Date(call.endDate).toLocaleDateString("tr-TR", {
              day: "numeric",
              month: "long",
              year: "numeric",
            })}
          </div>
        </div>
      </div>

      <div className='grid grid-cols-1 gap-8 lg:grid-cols-3'>
        <div className='space-y-8 lg:col-span-2'>
          {submissionCheck?.hasSubmitted && (
            <Alert
              className={`border-2 ${canEdit ? "border-amber-500/50 bg-amber-500/5" : "border-blue-500/50 bg-blue-500/5"}`}
            >
              <Icon
                icon={
                  canEdit ? "solar:info-circle-bold-duotone" : "solar:check-circle-bold-duotone"
                }
                className={`h-5 w-5 ${canEdit ? "text-amber-600" : "text-blue-600"}`}
              />
              <AlertTitle className={`font-bold ${canEdit ? "text-amber-800" : "text-blue-800"}`}>
                {canEdit ? "Mevcut Gönderiniz Üzerinde Çalışıyorsunuz" : "Yazınız İnceleme Altında"}
              </AlertTitle>
              <AlertDescription className={canEdit ? "text-amber-700/90" : "text-blue-700/90"}>
                {canEdit
                  ? "Bu ilan için daha önce bir yazı gönderdiniz. Aşağıdaki formu kullanarak yazınızı güncelleyebilirsiniz."
                  : "Bu ilana gönderdiğiniz yazı şu anda editörlerimiz tarafından inceleniyor. Bu aşamada değişiklik yapamazsınız."}
              </AlertDescription>
            </Alert>
          )}

          <Form {...form}>
            <form
              onSubmit={form.handleSubmit(onSubmit)}
              className='space-y-8'
            >
              <Card className='border-2 shadow-sm'>
                <CardHeader>
                  <CardTitle>Yazı Detayları ve Dosya Yükleme</CardTitle>
                  <CardDescription>
                    Yazınızın başlığını girin ve zengin metin formatında (DOCX, PDF, RTF, ODT, TXT,
                    MD, HTML) dosyanızı yükleyin.
                  </CardDescription>
                </CardHeader>
                <CardContent className='space-y-6'>
                  <FormField
                    control={form.control}
                    name='title'
                    render={({ field }) => (
                      <FormItem>
                        <div className='flex justify-between'>
                          <FormLabel className='text-base font-semibold'>Yazı Başlığı</FormLabel>
                          <span
                            className={`text-xs font-medium ${titleLength > 90 ? "text-destructive" : "text-muted-foreground"}`}
                          >
                            {titleLength}/100
                          </span>
                        </div>
                        <FormControl>
                          <Input
                            placeholder='Etkileyici bir başlık girin...'
                            className='h-12 text-lg font-medium'
                            {...field}
                            disabled={!canEdit}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormItem>
                    <FormLabel className='text-base font-semibold'>
                      Yazı Dosyası (Zengin Metin / Document Format)
                    </FormLabel>
                    <FormDescription className='text-xs'>
                      Desteklenen Formatlar:{" "}
                      <strong>DOCX, DOC, PDF, RTF, ODT, TXT, MD, HTML</strong>
                    </FormDescription>
                    <FormControl>
                      <FieldFileInput
                        name='fileUrl'
                        accept='.docx,.doc,.pdf,.rtf,.odt,.txt,.md,.html,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/msword,application/pdf,application/rtf,text/rtf,application/vnd.oasis.opendocument.text,text/plain,text/markdown,text/html'
                        disabled={!canEdit}
                      />
                    </FormControl>

                    {fileUrlValue && (
                      <div className='bg-primary/5 border-primary/20 mt-3 flex items-center justify-between rounded-lg border p-3 text-sm'>
                        <div className='flex items-center gap-2 overflow-hidden'>
                          <Icon
                            icon='solar:document-bold-duotone'
                            className='text-primary h-6 w-6 shrink-0'
                          />
                          <span className='text-foreground truncate font-medium'>
                            {fileUrlValue}
                          </span>
                        </div>
                        <Button
                          asChild
                          variant='outline'
                          size='sm'
                          className='shrink-0'
                        >
                          <a
                            href={getCdnUrl(fileUrlValue)}
                            target='_blank'
                            rel='noreferrer'
                          >
                            <Icon
                              icon='solar:file-download-bold-duotone'
                              className='mr-1.5 h-4 w-4'
                            />
                            Görüntüle / İndir
                          </a>
                        </Button>
                      </div>
                    )}
                    <FormMessage />
                  </FormItem>

                  <FormField
                    control={form.control}
                    name='content'
                    render={({ field }) => (
                      <FormItem>
                        <div className='flex justify-between'>
                          <FormLabel className='text-base font-semibold'>
                            Ek Notlar / Özet (İsteğe Bağlı)
                          </FormLabel>
                        </div>
                        <FormControl>
                          <Textarea
                            placeholder='Editörlerimize iletmek istediğiniz ek açıklama veya özet notu...'
                            className='min-h-[120px] resize-none p-4 text-base leading-relaxed'
                            {...field}
                            disabled={!canEdit}
                          />
                        </FormControl>
                        <FormDescription>
                          İsteğe bağlı olarak ek notlarınızı buraya yazabilirsiniz.
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </CardContent>
              </Card>

              {canEdit && (
                <div className='flex items-center justify-end gap-4 pb-10'>
                  <Button
                    variant='ghost'
                    type='button'
                    size='lg'
                    onClick={() => window.history.back()}
                  >
                    İptal
                  </Button>
                  <Button
                    type='submit'
                    size='lg'
                    className='shadow-primary/20 px-10 font-bold shadow-lg'
                    disabled={mutation.isPending}
                  >
                    {mutation.isPending ? (
                      <>
                        <Icon
                          icon='line-md:loading-twotone-loop'
                          className='mr-2'
                        />
                        Kaydediliyor...
                      </>
                    ) : submissionCheck?.hasSubmitted ? (
                      "Değişiklikleri Kaydet"
                    ) : (
                      "Yazıyı Gönder"
                    )}
                  </Button>
                </div>
              )}
            </form>
          </Form>
        </div>

        <div className='space-y-6'>
          <Card className='bg-muted/40 border-none'>
            <CardHeader>
              <CardTitle className='text-lg'>İlan Hakkında</CardTitle>
            </CardHeader>
            <CardContent className='text-muted-foreground text-sm leading-relaxed'>
              {call.description}
            </CardContent>
          </Card>

          <Card className='border-primary/20 bg-primary/5'>
            <CardHeader className='pb-3'>
              <CardTitle className='flex items-center gap-2 text-lg'>
                <Icon
                  icon='solar:shield-check-bold-duotone'
                  className='text-primary'
                />
                Önemli Kurallar
              </CardTitle>
            </CardHeader>
            <CardContent className='space-y-4 text-sm'>
              <div className='flex gap-3'>
                <div className='bg-primary/20 mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full'>
                  <span className='text-primary text-[10px] font-bold'>1</span>
                </div>
                <p>
                  Yazınızın özgün olması ve daha önce başka bir yerde yayınlanmamış olması gerekir.
                </p>
              </div>
              <div className='flex gap-3'>
                <div className='bg-primary/20 mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full'>
                  <span className='text-primary text-[10px] font-bold'>2</span>
                </div>
                <p>Editör onayından geçen yazılar yayına hazırlanır ve bu aşamada düzenlenemez.</p>
              </div>
              <div className='flex gap-3'>
                <div className='bg-primary/20 mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full'>
                  <span className='text-primary text-[10px] font-bold'>3</span>
                </div>
                <p>Her ilan için sadece bir adet yazı gönderme hakkınız bulunmaktadır.</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
