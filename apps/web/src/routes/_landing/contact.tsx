import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

import { Turnstile } from "@/components/turnstile";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { socialLinks } from "@/constants";
import apiClient from "@/lib/api-client";
import { messageSchema, MessageSchema } from "@/schemas/message";

export const Route = createFileRoute("/_landing/contact")({
  component: RouteComponent,
});

function RouteComponent() {
  const [token, setToken] = useState<string | null>(null);

  const form = useForm<MessageSchema>({
    resolver: zodResolver(messageSchema),
    defaultValues: {
      name: "",
      email: "",
      content: "",
      subject: "",
    },
  });

  const onSubmit = async (data: MessageSchema) => {
    if (!token) {
      toast.error("Lütfen CAPTCHA doğrulamasını tamamlayın.");
      return;
    }

    try {
      await apiClient.post("/messages", {
        ...data,
        "cf-turnstile-response": token,
      });
      toast.success("Mesajınız başarıyla gönderildi!");
      form.reset();
      setToken(null);
    } catch (error) {
      console.error("İletişim formu gönderim hatası:", error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <div className='container py-20'>
      <div className='max-w-md space-y-2'>
        <h1 className='text-4xl font-bold'>İletişim</h1>
        <p className='text-muted-foreground'>
          Bir sorunuz ya da öneriniz mi var? Bizimle iletişime geçin! Aşağıdaki iletişim bilgilerini
          kullanarak çekinmeden bize ulaşın.
        </p>
      </div>
      <br />
      <div className='grid grid-cols-12 gap-8'>
        <div className='col-span-12 md:col-span-8'>
          <Card className='max-w-none'>
            <CardHeader>
              <CardTitle>İletişim</CardTitle>
              <CardDescription>
                Bizimle iletişime geçmek için aşağıdaki bilgileri kullanabilirsiniz.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Form {...form}>
                <form
                  onSubmit={form.handleSubmit(onSubmit)}
                  className='grid grid-cols-2 gap-4'
                >
                  <FormField
                    control={form.control}
                    name='name'
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>İsim</FormLabel>
                        <FormControl>
                          <Input {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name='email'
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Email</FormLabel>
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

                  <FormField
                    control={form.control}
                    name='subject'
                    render={({ field }) => (
                      <FormItem className='col-span-2'>
                        <FormLabel>Konu</FormLabel>
                        <FormControl>
                          <Input {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name='content'
                    render={({ field }) => (
                      <FormItem className='col-span-2'>
                        <FormLabel>Mesaj</FormLabel>
                        <FormControl>
                          <Textarea
                            rows={5}
                            {...field}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <Turnstile
                    onVerify={(token) => setToken(token)}
                    onExpire={() => setToken(null)}
                    className='col-span-2'
                  />

                  <div className='col-span-2'>
                    <Button
                      className='w-full'
                      type='submit'
                    >
                      Gönder
                    </Button>
                  </div>
                </form>
              </Form>
            </CardContent>
          </Card>
        </div>
        <div className='col-span-12 md:col-span-4'>
          <Card className='max-w-none'>
            <CardHeader>
              <CardTitle>Sosyal Medya</CardTitle>
              <CardDescription>
                Bizi sosyal medyada takip edin ve en son güncellemelerden haberdar olun.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ul className='space-y-4'>
                {Object.values(socialLinks).map((link) => (
                  <li key={link.label}>
                    <a
                      className='link'
                      href={link.url}
                      target='_blank'
                      rel='noopener noreferrer'
                    >
                      <Icon icon={link.icon} />
                      {link.label}
                    </a>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
