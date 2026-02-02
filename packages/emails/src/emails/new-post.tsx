import {
  Body,
  Button,
  Container,
  Head,
  Hr,
  Html,
  Img,
  Link,
  pixelBasedPreset,
  Preview,
  Section,
  Tailwind,
  Text,
} from "@react-email/components";

interface NewPostEmailProps {
  name: string;
  title: string;
  content: string;
  slug: string;
  coverImage: string;
}

export default function NewPostEmail({
  name,
  title,
  content,
  slug,
  coverImage,
}: NewPostEmailProps) {
  const postUrl = new URL(`/posts/${slug}`, process.env.APP_URL).toString();
  const coverImageUrl = new URL(coverImage, process.env.VITE_CDN_URL).toString();

  return (
    <Html>
      <Head />
      <Preview>Yeni Sayı Yayınlandı: {title}</Preview>
      <Tailwind
        config={{
          presets: [pixelBasedPreset],
        }}
      >
        <Body className='bg-gray-50 font-sans'>
          <Container className='mx-auto mb-16 bg-white p-0'>
            {/* Header */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-3xl font-bold text-gray-900'>Yeni Sayı Yayınlandı! 📚</Text>
              <Text className='m-4 text-base text-gray-700'>
                Merhaba {name}, HALO Dergisi'nin yeni sayısı yayınlandı!
              </Text>
            </Section>

            {/* Cover Image */}
            {coverImageUrl && (
              <Section className='px-12 py-4'>
                <Img
                  src={coverImageUrl}
                  alt={title}
                  className='w-full rounded-lg'
                  style={{ maxWidth: "500px", margin: "0 auto", display: "block" }}
                />
              </Section>
            )}

            {/* Issue Info */}
            <Section className='px-12 py-8'>
              <div className='rounded-lg bg-blue-50 p-6'>
                <Text className='m-0 mb-3 text-2xl font-bold text-gray-900'>{title}</Text>
                {content && <Text className='m-0 text-base text-gray-700'>{content}</Text>}
              </div>
            </Section>

            {/* CTA Button */}
            <Section className='px-12 py-8 text-center'>
              <Button
                href={postUrl}
                className='rounded-lg bg-blue-600 px-8 py-3 text-center text-base font-bold text-white'
              >
                Şimdi Oku
              </Button>
            </Section>

            {/* Features */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-xl font-bold text-gray-800'>Bu Sayıda:</Text>
              <div className='m-4 space-y-3'>
                <div className='flex gap-3'>
                  <Text className='text-lg'>🎨</Text>
                  <Text className='text-base text-gray-700'>Özel illüstrasyonlar ve görseller</Text>
                </div>
                <div className='flex gap-3'>
                  <Text className='text-lg'>💡</Text>
                  <Text className='text-base text-gray-700'>
                    İlham verici içerikler ve fikirler
                  </Text>
                </div>
              </div>
            </Section>

            <Hr className='mx-0 my-8 border-gray-200' />

            {/* Social Sharing */}
            <Section className='px-12 py-8'>
              <Text className='m-4 text-base text-gray-700'>
                Bu sayıyı beğendiysen, arkadaşlarınla paylaşmayı unutma!
              </Text>
            </Section>

            <Hr className='mx-0 my-8 border-gray-200' />

            {/* Preferences */}
            <Section className='px-12 py-8 text-center'>
              <Text className='m-1 text-sm text-gray-600'>
                Yeni sayı bildirimlerini almak istemiyorsan,{" "}
                <Link
                  href={"https://haloidergisi.com/account"}
                  className='text-blue-600 underline'
                >
                  bildirim ayarlarını
                </Link>{" "}
                düzenleyebilirsin.
              </Text>
            </Section>

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

NewPostEmail.PreviewProps = {
  name: "John Doe",
  title: "Yeni Sayı",
  content: "lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  coverImage: "#",
  slug: "yeni-sayi",
} satisfies NewPostEmailProps;
