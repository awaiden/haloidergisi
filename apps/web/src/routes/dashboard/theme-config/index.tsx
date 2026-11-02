import { Icon } from "@iconify/react";
import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { toast } from "sonner";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import apiClient from "@/lib/api-client";
import { useThemeConfig, useUpdateThemeConfig } from "@/queries/use-theme-config";
import { loadGoogleFont } from "@/utils/google-fonts";

export const Route = createFileRoute("/dashboard/theme-config/")({
  component: ThemeConfigDashboardPage,
});

const PRESETS = [
  { id: "default", name: "Varsayılan (Nötr)", primary: "#18181b", primaryDark: "#f4f4f5" },
  { id: "ocean", name: "Okyanus Mavisı", primary: "#0284c7", primaryDark: "#38bdf8" },
  { id: "emerald", name: "Zümrüt Yeşili", primary: "#059669", primaryDark: "#34d399" },
  { id: "violet", name: "Menekşe Moru", primary: "#7c3aed", primaryDark: "#a78bfa" },
  { id: "crimson", name: "Koyu Kırmızı", primary: "#dc2626", primaryDark: "#f87171" },
  { id: "amber", name: "Kehribar", primary: "#d97706", primaryDark: "#fbbf24" },
  { id: "halloween", name: "Cadılar Bayramı 🎃", primary: "#ea580c", primaryDark: "#fb923c" },
];

const RADIUS_OPTIONS = [
  { label: "Köşeli (0px)", value: "0rem" },
  { label: "Hafif (6px)", value: "0.375rem" },
  { label: "Varsayılan (10px)", value: "0.625rem" },
  { label: "Yuvarlatılmış (16px)", value: "1rem" },
  { label: "Tam Yuvarlak (24px)", value: "1.5rem" },
];

const FONT_OPTIONS = [
  { label: "Inter (Varsayılan Sans)", value: '"Inter Variable", sans-serif' },
  { label: "Plus Jakarta Sans (Modern Sans)", value: '"Plus Jakarta Sans", sans-serif' },
  { label: "Outfit (Dinamik Sans)", value: '"Outfit", sans-serif' },
  { label: "Poppins (Geometrik Sans)", value: '"Poppins", sans-serif' },
  { label: "Roboto (Temiz Sans)", value: '"Roboto", sans-serif' },
  { label: "Playfair Display (Zarif Dergi Serif)", value: '"Playfair Display", serif' },
  { label: "Lora (Edebiyat & Yazı Serif)", value: '"Lora", serif' },
  { label: "Merriweather (Okunabilir Serif)", value: '"Merriweather", serif' },
  { label: "Cinzel (Klasik / Şık Serif)", value: '"Cinzel", serif' },
  { label: "Fira Code (Kod / Monospace)", value: '"Fira Code", monospace' },
  { label: "Space Grotesk (Teknoloji / Modern)", value: '"Space Grotesk", sans-serif' },
  { label: "Caveat (El Yazısı / Script)", value: '"Caveat", cursive' },
  { label: "Sistem (System UI)", value: "system-ui, sans-serif" },
];

// Helper to convert any color string to a valid 6-char hex for <input type="color">
function toHexColor(colorStr: string): string {
  if (!colorStr) return "#18181b";
  if (colorStr.startsWith("#")) {
    if (colorStr.length === 4) {
      return `#${colorStr[1]}${colorStr[1]}${colorStr[2]}${colorStr[2]}${colorStr[3]}${colorStr[3]}`;
    }
    return colorStr.slice(0, 7);
  }
  return "#18181b";
}

