import { Separator, Field, Button, Form } from "@adn-ui/react";
import { zodResolver } from "@hookform/resolvers/zod";
import { createFileRoute } from "@tanstack/react-router";
import React from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import z from "zod";

import { useAuth } from "@/hooks/use-auth";
import apiClient from "@/lib/api-client";

const updateAccountSchema = z.object({
  email: z.email({ message: "Geçerli bir e-posta adresi girin." }),
});

type UpdateAccountData = z.infer<typeof updateAccountSchema>;

export const Route = createFileRoute("/_landing/account/")({
  component: RouteComponent,
});

function RouteComponent() {
  const { data: user } = useAuth();
  const [isVerificationLoading, setIsVerificationLoading] = React.useState(false);

  const form = useForm<UpdateAccountData>({
    resolver: zodResolver(updateAccountSchema),
    defaultValues: {
      email: user?.email || "",
    },
  });

  if (!user) {
    return null;
  }

  const onSubmit = async (data: UpdateAccountData) => {
    try {
      await apiClient.patch("/account", data);
      toast.success("Hesap ayarlarınız başarıyla güncellendi.");
    } catch (error) {
      console.error(error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  const handleRequestVerification = async () => {
    setIsVerificationLoading(true);
    try {
      await apiClient.post("/account/request-email-verification");
      toast.success("Doğrulama e-postası gönderildi.", {
        description: "Lütfen e-postanızı kontrol edin.",
      });
    } catch (error) {
      console.error(error);
      toast.error(apiClient.resolveApiError(error).message);
    } finally {
      setIsVerificationLoading(false);
    }
  };

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-semibold'>Hesap Ayarları</h2>
        <p className='text-muted-foreground text-sm'>
          E-posta adresinizi ve hesap bilgilerinizi yönetin.
        </p>
      </div>

      <Separator />

      <Form
        form={form}
        onSubmit={onSubmit}
        className='mx-auto'
      >
        <Field.Root
          name='email'
          isRequired
        >
          <Field.Label className='text-sm font-medium'>E-posta Adresi</Field.Label>
          <Field.Input
            name='email'
            className='pr-10'
          />
        </Field.Root>

        {user.emailVerifiedAt ? (
          <div className='text-sm text-green-600'>E-posta adresiniz doğrulandı.</div>
        ) : (
          <Button
            variant='outline'
            size='sm'
            onClick={handleRequestVerification}
            disabled={isVerificationLoading}
          >
            Doğrulama E-postası Gönder
          </Button>
        )}

        <div className='flex justify-end pt-4'>
          <Button type='submit'>Değişiklikleri Kaydet</Button>
        </div>
      </Form>
    </div>
  );
}
