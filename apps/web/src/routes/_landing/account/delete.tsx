import { Separator, Field, Button, Form } from "@adn-ui/react";
import { zodResolver } from "@hookform/resolvers/zod";
import { Icon } from "@iconify/react";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import React from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import z from "zod";

import apiClient from "@/lib/api-client";

const deleteAccountSchema = z.object({
  password: z.string().min(1, { message: "Parola gereklidir." }),
});

type DeleteAccountData = z.infer<typeof deleteAccountSchema>;

export const Route = createFileRoute("/_landing/account/delete")({
  component: RouteComponent,
});

function RouteComponent() {
  const navigate = useNavigate();
  const [isPasswordVisible, setIsPasswordVisible] = React.useState(false);

  const form = useForm<DeleteAccountData>({
    resolver: zodResolver(deleteAccountSchema),
    defaultValues: {
      password: "",
    },
  });

  const onSubmit = async (data: DeleteAccountData) => {
    try {
      await apiClient.delete("/account", { data });
      toast.success("Hesabınız başarıyla silindi.");
      await navigate({ to: "/" });
    } catch (error) {
      console.error(error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='text-danger mb-2 text-2xl font-semibold'>Hesabı Sil</h2>
        <p className='text-muted-foreground text-sm'>
          Bu işlem geri alınamaz. Hesabınızı silmek için parolanızı girin.
        </p>
      </div>

      <Separator />

      <div className='bg-danger/10 border-danger/20 rounded-lg border p-4'>
        <div className='flex gap-3'>
          <Icon
            icon='mdi:alert'
            className='text-danger mt-0.5 shrink-0 text-xl'
          />
          <div>
            <h3 className='text-danger mb-1 font-semibold'>Dikkat!</h3>
            <p className='text-muted-foreground text-sm'>
              Hesabınızı sildiğinizde tüm verileriniz kalıcı olarak silinecektir. Bu işlem geri
              alınamaz.
            </p>
          </div>
        </div>
      </div>

      <Form
        form={form}
        onSubmit={onSubmit}
        className='mx-auto'
      >
        <Field.Root
          name='password'
          isRequired
        >
          <Field.Label className='text-sm font-medium'>Parolanızı Girin</Field.Label>
          <div className='relative'>
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
          <Field.ErrorMessage />
        </Field.Root>

        <div className='flex justify-end pt-4'>
          <Button
            variant='danger'
            type='submit'
          >
            Hesabı Kalıcı Olarak Sil
          </Button>
        </div>
      </Form>
    </div>
  );
}
