import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { createFileRoute, Link, useRouter, useSearch } from "@tanstack/react-router";
import { motion } from "motion/react";
import React from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import z from "zod";

import { Turnstile } from "@/components/turnstile";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Container } from "@/components/ui/container";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import apiClient from "@/lib/api-client";

const searchSchema = z.object({
  token: z.string().min(1, "Token is required"),
});

type Search = z.infer<typeof searchSchema>;

const passwordResetSchema = z.object({
  newPassword: z.string().min(6, { message: "Şifre en az 6 karakter olmalıdır." }),
  newPasswordConfirm: z.string().min(6, { message: "Şifre onayı gereklidir." }),
});

type PasswordResetFormData = z.infer<typeof passwordResetSchema>;

export const Route = createFileRoute("/_auth/reset-password")({
  component: RouteComponent,
  validateSearch: (search): Search => searchSchema.parse(search),
  loaderDeps: ({ search: { token } }) => ({ token }),
});

function RouteComponent() {
  const router = useRouter();
  const search = useSearch({ from: Route.id });

  const [isPswrdVisible, setIsPswdVisible] = React.useState(false);
  const [token, setToken] = React.useState<string | null>(null);

  const form = useForm<PasswordResetFormData>({
    resolver: zodResolver(passwordResetSchema),
    defaultValues: {
      newPassword: "",
      newPasswordConfirm: "",
    },
  });

  const onSubmit = async (data: PasswordResetFormData) => {
    if (!token) {
      toast.error("Lütfen CAPTCHA doğrulamasını tamamlayın.");
      return;
    }

    if (data.newPassword !== data.newPasswordConfirm) {
      toast.error("Şifreler eşleşmiyor.");
      return;
    }

    try {
      await apiClient.post("/auth/reset-password", {
        "cf-turnstile-response": token,
        token: search.token,
        ...data,
      });
      toast.success("Şifreniz başarıyla sıfırlandı.", {
        description: "Artık yeni şifrenizle giriş yapabilirsiniz.",
      });
      await router.navigate({ to: "/login" });
    } catch (error) {
      console.error("Giriş hatası:", error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <Container className='grid min-h-screen place-items-center px-4'>
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.4, ease: "easeOut" }}
        className='w-full max-w-md'
      >
        <Card className='mx-auto'>
          <CardHeader className='text-center'>
            <div className='mb-4 flex justify-center'>
              <div className='from-primary/20 to-primary/10 flex h-12 w-12 items-center justify-center rounded-full bg-linear-to-br'>
                <Icon
                  icon='mdi:lock-reset'
                  className='text-primary text-xl'
                />
              </div>
            </div>
            <CardTitle className='text-2xl'>Şifrenizi Sıfırlayın</CardTitle>
            <CardDescription className='mt-2'>Yeni bir güvenli şifre belirleyin</CardDescription>
          </CardHeader>
          <CardContent>
            <Form {...form}>
              <form
                onSubmit={form.handleSubmit(onSubmit)}
                className='space-y-4'
              >
                <FormField
                  control={form.control}
                  name='newPassword'
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className='flex items-center gap-2'>
                        <Icon
                          icon='mdi:lock'
                          className='text-lg'
                        />
                        Yeni Şifre
                      </FormLabel>
                      <div className='relative'>
                        <FormControl>
                          <Input
                            type={isPswrdVisible ? "text" : "password"}
                            {...field}
                          />
                        </FormControl>
                        <button
                          type='button'
                          onClick={() => setIsPswdVisible(!isPswrdVisible)}
                          className='text-muted-foreground hover:text-foreground absolute inset-y-0 right-0 flex items-center px-3'
                        >
                          <Icon icon={isPswrdVisible ? "mdi:eye-off" : "mdi:eye"} />
                        </button>
                      </div>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name='newPasswordConfirm'
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className='flex items-center gap-2'>
                        <Icon
                          icon='mdi:lock-check'
                          className='text-lg'
                        />
                        Şifre (Tekrar)
                      </FormLabel>
                      <div className='relative'>
                        <FormControl>
                          <Input
                            type={isPswrdVisible ? "text" : "password"}
                            {...field}
                          />
                        </FormControl>
                        <button
                          type='button'
                          onClick={() => setIsPswdVisible(!isPswrdVisible)}
                          className='text-muted-foreground hover:text-foreground absolute inset-y-0 right-0 flex items-center px-3'
                        >
                          <Icon icon={isPswrdVisible ? "mdi:eye-off" : "mdi:eye"} />
                        </button>
                      </div>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <div className='flex justify-center'>
                  <Turnstile
                    onVerify={(token) => setToken(token)}
                    onExpire={() => setToken(null)}
                  />
                </div>
                <Button
                  type='submit'
                  className='w-full'
                  disabled={form.formState.isSubmitting}
                  size='lg'
                >
                  <Icon
                    icon='mdi:check-circle'
                    className='mr-2 text-lg'
                  />
                  Şifrenizi Sıfırlayın
                </Button>

                <div className='flex items-center justify-center gap-2 text-sm'>
                  <Icon
                    icon='mdi:information'
                    className='text-muted-foreground'
                  />
                  <span className='text-muted-foreground'>Hatırladınız mı?</span>
                  <Link
                    className='text-primary font-medium hover:underline'
                    to='/login'
                  >
                    Giriş Yapın
                  </Link>
                </div>
              </form>
            </Form>
          </CardContent>
        </Card>
      </motion.div>
    </Container>
  );
}
