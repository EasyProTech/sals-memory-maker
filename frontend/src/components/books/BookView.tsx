import React, { useState } from 'react';
import { 
  Box, 
  Typography, 
  Paper, 
  Grid, 
  Button, 
  useTheme, 
  useMediaQuery,
  IconButton
} from '@mui/material';
import { PlayArrow, Pause, VolumeUp } from '@mui/icons-material';
import BookQRCode from '../common/QRCode';
import { Book } from '../../types/book';

interface BookViewProps {
  book: Book;
}

const BookView: React.FC<BookViewProps> = ({ book }) => {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
  const [isPlaying, setIsPlaying] = useState(false);
  const [audio] = useState(new Audio(book.audioUrl));

  const toggleAudio = () => {
    if (isPlaying) {
      audio.pause();
    } else {
      audio.play();
    }
    setIsPlaying(!isPlaying);
  };

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} md={8}>
        <Paper 
          elevation={3} 
          sx={{ 
            p: isMobile ? 2 : 4,
            height: '100%',
            display: 'flex',
            flexDirection: 'column'
          }}
        >
          <Typography variant="h4" gutterBottom>
            {book.title}
          </Typography>
          <Typography variant="body1" paragraph>
            {book.description}
          </Typography>
          <Box sx={{ mt: 'auto', pt: 2 }}>
            <Button
              variant="contained"
              startIcon={isPlaying ? <Pause /> : <PlayArrow />}
              onClick={toggleAudio}
              fullWidth={isMobile}
            >
              {isPlaying ? 'Pause Audio' : 'Play Audio'}
            </Button>
          </Box>
        </Paper>
      </Grid>
      <Grid item xs={12} md={4}>
        <BookQRCode bookId={book.id} title={book.title} />
        <Paper 
          elevation={3} 
          sx={{ 
            mt: 2, 
            p: 2,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between'
          }}
        >
          <Typography variant="body2" color="text.secondary">
            Audio Book Available
          </Typography>
          <IconButton color="primary">
            <VolumeUp />
          </IconButton>
        </Paper>
      </Grid>
    </Grid>
  );
};

export default BookView; 