function ThemeConfigDashboardPage() {
  const { data: config, isLoading } = useThemeConfig();
  const updateThemeMutation = useUpdateThemeConfig();

  const [formState, setFormState] = useState({
    preset: "default",
    primaryColor: "#18181b",
    primaryDarkColor: "#f4f4f5",
    radius: "0.625rem",
    fontFamily: '"Inter Variable", sans-serif',
  });

  const [customFontInput, setCustomFontInput] = useState("");

  useEffect(() => {
    if (config) {
      setFormState({
        preset: config.preset || "default",
        primaryColor: config.primaryColor || "#18181b",
        primaryDarkColor: config.primaryDarkColor || "#f4f4f5",
        radius: config.radius || "0.625rem",
        fontFamily: config.fontFamily || '"Inter Variable", sans-serif',
      });
    }
  }, [config]);

  // Live preview effect on local document root & dynamic Google Fonts loader
  useEffect(() => {
    const root = document.documentElement;

    if (formState.preset === "default") {
      root.style.removeProperty("--primary");
      root.style.removeProperty("--radius");
      root.style.removeProperty("--font-sans");
      document.body.style.fontFamily = "";
      delete root.dataset.season;
      return;
    }

    if (formState.preset === "halloween") root.dataset.season = "halloween";
    else delete root.dataset.season;

    if (formState.primaryColor) {
      root.style.setProperty("--primary", formState.primaryColor);
    }
    if (formState.radius) {
      root.style.setProperty("--radius", formState.radius);
    }
    if (formState.fontFamily) {
      loadGoogleFont(formState.fontFamily);
      root.style.setProperty("--font-sans", formState.fontFamily);
      document.body.style.fontFamily = formState.fontFamily;
    }
  }, [formState]);

  const handleSelectPreset = (presetId: string) => {
    const selected = PRESETS.find((p) => p.id === presetId);
    if (selected) {
      setFormState((prev) => ({
        ...prev,
        preset: selected.id,
        primaryColor: selected.primary,
        primaryDarkColor: selected.primaryDark,
      }));
    }
  };

  const handleCustomFontApply = () => {
    if (!customFontInput.trim()) return;
    const formattedFont = `"${customFontInput.trim()}", sans-serif`;
    setFormState((prev) => ({ ...prev, fontFamily: formattedFont }));
    toast.success(`"${customFontInput.trim()}" Google Fonts'tan yüklendi.`);
  };

  const handleSave = () => {
    updateThemeMutation.mutate(formState, {
      onSuccess: () => {
        toast.success("Tema ayarları başarıyla kaydedildi.");
      },
      onError: (err) => {
        const res = apiClient.resolveApiError(err);
        toast.error(res.message);
      },
    });
  };

  const handleReset = () => {
    const defaultState = {
      preset: "default",
      primaryColor: "#18181b",
      primaryDarkColor: "#f4f4f5",
      radius: "0.625rem",
      fontFamily: '"Inter Variable", sans-serif',
    };
    setFormState(defaultState);
    setCustomFontInput("");
    updateThemeMutation.mutate(defaultState, {
      onSuccess: () => {
        toast.success("Tema varsayılan ayarlara sıfırlandı.");
      },
    });
  };

  if (isLoading) {
    return <div className='p-8 text-center'>Yükleniyor...</div>;
  }

  const isPredefinedFont = FONT_OPTIONS.some((opt) => opt.value === formState.fontFamily);

  return (
    <div className='mx-auto max-w-5xl space-y-8'>
      <div>
        <h1 className='text-2xl font-bold tracking-tight'>Tema & Görünüm Ayarları</h1>
        <p className='text-muted-foreground text-sm'>
          Web sitesinin ana renk paletini, kenar yuvarlaklıklarını ve Google Fonts tipografisini
          buradan özelleştirebilirsiniz.
        </p>
      </div>

      <div className='grid grid-cols-1 gap-8 lg:grid-cols-2'>
        {/* Controls Card */}
        <div className='space-y-6'>
          <Card>
            <CardHeader>
              <CardTitle className='flex items-center gap-2'>
                <Icon
                  icon='mdi:palette-outline'
                  className='size-5'
                />
                Hazır Renk Temaları
              </CardTitle>
              <CardDescription>Hızlı seçim için tasarlanmış hazır renk şablonları.</CardDescription>
            </CardHeader>
            <CardContent className='grid grid-cols-2 gap-3 sm:grid-cols-3'>
              {PRESETS.map((p) => {
                const isSelected = formState.preset === p.id;
                return (
                  <button
                    key={p.id}
                    type='button'
                    onClick={() => handleSelectPreset(p.id)}
                    className={`flex flex-col items-center gap-2 rounded-lg border p-3 text-left transition-all ${
                      isSelected
                        ? "border-primary ring-primary/30 bg-accent/50 font-medium ring-2"
                        : "border-border hover:bg-accent/20"
                    }`}
                  >
                    <div className='flex items-center gap-1.5'>
                      <div
                        className='size-5 rounded-full border shadow-sm'
                        style={{ backgroundColor: p.primary }}
                        title='Aydınlık Mod Rengi'
                      />
                      <div
                        className='size-5 rounded-full border shadow-sm'
                        style={{ backgroundColor: p.primaryDark }}
                        title='Karanlık Mod Rengi'
                      />
                    </div>
                    <span className='w-full truncate text-center text-xs'>{p.name}</span>
                  </button>
                );
              })}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className='flex items-center gap-2'>
                <Icon
                  icon='mdi:tune'
                  className='size-5'
                />
                Özel Renk & Stil Ayarları
              </CardTitle>
            </CardHeader>
            <CardContent className='space-y-5'>
              {/* Color Picker for Primary Color */}
              <div className='space-y-2'>
                <Label htmlFor='primaryColorPicker'>Ana Renk (Light Mode)</Label>
                <div className='flex items-center gap-3'>
                  <input
                    id='primaryColorPicker'
                    type='color'
                    value={toHexColor(formState.primaryColor)}
                    onChange={(e) =>
                      setFormState((prev) => ({
                        ...prev,
                        primaryColor: e.target.value,
                        preset: "custom",
                      }))
                    }
                    className='bg-background size-11 cursor-pointer rounded-md border p-1'
                  />
                  <Input
                    value={formState.primaryColor}
                    onChange={(e) =>
                      setFormState((prev) => ({
                        ...prev,
                        primaryColor: e.target.value,
                        preset: "custom",
                      }))
                    }
                    placeholder='#18181b'
                    className='flex-1 font-mono text-xs'
                  />
                </div>
              </div>

              {/* Color Picker for Dark Mode Primary Color */}
              <div className='space-y-2'>
                <Label htmlFor='primaryDarkColorPicker'>Ana Renk (Dark Mode)</Label>
                <div className='flex items-center gap-3'>
                  <input
                    id='primaryDarkColorPicker'
                    type='color'
                    value={toHexColor(formState.primaryDarkColor)}
                    onChange={(e) =>
                      setFormState((prev) => ({
                        ...prev,
                        primaryDarkColor: e.target.value,
                        preset: "custom",
                      }))
                    }
                    className='bg-background size-11 cursor-pointer rounded-md border p-1'
                  />
                  <Input
                    value={formState.primaryDarkColor}
                    onChange={(e) =>
                      setFormState((prev) => ({
                        ...prev,
                        primaryDarkColor: e.target.value,
                        preset: "custom",
                      }))
                    }
                    placeholder='#f4f4f5'
                    className='flex-1 font-mono text-xs'
                  />
                </div>
              </div>

              {/* Border Radius */}
              <div className='space-y-2'>
                <Label htmlFor='radius'>Kenar Yuvarlaklığı (Border Radius)</Label>
                <Select
                  value={formState.radius}
                  onValueChange={(val) => setFormState((prev) => ({ ...prev, radius: val }))}
                >
                  <SelectTrigger id='radius'>
                    <SelectValue placeholder='Kenar yuvarlaklığı seçin' />
                  </SelectTrigger>
                  <SelectContent>
                    {RADIUS_OPTIONS.map((opt) => (
                      <SelectItem
                        key={opt.value}
                        value={opt.value}
                      >
                        {opt.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Font Family Selector */}
              <div className='space-y-2'>
                <Label htmlFor='fontFamily'>Yazı Tipi (Google Fonts & Sistem)</Label>
                <Select
                  value={isPredefinedFont ? formState.fontFamily : "custom_input"}
                  onValueChange={(val) => {
                    if (val !== "custom_input") {
                      setFormState((prev) => ({ ...prev, fontFamily: val }));
                    }
                  }}
                >
                  <SelectTrigger id='fontFamily'>
                    <SelectValue placeholder='Yazı tipi seçin' />
                  </SelectTrigger>
                  <SelectContent>
                    {FONT_OPTIONS.map((opt) => (
                      <SelectItem
                        key={opt.value}
                        value={opt.value}
                      >
                        {opt.label}
                      </SelectItem>
                    ))}
                    {!isPredefinedFont && (
                      <SelectItem value='custom_input'>
                        Özel Font: {formState.fontFamily}
                      </SelectItem>
                    )}
                  </SelectContent>
                </Select>
              </div>

              {/* Custom Google Font Input */}
              <div className='space-y-2 border-t pt-2'>
                <Label htmlFor='customFont'>Herhangi bir Google Font İsmi Girin</Label>
                <div className='flex gap-2'>
                  <Input
                    id='customFont'
                    value={customFontInput}
                    onChange={(e) => setCustomFontInput(e.target.value)}
                    placeholder='Örn: Montserrat, Lora, Syne, Manrope'
                    className='text-xs'
                  />
                  <Button
                    type='button'
                    variant='secondary'
                    size='sm'
                    onClick={handleCustomFontApply}
                  >
                    Yükle
                  </Button>
                </div>
                <p className='text-muted-foreground text-[11px]'>
                  Google Fonts üzerinde yer alan herhangi bir font adını girip "Yükle" butonuna
                  basarak anında deneyebilirsiniz.
                </p>
              </div>
            </CardContent>
          </Card>

          <div className='flex items-center justify-end gap-4'>
            <Button
              variant='outline'
              onClick={handleReset}
              disabled={updateThemeMutation.isPending}
            >
              Varsayılana Sıfırla
            </Button>
            <Button
              onClick={handleSave}
              disabled={updateThemeMutation.isPending}
            >
              {updateThemeMutation.isPending ? "Kaydediliyor..." : "Değişiklikleri Kaydet"}
            </Button>
          </div>
        </div>

        {/* Live Preview Card */}
        <div>
          <Card className='sticky top-20 shadow-md'>
            <CardHeader>
              <CardTitle className='flex items-center gap-2'>
                <Icon
                  icon='mdi:eye-outline'
                  className='size-5'
                />
                Canlı Önizleme
              </CardTitle>
              <CardDescription>
                Seçtiğiniz font ve renkler otomatik olarak yüklenip bu bileşenlerde test edilir.
              </CardDescription>
            </CardHeader>
            <CardContent className='space-y-6'>
              {/* Active Font Badge */}
              <div className='bg-accent/40 flex items-center justify-between rounded-lg border p-3'>
                <span className='text-muted-foreground text-xs'>Aktif Yazı Tipi:</span>
                <Badge
                  variant='outline'
                  className='font-semibold'
                >
                  {formState.fontFamily}
                </Badge>
              </div>

              {/* Sample Buttons */}
              <div className='space-y-2'>
                <span className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                  Butonlar
                </span>
                <div className='flex flex-wrap gap-2'>
                  <Button variant='default'>Ana Buton</Button>
                  <Button variant='secondary'>İkincil Buton</Button>
                  <Button variant='outline'>Çerçeveli</Button>
                  <Button variant='ghost'>Hayalet</Button>
                </div>
              </div>

              {/* Sample Badges */}
              <div className='space-y-2'>
                <span className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                  Rozetler (Badges)
                </span>
                <div className='flex flex-wrap gap-2'>
                  <Badge variant='default'>Varsayılan</Badge>
                  <Badge variant='secondary'>İkincil</Badge>
                  <Badge variant='outline'>Outline</Badge>
                  <Badge variant='destructive'>Kritik</Badge>
                </div>
              </div>

              {/* Sample Card / Form */}
              <div className='space-y-2'>
                <span className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                  Form Kartı & Girdiler
                </span>
                <div className='bg-card space-y-3 rounded-lg border p-4'>
                  <h4 className='text-sm font-semibold'>HALO Dergisi Abonelik Formu</h4>
                  <p className='text-muted-foreground text-xs'>
                    En son yayınlanan makale ve haberlerden haberdar olun.
                  </p>
                  <div className='flex gap-2'>
                    <Input
                      placeholder='E-posta adresiniz...'
                      className='text-xs'
                    />
                    <Button size='sm'>Abone Ol</Button>
                  </div>
                </div>
              </div>

              {/* Typography Preview */}
              <div className='space-y-2'>
                <span className='text-muted-foreground text-xs font-semibold tracking-wider uppercase'>
                  Tipografi Önizleme
                </span>
                <div className='bg-muted/40 space-y-1 rounded-lg border p-3'>
                  <p className='text-base font-bold'>Dijital Yayıncılığın Geleceği</p>
                  <p className='text-muted-foreground text-xs leading-relaxed'>
                    HALO Dergisi, kültür, sanat ve edebiyat dünyasından en güncel içerikleri
                    okurlarıyla buluşturur.
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
