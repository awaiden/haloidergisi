import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { createFileRoute, Link, useRouter } from "@tanstack/react-router";
import { motion } from "motion/react";
import React from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import z from "zod";

import { GoogleAuthButton } from "@/components/auth";
import { Turnstile } from "@/components/turnstile";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { Container } from "@/components/ui/container";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Separator } from "@/components/ui/separator";
import apiClient from "@/lib/api-client";

const registerSchema = z.object({
  name: z.string().min(1, { message: "İsim gereklidir." }),
  email: z.string().email({ message: "Geçerli bir e-posta adresi girin." }),
  password: z.string().min(6, { message: "Şifre en az 6 karakter olmalıdır." }),
  acceptTerms: z.literal(true, { message: "Kullanım Şartları'nı kabul etmelisiniz." }),
});

type RegisterFormData = z.infer<typeof registerSchema>;

export const Route = createFileRoute("/_auth/register")({
  component: RouteComponent,
});

function RouteComponent() {
  const router = useRouter();

  const form = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      name: "",
      email: "",
      password: "",
      // @ts-ignore
      acceptTerms: false,
    },
  });

  const [token, setToken] = React.useState<string | null>(null);

  const onSubmit = async (data: RegisterFormData) => {
    if (!token) {
      toast.error("Lütfen CAPTCHA doğrulamasını tamamlayın.");
      return;
    }

    try {
      await apiClient.post("/auth/register", {
        "cf-turnstile-response": token,
        ...data,
      });
      toast.success("Kayıt başarılı! Lütfen giriş yapın.");
      await router.navigate({ to: "/login" });
    } catch (error) {
      console.error("Kayıt hatası:", error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <Container className='grid min-h-screen place-items-center py-20'>
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
                  icon='mdi:account-plus'
                  className='text-primary text-xl'
                />
              </div>
            </div>
            <CardTitle className='text-2xl'>Yeni Hesap Oluştur</CardTitle>
            <CardDescription className='mt-2'>
              Hadi başlayalım - yeni bir hesap oluşturun
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Form {...form}>
              <form
                onSubmit={form.handleSubmit(onSubmit as any)}
                className='space-y-4'
              >
                <FormField
                  control={form.control as any}
                  name='name'
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className='flex items-center gap-2'>
                        <Icon
                          icon='mdi:account'
                          className='text-lg'
                        />
                        Ad
                      </FormLabel>
                      <FormControl>
                        <Input
                          type='text'
                          {...field}
                        />
                      </FormControl>
                      <FormDescription>Lütfen tam adınızı girin.</FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control as any}
                  name='email'
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className='flex items-center gap-2'>
                        <Icon
                          icon='mdi:email'
                          className='text-lg'
                        />
                        E-posta
                      </FormLabel>
                      <FormControl>
                        <Input
                          type='email'
                          {...field}
                        />
                      </FormControl>
                      <FormDescription>Lütfen geçerli bir e-posta adresi girin.</FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control as any}
                  name='password'
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className='flex items-center gap-2'>
                        <Icon
                          icon='mdi:lock'
                          className='text-lg'
                        />
                        Şifre
                      </FormLabel>
                      <FormControl>
                        <Input
                          type='password'
                          {...field}
                        />
                      </FormControl>
                      <FormDescription>Şifreniz en az 6 karakter olmalıdır.</FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control as any}
                  name='acceptTerms'
                  render={({ field }) => (
                    <FormItem>
                      <div className='flex items-center gap-2'>
                        <FormControl>
                          <Checkbox
                            checked={field.value}
                            onCheckedChange={field.onChange}
                          />
                        </FormControl>
                        <FormLabel>
                          <Link
                            to='/terms'
                            className='link underline'
                          >
                            Kullanım Şartları
                          </Link>
                          'nı kabul ediyorum.
                        </FormLabel>
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
                    icon='mdi:account-plus'
                    className='mr-2 text-lg'
                  />
                  Kayıt Ol
                </Button>
                <div className='flex items-center justify-center gap-2 text-sm'>
                  <span className='text-muted-foreground'>Zaten bir hesabınız var mı?</span>
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
          <div className='flex items-center gap-6'>
            <Separator className='my-4 h-px self-center' />
            <span className='text-muted-foreground text-center text-sm'>VEYA</span>
            <Separator className='my-4 h-px self-center' />
          </div>
          <CardContent>
            <GoogleAuthButton className='w-full' />
          </CardContent>
        </Card>
      </motion.div>
    </Container>
  );
}
