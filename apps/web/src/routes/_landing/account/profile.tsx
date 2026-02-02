import { Separator, Field, Button, Form, Label } from "@adn-ui/react";
import { zodResolver } from "@hookform/resolvers/zod";
import { createFileRoute } from "@tanstack/react-router";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

import CdnImage from "@/components/cdn-image";
import { FieldFileInput } from "@/components/file-input";
import { useAuth } from "@/hooks/use-auth";
import apiClient from "@/lib/api-client";
import { queryClient } from "@/lib/query-client";
import { ProfileSchema, profileSchema } from "@/schemas/profile";

export const Route = createFileRoute("/_landing/account/profile")({
  component: RouteComponent,
});

function RouteComponent() {
  const { data: user } = useAuth();

  const form = useForm<ProfileSchema>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      name: user?.profile?.name || "",
      bio: user?.profile?.bio || "",
      title: user?.profile?.title || "",
      website: user?.profile?.website || "",
      avatarUrl: user?.profile?.avatarUrl || "",
    },
  });

  const onSubmit = async (data: ProfileSchema) => {
    try {
      await apiClient.patch(`/profile/${user!.profile!.id}`, data);
      toast.success("Profiliniz başarıyla güncellendi.");
      await queryClient.invalidateQueries({ queryKey: ["auth"] });
    } catch (error) {
      console.error(error);
      toast.error(apiClient.resolveApiError(error).message);
    }
  };

  if (!user) {
    return null;
  }

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-semibold'>Profili Güncelle</h2>
        <p className='text-muted-foreground text-sm'>Profil bilgilerinizi güncelleyin.</p>
      </div>

      <Separator />

      <Form
        form={form}
        onSubmit={onSubmit}
        className='mx-auto'
      >
        <Field.Root name='avatarUrl'>
          <div className='flex items-end justify-between'>
            <Label>Profil Resmi</Label>
            <CdnImage
              src={form.watch("avatarUrl") || ""}
              alt='Avatar'
              className='size-20'
            />
          </div>
          <FieldFileInput
            name='avatarUrl'
            accept='image/*'
          />
          <Field.HelperText>
            Profil resminiz, hesabınızı tanımlamak için kullanılır.
          </Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <Field.Root
          name='name'
          isRequired
        >
          <Field.Label>İsim</Field.Label>
          <Field.Input name='name' />
          <Field.HelperText>Görünür isminiz.</Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <Field.Root name='website'>
          <Field.Label>Website</Field.Label>
          <Field.Input
            name='website'
            placeholder='Örneğin: https://example.com'
          />
          <Field.HelperText>
            Sosyal medya profillerinize veya kişisel web sitenize bağlantı ekleyebilirsiniz. TAM URL
            formatında olduğundan emin olun (örneğin, https://example.com).
          </Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <Field.Root name='bio'>
          <Field.Label>Biyografi</Field.Label>
          <Field.TextArea
            name='bio'
            placeholder='Kendiniz hakkında birkaç kelime yazın...'
          />
          <Field.HelperText>
            Kendiniz hakkında kısa bir biyografi ekleyin (maksimum 500 karakter).
          </Field.HelperText>
          <Field.ErrorMessage />
        </Field.Root>

        <div className='flex justify-end pt-4'>
          <Button type='submit'>Değişiklikleri Kaydet</Button>
        </div>
      </Form>
    </div>
  );
}
