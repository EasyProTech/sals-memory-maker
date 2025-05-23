import React from 'react';
import QRCode from 'qrcode.react';
import { Box, Typography, Paper } from '@mui/material';

interface QRCodeProps {
  bookId: string;
  title: string;
}

const BookQRCode: React.FC<QRCodeProps> = ({ bookId, title }) => {
  const audioUrl = `${process.env.NEXT_PUBLIC_API_URL}/books/${bookId}/audio`;

  return (
    <Paper 
      elevation={3} 
      sx={{ 
        p: 2, 
        display: 'flex', 
        flexDirection: 'column', 
        alignItems: 'center',
        maxWidth: '300px',
        margin: '0 auto'
      }}
    >
      <Typography variant="h6" gutterBottom>
        Audio Book Access
      </Typography>
      <Box sx={{ p: 2, bgcolor: 'white', borderRadius: 1 }}>
        <QRCode
          value={audioUrl}
          size={200}
          level="H"
          includeMargin={true}
        />
      </Box>
      <Typography variant="body2" color="text.secondary" sx={{ mt: 2, textAlign: 'center' }}>
        Scan this QR code to access the audio version of "{title}"
      </Typography>
    </Paper>
  );
};

export default BookQRCode; 