import React from 'react';
import { Box, Container, useTheme, useMediaQuery } from '@mui/material';
import Header from './Header';
import Footer from './Footer';

interface ResponsiveLayoutProps {
  children: React.ReactNode;
}

const ResponsiveLayout: React.FC<ResponsiveLayoutProps> = ({ children }) => {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));

  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        minHeight: '100vh',
        backgroundColor: theme.palette.background.default,
      }}
    >
      <Header />
      <Container
        maxWidth="lg"
        sx={{
          flex: 1,
          py: isMobile ? 2 : 4,
          px: isMobile ? 1 : 2,
        }}
      >
        {children}
      </Container>
      <Footer />
    </Box>
  );
};

export default ResponsiveLayout; 