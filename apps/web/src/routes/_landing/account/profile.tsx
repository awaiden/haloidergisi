import { zodResolver } from "@hookform/resolvers/zod";
import { createFileRoute } from "@tanstack/react-router";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

import CdnImage from "@/components/cdn-image";
import { FieldFileInput } from "@/components/file-input";
import { Button } from "@/components/ui/button";
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
import { Textarea } from "@/components/ui/textarea";
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
      // The title is admin-managed; don't send it from the user's own form.
      const { title: _title, ...payload } = data;
      await apiClient.patch(`/profile/${user!.profile!.id}`, payload);
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

      <Form {...form}>
        <form
          onSubmit={form.handleSubmit(onSubmit)}
          className='mx-auto space-y-4'
        >
          <FormField
            control={form.control}
            name='avatarUrl'
            render={() => (
              <FormItem>
                <div className='flex items-end justify-between'>
                  <FormLabel>Profil Resmi</FormLabel>
                  <CdnImage
                    src={form.watch("avatarUrl") || ""}
                    alt='Avatar'
                    className='size-20'
                  />
                </div>
                <FormControl>
                  <FieldFileInput
                    name='avatarUrl'
                    accept='image/*'
                  />
                </FormControl>
                <FormDescription>
                  Profil resminiz, hesabınızı tanımlamak için kullanılır.
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name='name'
            render={({ field }) => (
              <FormItem>
                <FormLabel>İsim</FormLabel>
                <FormControl>
                  <Input {...field} />
                </FormControl>
                <FormDescription>Görünür isminiz.</FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name='website'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Website</FormLabel>
                <FormControl>
                  <Input
                    {...field}
                    placeholder='Örneğin: https://example.com'
                  />
                </FormControl>
                <FormDescription>
                  Sosyal medya profillerinize veya kişisel web sitenize bağlantı ekleyebilirsiniz.
                  TAM URL formatında olduğundan emin olun (örneğin, https://example.com).
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name='bio'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Biyografi</FormLabel>
                <FormControl>
                  <Textarea
                    {...field}
                    placeholder='Kendiniz hakkında birkaç kelime yazın...'
                  />
                </FormControl>
                <FormDescription>
                  Kendiniz hakkında kısa bir biyografi ekleyin (maksimum 500 karakter).
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <div className='flex justify-end pt-4'>
            <Button type='submit'>Değişiklikleri Kaydet</Button>
          </div>
        </form>
      </Form>
    </div>
  );
}
