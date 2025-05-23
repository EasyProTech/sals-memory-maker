import os
import requests
from typing import Dict, List
from dotenv import load_dotenv

load_dotenv()

class PublishingService:
    def __init__(self):
        self.api_key = os.getenv("PUBLISHING_SERVICE_API_KEY")
        self.api_url = os.getenv("PUBLISHING_SERVICE_URL")
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }

    async def create_book_order(self, book_data: Dict, shipping_address: Dict) -> Dict:
        """Create a physical book order with the publishing service."""
        try:
            # Prepare the order data
            order_data = {
                "book_data": {
                    "title": book_data["title"],
                    "author": "Memory Maker",
                    "pages": book_data["pages"],
                    "cover_type": "hardcover",  # or "paperback"
                    "size": "8.5x11",  # Standard book size
                    "paper_type": "premium",
                    "color": True
                },
                "shipping": {
                    "name": shipping_address["name"],
                    "address1": shipping_address["address1"],
                    "address2": shipping_address.get("address2", ""),
                    "city": shipping_address["city"],
                    "state": shipping_address["state"],
                    "postal_code": shipping_address["postal_code"],
                    "country": shipping_address["country"]
                },
                "quantity": 1
            }

            # Send the order to the publishing service
            response = requests.post(
                f"{self.api_url}/orders",
                json=order_data,
                headers=self.headers
            )
            response.raise_for_status()

            return response.json()
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error creating book order: {str(e)}")

    async def get_order_status(self, order_id: str) -> Dict:
        """Get the status of a book order."""
        try:
            response = requests.get(
                f"{self.api_url}/orders/{order_id}",
                headers=self.headers
            )
            response.raise_for_status()

            return response.json()
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error getting order status: {str(e)}")

    async def get_shipping_estimate(self, shipping_address: Dict) -> Dict:
        """Get shipping cost and time estimate."""
        try:
            response = requests.post(
                f"{self.api_url}/shipping/estimate",
                json=shipping_address,
                headers=self.headers
            )
            response.raise_for_status()

            return response.json()
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error getting shipping estimate: {str(e)}")

    async def cancel_order(self, order_id: str) -> Dict:
        """Cancel a book order if it hasn't been printed yet."""
        try:
            response = requests.post(
                f"{self.api_url}/orders/{order_id}/cancel",
                headers=self.headers
            )
            response.raise_for_status()

            return response.json()
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error canceling order: {str(e)}")

    async def get_available_formats(self) -> List[Dict]:
        """Get available book formats and options."""
        try:
            response = requests.get(
                f"{self.api_url}/formats",
                headers=self.headers
            )
            response.raise_for_status()

            return response.json()
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error getting available formats: {str(e)}")

    async def validate_book_data(self, book_data: Dict) -> Dict:
        """Validate book data before sending to publishing service."""
        try:
            response = requests.post(
                f"{self.api_url}/validate",
                json=book_data,
                headers=self.headers
            )
            response.raise_for_status()

            return response.json()
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error validating book data: {str(e)}") 