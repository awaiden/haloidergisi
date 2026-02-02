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

interface WelcomeEmailProps {
  name: string;
}

export default function WelcomeEmail({ name }: WelcomeEmailProps) {
  return (
    <Html>
      <Head />
      <Preview>Haloidergisi'ne Hoş Geldiniz!</Preview>
      <Tailwind
        config={{
          presets: [pixelBasedPreset],
        }}
      >
        <Body className='bg-gray-50 font-sans'>
          <Container className='mx-auto mb-16 bg-white p-0'>
            {/* Header */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-3xl font-bold text-gray-900'>
                HALO Dergisi'ne Hoş Geldiniz! 🎉
              </Text>
              <Text className='m-4 text-base text-gray-700'>
                Merhaba {name}, aramıza katıldığın için teşekkürler. Seni aramızda görmekten
                mutluluk duyuyoruz!
              </Text>
            </Section>

            {/* Main Content */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-2xl font-bold text-gray-800'>Sırada Ne Var?</Text>
              <Text className='m-4 text-base text-gray-700'>
                Başlamak için yapabileceğin bazı şeyler:
              </Text>

              <div className='m-4 space-y-3'>
                <div className='flex gap-3'>
                  <Text className='text-lg'>📚</Text>
                  <Text className='text-base text-gray-700'>İçerik kütüphanemizi keşfet</Text>
                </div>
                <div className='flex gap-3'>
                  <Text className='text-lg'>🔔</Text>
                  <Text className='text-base text-gray-700'>
                    Son gönderilerden haberdar olmak için bildirimleri etkinleştir
                  </Text>
                </div>
              </div>
            </Section>

            {/* CTA Button */}
            <Section className='px-12 py-8 text-center'>
              <Button
                href={process.env.WEB_URL || "https://haloidergisi.com"}
                className='rounded-lg bg-blue-600 px-8 py-3 text-center text-base font-bold text-white'
              >
                Başla
              </Button>
            </Section>

            {/* Help Section */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-2xl font-bold text-gray-800'>
                Yardıma mı İhtiyacın Var?
              </Text>
              <Text className='m-4 text-base text-gray-700'>
                Herhangi bir sorun veya yardıma ihtiyacın olursa, destek ekibimizle{" "}
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

WelcomeEmail.PreviewProps = {
  name: "John Doe",
} satisfies WelcomeEmailProps;
