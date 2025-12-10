import { BottomNavBar } from "./BottomNavBar/BottomNavBar";
import { Container } from "./Container/Container";
import { Header } from "./Header/Header";

export interface BaseLayoutProps {
  title?: string;
  children: React.ReactNode;
  showHeader?: boolean;
  showBottomNav?: boolean;
}

export function BaseLayout({ children, showHeader = true, showBottomNav = true }: BaseLayoutProps) {
  return (
    <div className="flex flex-col bg-gradient-primary min-h-screen">
      {showHeader && <Header />}
      <main className={`flex-1 ${showBottomNav ? 'mb-[72px] lg:mb-6' : ''}`}>
        <Container>{children}</Container>
      </main>
      {showBottomNav && <BottomNavBar />}
    </div>
  );
}
