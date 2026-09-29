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
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import apiClient from "@/lib/api-client";

const loginSchema = z.object({
  email: z.email({ error: "Geçerli bir e-posta adresi girin." }),
  password: z.string().min(6, { error: "Şifre en az 6 karakter olmalıdır." }),
});

type LoginFormData = z.infer<typeof loginSchema>;

export const Route = createFileRoute("/_auth/login")({
  component: RouteComponent,
});

function RouteComponent() {
  const router = useRouter();

  const form = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  });

  const [token, setToken] = React.useState<string | null>(null);

  const onSubmit = async (formData: LoginFormData) => {
    if (!token) {
      toast.error("Lütfen CAPTCHA doğrulamasını tamamlayın.");
      return;
    }

    try {
      const { data } = await apiClient.post("/auth/login", {
        "cf-turnstile-response": token,
        ...formData,
      });
      localStorage.setItem("token", data.token);
      toast.success("Giriş başarılı!");
      await router.navigate({ to: "/" });
    } catch (error) {
      console.error("Giriş hatası:", error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <div className='container grid min-h-screen place-items-center px-4'>
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
                  icon='mdi:login'
                  className='text-primary text-xl'
                />
              </div>
            </div>
            <CardTitle className='text-2xl'>Giriş Yapın</CardTitle>
            <CardDescription className='mt-2'>Hesabınıza erişmek için giriş yapın</CardDescription>
          </CardHeader>
          <CardContent>
            <form
              onSubmit={form.handleSubmit(onSubmit)}
              className='space-y-4'
            >
              <div className='space-y-2'>
                <Label
                  htmlFor='email'
                  className='flex items-center gap-2'
                >
                  <Icon
                    icon='mdi:email'
                    className='text-lg'
                  />
                  E-posta
                </Label>
                <Input
                  id='email'
                  type='email'
                  {...form.register("email")}
                />
                {form.formState.errors.email && (
                  <p className='text-destructive text-xs'>{form.formState.errors.email.message}</p>
                )}
              </div>

              <div className='space-y-2'>
                <div className='flex items-center justify-between'>
                  <Label
                    htmlFor='password'
                    className='flex items-center gap-2'
                  >
                    <Icon
                      icon='mdi:lock'
                      className='text-lg'
                    />
                    Şifre
                  </Label>

                  <Link
                    to='/forgot-password'
                    className='text-destructive text-xs hover:underline'
                  >
                    Şifremi Unuttum?
                  </Link>
                </div>
                <Input
                  id='password'
                  type='password'
                  {...form.register("password")}
                />
                {form.formState.errors.password && (
                  <p className='text-destructive text-xs'>
                    {form.formState.errors.password.message}
                  </p>
                )}
              </div>

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
                  icon='mdi:login'
                  className='mr-2 text-lg'
                />
                Giriş Yap
              </Button>
              <div className='flex items-center justify-center gap-2 text-sm'>
                <span className='text-muted-foreground'>Hesabınız yok mu?</span>
                <Link
                  className='text-primary font-medium hover:underline'
                  to='/register'
                >
                  Kayıt Olun
                </Link>
              </div>
            </form>
          </CardContent>
          <div className='flex items-center gap-6 px-6'>
            <Separator className='flex-1' />
            <span className='text-muted-foreground text-center text-sm'>VEYA</span>
            <Separator className='flex-1' />
          </div>
          <CardContent className='mt-4'>
            <GoogleAuthButton className='w-full' />
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
