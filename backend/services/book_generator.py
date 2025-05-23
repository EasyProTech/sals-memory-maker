import os
from typing import Dict, List, Optional
import openai
from PIL import Image, ImageDraw, ImageFont
import textwrap
import io
import base64
from dotenv import load_dotenv

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")

class BookGenerator:
    def __init__(self):
        self.image_width = 1200
        self.image_height = 800
        self.font_size = 36
        self.line_spacing = 10
        self.margin = 50

    async def generate_story(self, book_type: str, prompts: Dict[str, str]) -> List[Dict]:
        """Generate a story based on the book type and prompts."""
        if book_type == "children-story":
            return await self._generate_children_story(prompts)
        elif book_type == "spouse-roasting":
            return await self._generate_spouse_roasting(prompts)
        else:
            raise ValueError(f"Unknown book type: {book_type}")

    async def _generate_children_story(self, prompts: Dict[str, str]) -> List[Dict]:
        """Generate a children's story."""
        story_prompt = f"""Create a children's bedtime story for {prompts['name']}, who is {prompts['age']} years old.
        The story should be engaging and include elements about {prompts['interests']}.
        The story should be split into 5-7 pages, with each page being a short paragraph.
        Make it magical and educational."""

        response = await openai.ChatCompletion.acreate(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a children's story writer."},
                {"role": "user", "content": story_prompt}
            ]
        )

        story = response.choices[0].message.content
        pages = story.split('\n\n')
        
        return [{"text": page.strip(), "image_prompt": self._generate_image_prompt(page)} for page in pages]

    async def _generate_spouse_roasting(self, prompts: Dict[str, str]) -> List[Dict]:
        """Generate a spouse roasting book."""
        story_prompt = f"""Create a fun, light-hearted roasting book for {prompts['name']}.
        Include references to {prompts['interests']} and make it humorous but not mean-spirited.
        The story should be split into 5-7 pages, with each page being a short paragraph.
        Make it funny and personal."""

        response = await openai.ChatCompletion.acreate(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a humorous writer."},
                {"role": "user", "content": story_prompt}
            ]
        )

        story = response.choices[0].message.content
        pages = story.split('\n\n')
        
        return [{"text": page.strip(), "image_prompt": self._generate_image_prompt(page)} for page in pages]

    def _generate_image_prompt(self, text: str) -> str:
        """Generate an image prompt based on the text."""
        prompt = f"""Create a beautiful illustration for this text:
        {text}
        The illustration should be colorful, engaging, and suitable for a book page."""

        return prompt

    async def generate_image(self, prompt: str) -> str:
        """Generate an image using DALL-E."""
        response = await openai.Image.acreate(
            prompt=prompt,
            n=1,
            size="1024x1024"
        )

        return response.data[0].url

    def create_page_image(self, text: str, image_url: str) -> bytes:
        """Create a page image with text and background image."""
        # Create a new image with white background
        image = Image.new('RGB', (self.image_width, self.image_height), 'white')
        draw = ImageDraw.Draw(image)

        # Add watermark
        watermark = "PREVIEW"
        font = ImageFont.truetype("arial.ttf", 72)
        watermark_width = draw.textlength(watermark, font=font)
        watermark_height = 72
        watermark_x = (self.image_width - watermark_width) // 2
        watermark_y = (self.image_height - watermark_height) // 2
        draw.text((watermark_x, watermark_y), watermark, fill=(200, 200, 200, 128), font=font)

        # Add text
        font = ImageFont.truetype("arial.ttf", self.font_size)
        wrapped_text = textwrap.fill(text, width=40)
        draw.text((self.margin, self.margin), wrapped_text, fill='black', font=font)

        # Convert to bytes
        img_byte_arr = io.BytesIO()
        image.save(img_byte_arr, format='PNG')
        return img_byte_arr.getvalue()

    async def generate_audio(self, text: str, voice_type: str) -> str:
        """Generate audio narration for the text."""
        # TODO: Implement text-to-speech using appropriate service
        pass 