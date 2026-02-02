import { Button, Card, Field, Form } from "@adn-ui/react";
import { zodResolver } from "@hookform/resolvers/zod";
import { Crew } from "@repo/db";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

import apiClient from "@/lib/api-client";
import { userSchema, UserSchema } from "@/schemas/user";
import { List } from "@/types";

export const Route = createFileRoute("/dashboard/users/new")({
  component: RouteComponent,
  loader: async () => {
    const { data: crews } = await apiClient.get<List<Crew>>("/crews", {
      params: { limit: 1000 },
    });
    return { crews };
  },
});

function RouteComponent() {
  const navigate = useNavigate({ from: Route.id });
  const { crews } = Route.useLoaderData();

  const form = useForm({
    resolver: zodResolver(userSchema),
    defaultValues: {
      name: "",
      email: "",
      password: "",
      crewId: undefined,
    },
  });

  const queryClient = useQueryClient();
  const createMutation = useMutation({
    mutationFn: async (data: UserSchema) => {
      await apiClient.post("/users", data);
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["users"] });
      toast.success("Kullanıcı başarıyla oluşturuldu.");
      void navigate({ to: "/dashboard/users" });
    },
    onError: (error) => {
      const resolved = apiClient.resolveApiError(error);
      toast.error(resolved.message, {
        description: resolved.error,
      });
    },
  });

  const onSubmit = (data: UserSchema) => {
    createMutation.mutate(data);
  };

  return (
    <Card.Root className='mx-auto'>
      <Card.Header>
        <Card.Title>Yeni Kullanıcı Oluştur</Card.Title>
      </Card.Header>
      <Card.Content>
        <section>
          <Form
            form={form}
            onSubmit={onSubmit}
          >
            <Field.Root name='name'>
              <Field.Label>Ad</Field.Label>
              <Field.Input type='text' />
              <Field.HelperText>
                Kullanıcı adı en az 1 en fazla 100 karakter olabilir.
              </Field.HelperText>
              <Field.ErrorMessage />
            </Field.Root>

            <Field.Root name='email'>
              <Field.Label>E-posta</Field.Label>
              <Field.Input type='email' />
              <Field.HelperText>Geçerli bir e-posta adresi giriniz.</Field.HelperText>
              <Field.ErrorMessage />
            </Field.Root>

            <Field.Root name='password'>
              <Field.Label>Şifre</Field.Label>
              <Field.Input type='password' />
              <Field.HelperText>Şifre en az 6 en fazla 100 karakter olmalıdır.</Field.HelperText>
              <Field.ErrorMessage />
            </Field.Root>

            <Field.Root name='crewId'>
              <Field.Label>Crew ID (Opsiyonel)</Field.Label>
              <Field.Select>
                <option value=''>Crew atama</option>
                {crews.items.map((crew) => (
                  <option
                    key={crew.id}
                    value={crew.id}
                  >
                    {crew.name}
                  </option>
                ))}
              </Field.Select>
              <Field.HelperText>
                Kullanıcıyı bir crew'e atamak için crew ID'si giriniz.
              </Field.HelperText>
              <Field.ErrorMessage />
            </Field.Root>

            <Button
              type='submit'
              disabled={createMutation.isPending}
            >
              {createMutation.isPending ? "Oluşturuluyor..." : "Oluştur"}
            </Button>
          </Form>
        </section>
      </Card.Content>
    </Card.Root>
  );
}
