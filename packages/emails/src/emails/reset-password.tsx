import {
  Body,
  Button,
  Container,
  Head,
  Hr,
  Html,
  Link,
  pixelBasedPreset,
  Preview,
  Section,
  Tailwind,
  Text,
} from "@react-email/components";

interface ResetPasswordEmailProps {
  name: string;
  token: string;
}

export default function ResetPasswordEmail({ name, token }: ResetPasswordEmailProps) {
  const resetUrl = new URL("/reset-password", process.env.APP_URL);
  resetUrl.searchParams.append("token", token);

  return (
    <Html>
      <Head />
      <Preview>Şifre sıfırlama talebiniz</Preview>
      <Tailwind
        config={{
          presets: [pixelBasedPreset],
        }}
      >
        <Body className='bg-gray-50 font-sans'>
          <Container className='mx-auto mb-16 bg-white p-0'>
            {/* Header */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-3xl font-bold text-gray-900'>Şifre Sıfırlama 🔐</Text>
              <Text className='m-4 text-base text-gray-700'>
                Merhaba {name}, hesabın için bir şifre sıfırlama talebi aldık.
              </Text>
            </Section>

            {/* Main Content */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-base text-gray-700'>
                Şifreni sıfırlamak için aşağıdaki butona tıklayabilirsin. Bu bağlantı 1 saat boyunca
                geçerli olacaktır.
              </Text>
            </Section>

            {/* CTA Button */}
            <Section className='px-12 py-8 text-center'>
              <Button
                href={resetUrl.toString()}
                className='rounded-lg bg-blue-600 px-8 py-3 text-center text-base font-bold text-white'
              >
                Şifremi Sıfırla
              </Button>
            </Section>

            {/* Alternative Link */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-sm text-gray-600'>
                Eğer buton çalışmazsa, aşağıdaki bağlantıyı tarayıcına kopyalayabilirsin:
              </Text>
              <Text className='m-4 text-sm break-all text-gray-500'>{resetUrl.toString()}</Text>
            </Section>

            {/* Security Notice */}
            <Section className='px-12 py-8'>
              <div className='rounded-lg bg-yellow-50 p-4'>
                <Text className='m-0 text-sm font-semibold text-yellow-900'>
                  ⚠️ Güvenlik Uyarısı
                </Text>
                <Text className='mt-2 text-sm text-yellow-800'>
                  Eğer bu talebi sen yapmadıysan, bu e-postayı görmezden gelebilirsin. Şifren
                  değiştirilmeyecektir.
                </Text>
              </div>
            </Section>

            <Hr className='mx-0 my-8 border-gray-200' />

            {/* Help Section */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-base text-gray-700'>
                Herhangi bir sorun yaşıyorsan, destek ekibimizle{" "}
                <Link
                  href='mailto:support@haloidergisi.com'
                  className='text-blue-600 underline'
                >
                  support@haloidergisi.com
                </Link>{" "}
                adresinden iletişime geçebilirsin.
              </Text>
            </Section>

            <Hr className='mx-0 my-8 border-gray-200' />

            {/* Footer */}
            <Section className='px-12 py-8 text-center'>
              <Text className='m-1 text-sm text-gray-600'>
                © 2026 Haloidergisi. Tüm hakları saklıdır.
              </Text>
              <Text className='m-1 text-sm text-gray-600'>
                <Link
                  href='https://haloidergisi.com'
                  className='text-blue-600 underline'
                >
                  Web sitemizi ziyaret edin
                </Link>
                {" | "}
                <Link
                  href='https://haloidergisi.com/privacy'
                  className='text-blue-600 underline'
                >
                  Gizlilik Politikası
                </Link>
              </Text>
            </Section>
          </Container>
        </Body>
      </Tailwind>
    </Html>
  );
}

ResetPasswordEmail.PreviewProps = {
  name: "John Doe",
  token: "abc123def456ghi789",
} satisfies ResetPasswordEmailProps;
