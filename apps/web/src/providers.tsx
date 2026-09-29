import { QueryClientProvider } from "@tanstack/react-query";
import { ThemeProvider } from "next-themes";

import { ThemeConfigProvider } from "@/components/theme-config-provider";
import { queryClient } from "@/lib/query-client";

function composeProviders(...providers: React.FC<React.PropsWithChildren>[]) {
  return ({ children }: React.PropsWithChildren) => {
    return providers.reduceRight((acc, Provider) => <Provider>{acc}</Provider>, children);
  };
}

const AppProviders = composeProviders(
  ({ children }) => (
    <ThemeProvider
      attribute='class'
      defaultTheme='light'
      enableSystem
    >
      {children}
    </ThemeProvider>
  ),
  ({ children }) => <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>,
  ({ children }) => <ThemeConfigProvider>{children}</ThemeConfigProvider>,
);

export default AppProviders;
