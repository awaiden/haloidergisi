import { useTheme } from "next-themes";

interface LogoProps extends React.ComponentProps<"img"> {}

export default function Logo({ src, alt, ...props }: LogoProps) {
  const { resolvedTheme } = useTheme();

  src = "";
  switch (resolvedTheme) {
    case "light":
      src = "/halo-light.png";
      break;
    case "dark":
      src = "/halo-dark.png";
      break;
    default:
      src = "/halo-light.png";
      break;
  }

  alt = "HALO Dergisi Logo";

  return (
    <img
      src={src}
      alt={alt}
      {...props}
      className={`logo ${props.className ?? ""}`}
    />
  );
}
