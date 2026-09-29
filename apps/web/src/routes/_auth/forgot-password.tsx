import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { createFileRoute, Link, useRouter } from "@tanstack/react-router";
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

const forgotPasswordFormSchema = z.object({
  email: z.string().email({ message: "Geçerli bir e-posta adresi girin." }),
});

type ForgotPasswordFormData = z.infer<typeof forgotPasswordFormSchema>;

export const Route = createFileRoute("/_auth/forgot-password")({
  component: RouteComponent,
});

function RouteComponent() {
  const router = useRouter();

  const form = useForm<ForgotPasswordFormData>({
    resolver: zodResolver(forgotPasswordFormSchema),
    defaultValues: {
      email: "",
    },
  });

  const [token, setToken] = React.useState<string | null>(null);

  const onSubmit = async (data: ForgotPasswordFormData) => {
    if (!token) {
      toast.error("Lütfen CAPTCHA doğrulamasını tamamlayın.");
      return;
    }

    try {
      await apiClient.post("/auth/forgot-password", {
        "cf-turnstile-response": token,
        ...data,
      });
      toast.success("Şifre sıfırlama talimatları e-posta adresinize gönderildi.");
      await router.navigate({ to: "/" });
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
            <CardTitle className='text-2xl'>Şifremi Unuttum</CardTitle>
            <CardDescription className='mt-2'>
              Endişelenmeyin! Şifrenizi sıfırlamak için e-posta adresinizi girin
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Form {...form}>
              <form
                onSubmit={form.handleSubmit(onSubmit)}
                className='space-y-4'
              >
                <FormField
                  control={form.control}
                  name='email'
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel className='flex items-center gap-2'>
                        <Icon
                          icon='mdi:email'
                          className='text-lg'
                        />
                        E-posta Adresiniz
                      </FormLabel>
                      <FormControl>
                        <Input
                          type='email'
                          {...field}
                        />
                      </FormControl>
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
                    icon='mdi:email-send'
                    className='mr-2 text-lg'
                  />
                  Sıfırlama Talimatlarını Gönder
                </Button>
                <div className='flex items-center justify-center gap-2 text-sm'>
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
