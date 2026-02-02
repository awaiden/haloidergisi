import { Separator, Field, Button, Form } from "@adn-ui/react";
import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { createFileRoute } from "@tanstack/react-router";
import React from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import z from "zod";

import apiClient from "@/lib/api-client";

const changePasswordFormSchema = z.object({
  currentPassword: z.string().min(1, { message: "Mevcut parola gereklidir." }),
  newPassword: z.string().min(6, { message: "Yeni parola en az 6 karakter olmalıdır." }),
  confirmNewPassword: z.string().min(6, { message: "Yeni parola onayı gereklidir." }),
});

type ChangePasswordFormData = z.infer<typeof changePasswordFormSchema>;

export const Route = createFileRoute("/_landing/account/security")({
  component: RouteComponent,
});

function RouteComponent() {
  const [isPasswordVisible, setIsPasswordVisible] = React.useState(false);

  const form = useForm<ChangePasswordFormData>({
    resolver: zodResolver(changePasswordFormSchema),
    defaultValues: {
      currentPassword: "",
      newPassword: "",
      confirmNewPassword: "",
    },
  });

  const onSubmit = async (data: ChangePasswordFormData) => {
    if (data.newPassword !== data.confirmNewPassword) {
      toast.error("Yeni parolalar eşleşmiyor.");
      return;
    }

    try {
      await apiClient.patch("/account/password", data);
      toast.success("Parolanız başarıyla değiştirildi.");
      form.reset();
    } catch (error) {
      console.error(error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-semibold'>Parolayı Değiştir</h2>
        <p className='text-muted-foreground text-sm'>
          Hesabınızın güvenliği için güçlü bir parola kullanın.
        </p>
      </div>

      <Separator />

      <Form
        form={form}
        onSubmit={onSubmit}
        className='mx-auto'
      >
        <Field.Root name='currentPassword'>
          <Field.Label className='text-sm font-medium'>Mevcut Parola</Field.Label>
          <div className='relative mt-2'>
            <Field.Input
              type={isPasswordVisible ? "text" : "password"}
              className='pr-10'
            />
            <button
              onClick={() => setIsPasswordVisible((prev) => !prev)}
              type='button'
              className='absolute top-1/2 right-3 -translate-y-1/2 cursor-pointer'
            >
              <Icon icon={isPasswordVisible ? "mdi:eye-off" : "mdi:eye"} />
            </button>
          </div>
          <Field.HelperText>Mevcut parolanızı girin.</Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <Field.Root name='newPassword'>
          <Field.Label className='text-sm font-medium'>Yeni Parola</Field.Label>
          <div className='relative mt-2'>
            <Field.Input
              type={isPasswordVisible ? "text" : "password"}
              className='pr-10'
            />
            <button
              onClick={() => setIsPasswordVisible((prev) => !prev)}
              type='button'
              className='absolute top-1/2 right-3 -translate-y-1/2 cursor-pointer'
            >
              <Icon icon={isPasswordVisible ? "mdi:eye-off" : "mdi:eye"} />
            </button>
          </div>
          <Field.HelperText>En az 6 karakter olmalıdır.</Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <Field.Root name='confirmNewPassword'>
          <Field.Label className='text-sm font-medium'>Yeni Parola (Tekrar)</Field.Label>
          <div className='relative mt-2'>
            <Field.Input
              type={isPasswordVisible ? "text" : "password"}
              className='pr-10'
            />
            <button
              onClick={() => setIsPasswordVisible((prev) => !prev)}
              type='button'
              className='absolute top-1/2 right-3 -translate-y-1/2 cursor-pointer'
            >
              <Icon icon={isPasswordVisible ? "mdi:eye-off" : "mdi:eye"} />
            </button>
          </div>
          <Field.HelperText>Yeni parolanızı tekrar girin.</Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <div className='flex justify-end pt-4'>
          <Button type='submit'>Parolayı Güncelle</Button>
        </div>
      </Form>
    </div>
  );
}
